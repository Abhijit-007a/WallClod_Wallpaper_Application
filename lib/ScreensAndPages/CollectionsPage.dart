import 'dart:async';
import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/material.dart';
import 'package:wall_clod/Constants/constants.dart' as Constants;
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:wall_clod/APINetworking/networking.dart';
import 'package:wall_clod/Models/topic.dart';
import 'package:wall_clod/ScreensAndPages/CategoriesInsidePage.dart';
import 'package:wall_clod/Widgets/AppNetWorkImage.dart';
import 'package:wall_clod/Widgets/ErrorScreen.dart';
import 'package:wall_clod/Widgets/LoadingIndicator.dart';
import 'package:wall_clod/Widgets/LoadingIndicatorHome.dart';
import '../Helpers/helper.dart';

class AllCategoryScreen extends StatefulWidget {
  @override
  _AllCategoryScreenState createState() => _AllCategoryScreenState();
}

class _AllCategoryScreenState extends State<AllCategoryScreen>
    with AutomaticKeepAliveClientMixin<AllCategoryScreen> {
  ScrollController _scrollController = ScrollController();
  StreamSubscription _connectionChangeStream;
  bool get wantKeepAlive => true;
  int pageNumber = 1;
  List<Topics> topicsList = [];
  bool isOffline = false;

  void getCategory(int pageNumber) async {
    if (isOffline && await Helper().hasConnection() != true) {
      getLocalSavedData();
      return;
    }
    try {
      var data = await FetchImages().getCategory(pageNumber);
      setState(() {
        topicsList = data;
      });
      saveDataToLocal(json.encode(data));
    } catch (e) {
      getLocalSavedData();
      print(e);
    }
  }

  Future<void> getLocalSavedData() async {
    var saveData =
        await Helper().getSavedResponse(Constants.OFFLINE_TOPICS_KEY);
    if (saveData != null) {
      var data = jsonDecode(saveData);
      for (var i = 0; i < data.length; i++) {
        Topics topic = new Topics.fromJson(data[i]);
        setState(() {
          topicsList.add(topic);
        });
      }
    }
  }

  void saveDataToLocal(String data) {
    Helper().saveResponse(Constants.OFFLINE_TOPICS_KEY, data);
  }

  void loadMoreCategories() async {
    try {
      pageNumber = pageNumber + 1;
      var data = await FetchImages().getCategory(pageNumber);
      setState(() {
        topicsList.addAll(data);
      });
      saveDataToLocal(json.encode(topicsList));
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.offset >=
          _scrollController.position.maxScrollExtent &&
          !_scrollController.position.outOfRange) {
        loadMoreCategories();
      }
    });
    _connectionChangeStream = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) async {
      if (result != ConnectivityResult.none) {
        bool hasConnection = await DataConnectionChecker().hasConnection;
        setState(() {
          isOffline = !hasConnection;
        });
      }
    });
    getCategory(pageNumber);
  }



  @override
  void dispose() {
    _connectionChangeStream.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  // ignore: must_call_super
  Widget build(BuildContext context) {
    //var cellNumber = Helper().getMobileOrientation(context);
    return topicsList.length == 0
        ? LoadingIndicatorHome(
            isLoading2: true,
          )
        : StaggeredGridView.countBuilder(
              padding: const EdgeInsets.only(top: 10.0,bottom: 0.0,left: 10.0,right: 10.0),
              physics: BouncingScrollPhysics(),
              crossAxisCount: 2,
              controller: _scrollController,
              itemCount: topicsList.length + 1,
              itemBuilder: (BuildContext context, int index) {
                if(index == topicsList.length){
                  return LoadingIndicator(
                    isLoading: true,
                  );
                }else{
                  Topics topics = topicsList[index];
                  return GestureDetector(
                    onTap: () {
                      if (topics.coverPhoto != null) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TopicImagesScreen(topics: topics),
                          ),
                        );
                      } else {
                        Helper().showToast("Something went wrong");
                      }
                    },
                    child: Stack(
                      children: [
                        Hero(
                          tag: topics.id,
                          child: AppNetWorkImage(
                            blurHash: topics.coverPhoto != null
                                ? topics.coverPhoto.blurHash
                                : "LBAdAqof00WCqZj[PDay0.WB}pof",
                            height: topics.coverPhoto != null
                                ? topics.coverPhoto.height
                                : 200,
                            imageUrl: topics.coverPhoto != null
                                ? topics.coverPhoto.urls.small
                                : "",
                            width: topics.coverPhoto != null
                                ? topics.coverPhoto.width
                                : 200,
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(4),),
                            color: Colors.black.withOpacity(0.4),
                          ),
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            topics.title,
                            style: TextStyle(fontSize: 17, color: Colors.white),
                          ),
                        )
                      ],
                    ),
                  );
                }
              },
              staggeredTileBuilder: (int index) => StaggeredTile.fit(2),
              mainAxisSpacing: 10.0,
              crossAxisSpacing: 10.0,
            );
  }
}

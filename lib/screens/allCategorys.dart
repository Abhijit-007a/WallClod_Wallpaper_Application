import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:wall_clod/const/constants.dart' as Constants;
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:wall_clod/api/networking.dart';
import 'package:wall_clod/modal/topic.dart';
import 'package:wall_clod/screens/topicImagesScreen.dart';
import 'package:wall_clod/widget/appNetWorkImage.dart';
import 'package:wall_clod/widget/loadingView.dart';

import '../helper/helper.dart';

class AllCategoryScreen extends StatefulWidget {
  @override
  _AllCategoryScreenState createState() => _AllCategoryScreenState();
}

class _AllCategoryScreenState extends State<AllCategoryScreen>
    with AutomaticKeepAliveClientMixin<AllCategoryScreen> {
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
      var data = await FetchImages().getCategory();
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
        await Helper().getSavedResponse(Constants.OFFLINE_TOPICES_KEY);
    if (saveData != null) {
      var data = jsonDecode(saveData);
      for (var i = 0; i < data.length; i++) {
        Topics topics = new Topics.fromJson(data[i]);
        setState(() {
          topicsList.add(topics);
        });
      }
    }
  }

  void saveDataToLocal(String data) {
    Helper().saveReponse(Constants.OFFLINE_TOPICES_KEY, data);
  }

  @override
  void initState() {
    super.initState();
    getCategory(pageNumber);
  }

  @override
  // ignore: must_call_super
  Widget build(BuildContext context) {
    var cellNumber = Helper().getMobileOrientation(context);
    return topicsList.length == 0
        ? LoadingView(
            isSliver: false,
          )
        :
             StaggeredGridView.countBuilder(
              padding: const EdgeInsets.only(top: 10.0,bottom: 0.0,left: 10.0,right: 10.0),
              physics: BouncingScrollPhysics(),
              crossAxisCount: 2,
              itemCount: topicsList.length,
              itemBuilder: (BuildContext context, int index) {
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
              },
              staggeredTileBuilder: (int index) => StaggeredTile.fit(2),
              mainAxisSpacing: 10.0,
              crossAxisSpacing: 10.0,
            );
  }
}

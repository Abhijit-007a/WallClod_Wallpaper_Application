import 'dart:async';
import 'dart:convert';
import 'package:connectivity/connectivity.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:wall_clod/modal/appError.dart';
import 'package:wall_clod/modal/responeModal.dart';
import 'package:wall_clod/widget/appNetWorkImage.dart';
import 'package:wall_clod/widget/errorScreen.dart';
import 'package:wall_clod/widget/loadingIndicator.dart';
import 'package:wall_clod/widget/loadingView.dart';
import '../api/networking.dart';
import '../helper/helper.dart';
import 'imageView.dart';
import 'package:wall_clod/const/constants.dart' as Constants;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin<HomePage> {
  bool get wantKeepAlive => true;
  int pageNumber = 1;
  List<UnPlashResponse> unPlashResponse = [];
  ScrollController _scrollController = ScrollController();
  bool isOffline = false;
  ApiError apiError;
  StreamSubscription _connectionChangeStream;

  void getLatestImages(int pageNumber) async {
    setState(() {
      apiError = null;
    });
    if (isOffline && await Helper().hasConnection() != true) {
      getLocalSavedData();
      return;
    } else {
      try {
        var data = await FetchImages().getLatestImages(pageNumber);
        if (data is List<UnPlashResponse>) {
          setState(() {
            unPlashResponse = data;
          });
          saveDataToLocal(json.encode(data));
        } else {
          setState(() {
            apiError = data;
          });
        }
      } catch (e) {
        getLocalSavedData();
        print(e);
      }
    }
  }

  Future<void> getLocalSavedData() async {
    var saveData = await Helper().getSavedResponse(Constants.OFFLINE_SHOW_KEY);
    if (saveData != null) {
      var data = jsonDecode(saveData);
      for (var i = 0; i < data.length; i++) {
        UnPlashResponse item = new UnPlashResponse.fromJson(data[i]);
        setState(() {
          unPlashResponse.add(item);
        });
      }
    } else {}
  }

  void saveDataToLocal(String data) {
    Helper().saveReponse(Constants.OFFLINE_SHOW_KEY, data);
  }

  void loadMoreImages() async {
    try {
      pageNumber = pageNumber + 1;
      var data = await FetchImages().getLatestImages(pageNumber);
      setState(() {
        unPlashResponse.addAll(data);
      });
      saveDataToLocal(json.encode(unPlashResponse));
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
        loadMoreImages();
      }
    });
    _connectionChangeStream = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) async {
      if (result != ConnectivityResult.none) {
        bool hasConection = await DataConnectionChecker().hasConnection;
        setState(() {
          isOffline = !hasConection;
        });
      }
    });
    getLatestImages(pageNumber);
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
    var cellNumber = Helper().getMobileOrientation(context);
    return unPlashResponse.length == 0
        ? apiError == null
            ? LoadingView(
                isSliver: false,
              )
            : ErrorScreen(
                errorMessage: apiError.errors[0],
                tryAgain: getLatestImages,
              )
        :
        StaggeredGridView.countBuilder(
            padding: const EdgeInsets.only(top: 15.0,bottom: 0.0,left: 15.0,right: 15.0),
            crossAxisCount: 2,
            controller: _scrollController,
            itemCount: unPlashResponse.length + 1,
            itemBuilder: (BuildContext context, int index) {
              if (index == unPlashResponse.length) {
                return LoadingIndicator(
                  isLoading: true,
                );
              } else {
                UnPlashResponse item = unPlashResponse[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ImageView(unPlashResponse: unPlashResponse[index]),
                      ),
                    );
                  },
                  child: Hero(
                    tag: item.id,
                    child: AppNetWorkImage(
                      blurHash: item.blurHash,
                      height: item.height,
                      imageUrl: item.urls.small,
                      width: item.width,
                    ),
                  ),
                );
              }
            },
            staggeredTileBuilder: (int index) => StaggeredTile.count(1, 1.5),

            mainAxisSpacing: 15.0,
            crossAxisSpacing: 15.0,
    );
  }
}

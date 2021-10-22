import 'dart:async';
import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:wall_clod/Helpers/helper.dart';
import 'package:wall_clod/Models/responseModal.dart';
import 'package:wall_clod/Widgets/AppNetWorkImage.dart';
import 'package:wall_clod/Widgets/LoadingIndicator.dart';
import 'package:wall_clod/Widgets/LoadingIndicatorHome.dart';
import 'package:wall_clod/Widgets/LoadingView.dart';
import '../APINetworking/networking.dart';
import '../Models/appError.dart';
import '../Widgets/ErrorScreen.dart';
import 'ImageViewer.dart';
import 'package:wall_clod/Constants/constants.dart' as Constants;

class TrendingWallpaperPage extends StatefulWidget {
  @override
  _TrendingWallpaperPageState createState() => _TrendingWallpaperPageState();
}

class _TrendingWallpaperPageState extends State<TrendingWallpaperPage>
    with AutomaticKeepAliveClientMixin<TrendingWallpaperPage> {
  bool get wantKeepAlive => true;
  int pageNumber = 1;
  List<UnPlashResponse> unPlashResponse = [];
  bool isOffline = false;
  StreamSubscription _connectionChangeStream;
  ScrollController _scrollController = ScrollController();
  ApiError apiError;

  void getTrendingImages(int pageNumber) async {
    if (isOffline && await Helper().hasConnection() != true) {
      getLocalSavedData();
      return;
    }
    setState(() {
      apiError = null;
    });
    try {
      var data = await FetchImages().getTrendingImages(pageNumber);
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

  Future<void> getLocalSavedData() async {
    var saveData =
        await Helper().getSavedResponse(Constants.OFFLINE_TRENDING_KEY);
    if (saveData != null) {
      var data = jsonDecode(saveData);
      for (var i = 0; i < data.length; i++) {
        UnPlashResponse item = new UnPlashResponse.fromJson(data[i]);
        setState(() {
          unPlashResponse.add(item);
        });
      }
    } else {
      // Helper().showToast("No Offline Data To Show");
    }
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

  void saveDataToLocal(String data) {
    Helper().saveResponse(Constants.OFFLINE_TRENDING_KEY, data);
  }

  @override
  void initState() {
    super.initState();
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
    _scrollController.addListener(() {
      if (_scrollController.offset >=
              _scrollController.position.maxScrollExtent &&
          !_scrollController.position.outOfRange) {
        loadMoreImages();
      }
    });
    getTrendingImages(pageNumber);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _connectionChangeStream.cancel();
    super.dispose();
  }

  @override
  // ignore: must_call_super
  Widget build(BuildContext context) {
    var cellNumber = Helper().getMobileOrientation(context);
    return unPlashResponse.length == 0
        ? apiError == null
            ? LoadingIndicatorHome(
              isLoading2: true,
              )
            : ErrorScreen(
                errorMessage: apiError.errors[0],
                tryAgain: getTrendingImages,
              )
        : StaggeredGridView.countBuilder(
            padding: const EdgeInsets.only(top: 15.0,bottom: 0.0,left: 15.0,right: 15.0),
            crossAxisCount: 2,
            // physics: BouncingScrollPhysics(),
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

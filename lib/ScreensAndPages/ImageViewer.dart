
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:octo_image/octo_image.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:simple_gesture_detector/simple_gesture_detector.dart';
import 'package:wall_clod/Widgets/LoadingIndicatorHome.dart';
import 'package:wall_clod/database/dataBaseHelper/database_helper.dart';
import 'package:wall_clod/database/data_modal/favImage.dart';
import 'package:wall_clod/Models/responseModal.dart';
import 'package:wall_clod/Providers/favImageProvider.dart';
import 'package:wall_clod/Utilities/SetWallpaper.dart';
import 'package:wall_clod/Widgets/Favourite.dart';
import 'package:wall_clod/Widgets/InAppNotification.dart';

class ImageView extends StatefulWidget {

  final UnPlashResponse unPlashResponse;
  const ImageView({ Key key, this.unPlashResponse}) : super(key: key);

  @override
  _ImageViewState createState() => _ImageViewState();
}

class _ImageViewState extends State<ImageView> {

  final dbHelper = FavImageDatabaseHelper.instance;
  final Dio dio = Dio();
  bool loading = false;
  double progress = 0;

  Future<bool> saveImage(String url, String fileName) async {
    Directory directory;
    try {
      if (Platform.isAndroid) {
        if (await _requestPermission(Permission.storage)) {
          directory = await getExternalStorageDirectory();
          String newPath = "";
          print(directory);
          List<String> paths = directory.path.split("/");
          for (int x = 1; x < paths.length; x++) {
            String folder = paths[x];
            if (folder != "Android") {
              newPath += "/" + folder;
            } else {
              break;
            }
          }
          newPath = newPath + "/WallClod";
          directory = Directory(newPath);
        } else {
          return false;
        }
      } else {
        if (await _requestPermission(Permission.photos)) {
          directory = await getTemporaryDirectory();
        } else {
          return false;
        }
      }
      File saveFile = File(directory.path + "/$fileName");
      if (!await directory.exists()) {
        await directory.create(recursive: true);
      }
      if (await directory.exists()) {
        await dio.download(url, saveFile.path,
            onReceiveProgress: (value1, value2) {
              setState(() {
                progress = value1 / value2;
              });
            });
        if (Platform.isIOS) {
          await ImageGallerySaver.saveFile(saveFile.path,
              isReturnPathOfIOS: true);
        }
        return true;
      }
      return false;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> _requestPermission(Permission permission) async {
    if (await permission.isGranted) {
      return true;
    } else {
      var result = await permission.request();
      if (result == PermissionStatus.granted) {
        return true;
      }
    }
    return false;
  }

  downloadFile() async {
    setState(() {
      loading = true;
      progress = 0;
    });
    bool downloaded = await saveImage(
        widget.unPlashResponse.urls.full,
        widget.unPlashResponse.id + '.jpg');
    if (downloaded) {
      InAppNotification().imageDownloaded(
          context, Icons.done, Theme
          .of(context)
          .accentColor, 'Wallpaper Downloaded');
    } else {
      InAppNotification().imageDownloaded(
          context, Icons.error_outline, Colors.red, "Sorry, couldn't download wallpaper");
    }
    setState(() {
      loading = false;
    });
  }

    Future<void> likeUnlikeImage(favImageProvider) async {
      final dbHelper = FavImageDatabaseHelper.instance;
      final hasData =
      await dbHelper.hasData(widget.unPlashResponse.id.toString());
      if (!hasData) {
        FavImage favImage = new FavImage(
          widget.unPlashResponse.id.toString(),
          widget.unPlashResponse.urls.raw,
          widget.unPlashResponse.urls.full,
          widget.unPlashResponse.urls.regular,
          widget.unPlashResponse.urls.small,
          widget.unPlashResponse.urls.thumb,
          widget.unPlashResponse.blurHash,
        );
        favImageProvider.addImageToFav(favImage);
        InAppNotification().imageDownloaded(context, Icons.favorite,
            Color.fromRGBO(245, 7, 59, 1), 'Image added in your Favourites.');
      } else {
        InAppNotification().imageDownloaded(
            context, Icons.favorite, Colors.black,
            'Image is already added to your Favourites.');
      }
    }

    void _onVerticalSwipe(SwipeDirection direction) {
      if (direction == SwipeDirection.up) {
        Navigator.pop(context);
      } else {
        Navigator.pop(context);
      }
    }

    void _onHorizontalSwipe(SwipeDirection direction) {
      if (direction == SwipeDirection.left) {} else {}
    }


    @override
    Widget build(BuildContext context) {
      return Scaffold(
        backgroundColor: Color(0xFF272727),
        body: SimpleGestureDetector(
          onVerticalSwipe: _onVerticalSwipe,
          onHorizontalSwipe: _onHorizontalSwipe,
          swipeConfig: SimpleSwipeConfig(
            verticalThreshold: 40.0,
            horizontalThreshold: 40.0,
            swipeDetectionBehavior: SwipeDetectionBehavior.continuousDistinct,
          ),
          child: loading ? Padding(
            padding: const EdgeInsets.all(8.0),
            child: LinearProgressIndicator(
              minHeight: 30,
              value: progress,
            ),
          )
              : Stack(
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Hero(
                  tag: widget.unPlashResponse.id,
                  child: InteractiveViewer(
                    child: Container(
                      width: MediaQuery
                          .of(context)
                          .size
                          .width,
                      height: MediaQuery
                          .of(context)
                          .size
                          .height,
                      child: OctoImage(
                        image: CachedNetworkImageProvider(
                          widget.unPlashResponse.urls.regular,
                        ),
                        errorBuilder: OctoError.icon(color: Colors.red),
                        fit: BoxFit.fitHeight,
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 20.0,
                right: 10.0,
                left: 10.0,
                child: Container(
                  height: MediaQuery
                      .of(context)
                      .size
                      .height * 0.185,
                  decoration: new BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(20),
                    ),
                    gradient: new LinearGradient(
                        colors: [Color(0xFF272727), Color(0xFF272727)],
                        begin: Alignment.centerRight,
                        end: Alignment.centerLeft
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 30.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 50.0, top: 12.0, right: 50.0),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            CircularProfileAvatar('',
                              child: Image.network(widget.unPlashResponse.user
                                  .profileImage.medium),
                              //sets image path, it should be a URL string. default value is empty string, if path is empty it will display only initials
                              radius: 22,
                              borderWidth: 2,
                              borderColor: Colors.white,
                              // sets radius, default 50.0
                              elevation: 10,
                              // sets elevation (shadow of the profile picture), default value is 0.0
                              cacheImage: true,
                              // allow widget to cache image against provided url
                              imageFit: BoxFit.cover,
                            ),
                            SizedBox(width: 20.0,),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(widget.unPlashResponse.user.name,
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 16),),
                                Text("Powered by Unsplash", style: TextStyle(
                                    color: Colors.white, fontSize: 12),),
                              ],
                            ),
                            // new Spacer(),
                            // IconButton(
                            //   onPressed: () {
                            //     Navigator.push(
                            //       context,
                            //       MaterialPageRoute(
                            //         builder: (context) => AboutPhotographer(),
                            //       ),
                            //     );
                            //   },
                            //   alignment: Alignment.bottomRight,
                            //   icon: Icon(Icons.info,
                            //     size: 22,
                            //     color: Colors.white,
                            //   ),
                            // ),
                          ]
                      ),
                    ),
                    SizedBox(height: MediaQuery
                        .of(context)
                        .size
                        .height * 0.019),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: Icon(FontAwesomeIcons.arrowLeft,
                            size: 20,
                            color: Colors.white,
                          ),
                        ),
                        Consumer<FavImageProvider>(
                            builder: (context, favImageProvider, child) {
                              return Favourites(function: () {
                                likeUnlikeImage(favImageProvider);
                              });
                            }),
                        IconButton(
                          onPressed: () {
                            downloadFile();
                          },
                          icon: Icon(Icons.download_sharp,
                            size: 25,
                            color: Colors.white,
                          ),
                        ),
                        IconButton(
                          onPressed: () async {
                            await setWallpaper(context: context, imgUrl: widget.unPlashResponse.urls.regular);
                          },
                          icon: Icon(Icons.wallpaper,
                            size: 23,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
  }
}


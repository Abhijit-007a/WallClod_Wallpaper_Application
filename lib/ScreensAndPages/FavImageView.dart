import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:simple_gesture_detector/simple_gesture_detector.dart';
import 'package:wall_clod/database/dataBaseHelper/database_helper.dart';
import 'package:wall_clod/database/data_modal/favImage.dart';
import 'package:wall_clod/Models/responseModal.dart';
import 'package:wall_clod/Providers/favImageProvider.dart';
import 'package:wall_clod/Utilities/SetWallpaper.dart';
import 'package:wall_clod/Widgets/CustomNotificationOnPage.dart';
import 'package:wall_clod/Widgets/Favourite.dart';
import 'package:wall_clod/Widgets/InAppNotification.dart';

/*class FavImageView extends StatefulWidget {

  final FavImage favImage;
  final UnPlashResponse unPlashResponse;

  FavImageView({ Key key,this.favImage,this.unPlashResponse}) : super(key: key);

  @override
  _FavImageViewState createState() => _FavImageViewState();
}

class _FavImageViewState extends State<FavImageView> {
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
        widget.favImage.full,
        widget.favImage.imageid + '.jpg');
    if (downloaded) {
      InAppNotification().imageDownloaded(
          context, Icons.done, Theme.of(context).accentColor, 'Downloaded');
    } else {
      InAppNotification().imageDownloaded(
          context, Icons.error_outline, Colors.red, "Sorry, couldn't download");
    }
    setState(() {
      loading = false;
    });
  }

  Future<void> likeUnlikeImage(favImageProvider) async {
    final dbHelper = FavImageDatabaseHelper.instance;
    final hasData = await dbHelper.hasData(widget.favImage.imageid.toString());
    if (hasData) {
      favImageProvider.removeFavImage(widget.favImage.imageid);
      showOverlayNotification((context) {
        return CustomNotificationOnPage(
          icon: Icons.favorite,
          iconColor: Colors.black,
          subTitle: 'Image Removed form your Favourites.',
        );
      }, duration: Duration(milliseconds: 3000));
    } else {
      showOverlayNotification((context) {
        return CustomNotificationOnPage(
          icon: Icons.favorite,
          iconColor: Colors.black,
          subTitle: 'Image already Removed form Favourites.',
        );
      }, duration: Duration(milliseconds: 3000));
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
    if (direction == SwipeDirection.left) {
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:  Color(0xFF272727),
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
            Hero(
              tag: widget.favImage.imageid,
              child: InteractiveViewer(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: CachedNetworkImage(
                    imageUrl: widget.favImage.regular,
                    imageBuilder: (context, imageProvider) => Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 20.0,
              right: 10.0,
              left: 10.0,
              child: Container(
                height:MediaQuery.of(context).size.height * 0.10,
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
              padding: const EdgeInsets.only(bottom: 35.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Padding(
                  //   padding: const EdgeInsets.only(left: 50.0, top: 12.0),
                  //   child: Row(
                  //       mainAxisAlignment: MainAxisAlignment.start,
                  //       children:[
                  //         CircularProfileAvatar('',
                  //           child: Image.network(widget.favImage.profileimage),//sets image path, it should be a URL string. default value is empty string, if path is empty it will display only initials
                  //           radius: 22, // sets radius, default 50.0
                  //           elevation: 10,
                  //           borderWidth: 2,
                  //           borderColor: Colors.white,// sets elevation (shadow of the profile picture), default value is 0.0
                  //           cacheImage: true, // allow widget to cache image against provided url
                  //           imageFit: BoxFit.cover,
                  //         ),
                  //         SizedBox(width:30.0 ,),
                  //         Column(
                  //           mainAxisAlignment: MainAxisAlignment.start,
                  //           children: [
                  //             Text(widget.favImage.name,style: TextStyle(color: Colors.white,fontSize: 17),),
                  //             Text("Powered by Unsplash",style: TextStyle(color: Colors.white,fontSize: 12),),
                  //           ],
                  //         ),
                  //         SizedBox(width: MediaQuery.of(context).size.width * 0.19,),
                  //         IconButton(
                  //           onPressed: (){
                  //
                  //           },
                  //           icon: Icon(Icons.info,
                  //             size: 22,
                  //             color: Colors.white,
                  //           ),
                  //         ),
                  //       ]
                  //   ),
                  // ),
                  // SizedBox(height: 15.0,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        onPressed: (){
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
                        onPressed: (){
                          downloadFile();
                        },
                        icon: Icon(Icons.download_sharp,
                          size: 25,
                          color: Colors.white,
                        ),
                      ),
                      IconButton(
                        onPressed: () async {
                          setWallpaper(context: context, imgUrl: widget.favImage.regular);
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
}*/

class FavImageView extends StatefulWidget {

  final FavImage favImage;
  final UnPlashResponse unPlashResponse;

  FavImageView({ Key key,this.favImage,this.unPlashResponse}) : super(key: key);

  @override
  _FavImageViewState createState() => _FavImageViewState();
}

class _FavImageViewState extends State<FavImageView> {
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
        widget.favImage.full,
        widget.favImage.imageid + '.jpg');
    if (downloaded) {
      InAppNotification().imageDownloaded(
          context, Icons.done, Theme.of(context).accentColor, 'Downloaded');
    } else {
      InAppNotification().imageDownloaded(
          context, Icons.error_outline, Colors.red, "Sorry, couldn't download");
    }
    setState(() {
      loading = false;
    });
  }

  Future<void> likeUnlikeImage(favImageProvider) async {
    final dbHelper = FavImageDatabaseHelper.instance;
    final hasData = await dbHelper.hasData(widget.favImage.imageid.toString());
    if (hasData) {
      favImageProvider.removeFavImage(widget.favImage.imageid);
      showOverlayNotification((context) {
        return CustomNotificationOnPage(
          icon: Icons.favorite,
          iconColor: Colors.black,
          subTitle: 'Image Removed form your Favourites.',
        );
      }, duration: Duration(milliseconds: 3000));
    } else {
      showOverlayNotification((context) {
        return CustomNotificationOnPage(
          icon: Icons.favorite,
          iconColor: Colors.black,
          subTitle: 'Image already Removed form Favourites.',
        );
      }, duration: Duration(milliseconds: 3000));
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
    if (direction == SwipeDirection.left) {
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:  Color(0xFF272727),
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
            Hero(
              tag: widget.favImage.imageid,
              child: InteractiveViewer(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: CachedNetworkImage(
                    imageUrl: widget.favImage.regular,
                    imageBuilder: (context, imageProvider) => Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 20.0,
              right: 10.0,
              left: 10.0,
              child: Container(
                height:MediaQuery.of(context).size.height * 0.10,
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
              padding: const EdgeInsets.only(bottom: 35.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Padding(
                  //   padding: const EdgeInsets.only(left: 50.0, top: 12.0),
                  //   child: Row(
                  //       mainAxisAlignment: MainAxisAlignment.start,
                  //       children:[
                  //         CircularProfileAvatar('',
                  //           child: Image.network(widget.favImage.profileimage),//sets image path, it should be a URL string. default value is empty string, if path is empty it will display only initials
                  //           radius: 22, // sets radius, default 50.0
                  //           elevation: 10,
                  //           borderWidth: 2,
                  //           borderColor: Colors.white,// sets elevation (shadow of the profile picture), default value is 0.0
                  //           cacheImage: true, // allow widget to cache image against provided url
                  //           imageFit: BoxFit.cover,
                  //         ),
                  //         SizedBox(width:30.0 ,),
                  //         Column(
                  //           mainAxisAlignment: MainAxisAlignment.start,
                  //           children: [
                  //             Text(widget.favImage.name,style: TextStyle(color: Colors.white,fontSize: 17),),
                  //             Text("Powered by Unsplash",style: TextStyle(color: Colors.white,fontSize: 12),),
                  //           ],
                  //         ),
                  //         SizedBox(width: MediaQuery.of(context).size.width * 0.19,),
                  //         IconButton(
                  //           onPressed: (){
                  //
                  //           },
                  //           icon: Icon(Icons.info,
                  //             size: 22,
                  //             color: Colors.white,
                  //           ),
                  //         ),
                  //       ]
                  //   ),
                  // ),
                  // SizedBox(height: 15.0,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        onPressed: (){
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
                        onPressed: (){
                          downloadFile();
                        },
                        icon: Icon(Icons.download_sharp,
                          size: 25,
                          color: Colors.white,
                        ),
                      ),
                      IconButton(
                        onPressed: () async {
                          setWallpaper(context: context, imgUrl: widget.favImage.regular);
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


import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:simple_gesture_detector/simple_gesture_detector.dart';
import 'package:wall_clod/database/dataBaseHelper/database_helper.dart';
import 'package:wall_clod/database/data_modal/favImage.dart';
import 'package:wall_clod/provider/favImageProvider.dart';
import 'package:wall_clod/widget/CustomNotificationOnPage.dart';
import 'package:wall_clod/widget/Favourite.dart';
import 'package:wall_clod/widget/inAppNotificaion.dart';
import 'package:wallpaper_manager/wallpaper_manager.dart';

class FavImageView extends StatefulWidget {
  final FavImage favImage;

  FavImageView({this.favImage});

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

  Future<void> showInformationDialog(BuildContext context) async {
    return await showDialog(context: context,
        builder: (context){
          return StatefulBuilder(builder: (context,setState){
            return AlertDialog(
              elevation: 30,
              backgroundColor: Color(0xFF272727),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              content: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.wallpaper,color: Colors.white,size: 25,),
                  SizedBox(height: 20.0,),
                  Text("Set Wallpaper",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 20,letterSpacing: 3),),
                  SizedBox(height: 15.0,),
                  Text("For which screen do you want to set this wallpaper ?",style: TextStyle(color: Colors.white54,fontWeight: FontWeight.w400,fontSize: 17,),),
                  SizedBox(height: 15.0,),
                  ElevatedButton(
                      style: ButtonStyle(
                        elevation: MaterialStateProperty.all(10),
                        backgroundColor: MaterialStateProperty.all<Color>(Color(0xFF2b3f5c)),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              side: BorderSide(color: Color(0xFF2b3f5c))
                          ),
                        ),
                      ),
                      onPressed: (){setLockscreenWallpaper();},
                      child: Padding(
                        padding: const EdgeInsets.only(left: 17.0,right: 17.0,top: 7.0,bottom: 7.0),
                        child: Text("Set Lock Screen Wallpaper",style: TextStyle(fontSize: 16),),
                      )
                  ),
                  SizedBox(height: 5.0,),
                  ElevatedButton(
                      style: ButtonStyle(
                        elevation: MaterialStateProperty.all(10),
                        backgroundColor: MaterialStateProperty.all<Color>(Color(0xFF2b3f5c)),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              side: BorderSide(color: Color(0xFF2b3f5c))
                          ),
                        ),
                      ),
                      onPressed: (){setHomescreenWallpaper();},
                      child: Padding(
                        padding: const EdgeInsets.only(left: 17.0,right: 17.0,top: 7.0,bottom: 7.0),
                        child: Text("Set Home Screen Wallpaper",style: TextStyle(fontSize: 16),),
                      )
                  ),
                  SizedBox(height: 5.0,),
                  ElevatedButton(
                      style: ButtonStyle(
                        elevation: MaterialStateProperty.all(10),
                        backgroundColor: MaterialStateProperty.all<Color>(Color(0xFF2b3f5c)),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              side: BorderSide(color: Color(0xFF2b3f5c))
                          ),
                        ),
                      ),
                      onPressed: (){setBothscreenWallpaper();},
                      child: Padding(
                        padding: const EdgeInsets.only(left: 17.0,right: 17.0,top: 7.0,bottom: 7.0),
                        child: Text("Set Both Screen Wallpaper",style: TextStyle(fontSize: 16),),
                      )
                  ),
                  SizedBox(height: 5.0,),
                  ElevatedButton(
                      style: ButtonStyle(
                        elevation: MaterialStateProperty.all(10),
                        backgroundColor: MaterialStateProperty.all<Color>(Color(0xFF2b3f5c)),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              side: BorderSide(color: Color(0xFF2b3f5c))
                          ),
                        ),
                      ),
                      onPressed: (){Navigator.pop(context);},
                      child: Padding(
                        padding: const EdgeInsets.only(left: 17.0,right: 17.0,top: 7.0,bottom: 7.0),
                        child: Text("Cancel",style: TextStyle(fontSize: 16),),
                      )
                  ),
                ],
              ),
            );
          });
        });
  }


  Future<void> setHomescreenWallpaper() async {
    int location = WallpaperManager.HOME_SCREEN;

    var file = await DefaultCacheManager().getSingleFile(widget.favImage.regular);
    await WallpaperManager.setWallpaperFromFile(file.path, location);
  }

  Future<void> setLockscreenWallpaper() async {
    int location = WallpaperManager.LOCK_SCREEN;

    var file = await DefaultCacheManager().getSingleFile(widget.favImage.regular);
    await WallpaperManager.setWallpaperFromFile(file.path, location);
  }

  Future<void> setBothscreenWallpaper() async {
    int location = WallpaperManager.BOTH_SCREENS;

    var file = await DefaultCacheManager().getSingleFile(widget.favImage.regular);
    await WallpaperManager.setWallpaperFromFile(file.path, location);
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
                    /*placeholderBuilder: (context) => Center(
                      child: GradientText("WallClod",
                          gradient: LinearGradient(colors: [
                            Color.fromRGBO(254, 225, 64, 1),
                            Color.fromRGBO(245, 87, 108, 1),
                          ]),
                          style: TextStyle(
                            fontSize: 47,
                            letterSpacing: 1,
                          ),
                          textAlign: TextAlign.center),
                    ),*/
                    errorWidget: (context, url, error) => Icon(Icons.error),

                  ),
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 15,right: 15,bottom: 20),
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
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                          onPressed: (){
                            Navigator.pop(context);
                          },
                          icon: Icon(FontAwesomeIcons.arrowLeft,
                            size: 25,
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
                            size: 30,
                            color: Colors.white,
                          ),
                        ),
                        IconButton(
                          onPressed: () async {
                            showInformationDialog(context);
                          },
                          icon: Icon(Icons.wallpaper,
                            size: 30,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

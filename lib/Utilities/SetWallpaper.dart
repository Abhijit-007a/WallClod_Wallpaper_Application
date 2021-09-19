import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:wall_clod/Widgets/InAppNotification.dart';
import 'package:wallpaper_manager/wallpaper_manager.dart';
enum SetWallpaperAs { Home, Lock, Both }

const _setAs = {
  SetWallpaperAs.Home: WallpaperManager.HOME_SCREEN,
  SetWallpaperAs.Lock: WallpaperManager.LOCK_SCREEN,
  SetWallpaperAs.Both: WallpaperManager.BOTH_SCREENS,
};

Future<void> setWallpaper({
  @required BuildContext context,
  @required String imgUrl,
}) async {
  var actionSheet = CupertinoActionSheet(
    actions: <Widget>[
      Container(
        color: Color(0xFF272727),
        child: CupertinoActionSheetAction(
          onPressed: () {},
          child: const Text(
            'Set Wallpaper As',
            style: TextStyle(
                color: Colors.white),
          ),
        ),
      ),
      Container(
        color: Color(0xFF272727),
        child: CupertinoActionSheetAction(
          child: Text("Home Screen Wallpaper",
            style: TextStyle(
                color: Color(0xFF496a9c),
                fontSize: 15,
                letterSpacing: 2),),
          isDefaultAction: true,
          onPressed: () {
            Navigator.of(context).pop(SetWallpaperAs.Home);
          },
        ),
      ),
      Container(
        color: Color(0xFF272727),
        child: CupertinoActionSheetAction(
          child: Text("Lock Screen Wallpaper",
            style: TextStyle(
                color: Color(0xFF496a9c),
                fontSize: 15,
                letterSpacing: 2),),
          isDestructiveAction: true,
          onPressed: () {
            Navigator.of(context).pop(SetWallpaperAs.Lock);
          },
        ),
      ),
      Container(
        color: Color(0xFF272727),
        child: CupertinoActionSheetAction(
          child: Text("Both Screen Wallpaper",
            style: TextStyle(
                color: Color(0xFF496a9c),
                fontSize: 15,
                letterSpacing: 2),),
          isDestructiveAction: true,
          onPressed: () {
            Navigator.of(context).pop(SetWallpaperAs.Both);
          },
        ),
      )
    ],
    cancelButton: Container(
      color: Color(0xFF272727),
      child: CupertinoActionSheetAction(
        child: Text("Cancel", style: TextStyle(
            color: Colors.white70,
            fontSize: 17,
            letterSpacing: 2),),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    ),
  );

  SetWallpaperAs option = await showCupertinoModalPopup(
      context: context, builder: (context) => actionSheet);

  if (option != null) {
    var cachedImg = await DefaultCacheManager().getSingleFile(imgUrl);

    if (cachedImg != null) {
      var croppedImg = await ImageCropper.cropImage(
        sourcePath: cachedImg.path,
        aspectRatio: CropAspectRatio(
          ratioX: MediaQuery.of(context).size.width,
          ratioY: MediaQuery.of(context).size.height,
        ),
        androidUiSettings: AndroidUiSettings(
          toolbarColor: Color(0xFF2b3f5c),
          statusBarColor: Color(0xFF2b3f5c),
          toolbarWidgetColor: Colors.white,
          backgroundColor: Color(0xFF272727),
          toolbarTitle: 'Set Wallpaper',
          hideBottomControls: true,
        ),
      );

      try {
        if (croppedImg != null) {
          var result = await WallpaperManager.setWallpaperFromFile(
              croppedImg.path, _setAs[option]);
          if (result != null) {
            debugPrint(result);
          }
          InAppNotification().imageDownloaded(
              context, Icons.done, Theme
              .of(context)
              .accentColor, 'Wallpaper Set Successfully');
        }
      }on PlatformException {
        InAppNotification().imageDownloaded(
            context, Icons.done, Theme
            .of(context)
            .accentColor, 'Failed to get wallpaper.');
      }
    }
  }
}
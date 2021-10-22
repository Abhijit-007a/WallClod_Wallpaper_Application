import 'dart:io';
import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:wall_clod/Widgets/InAppNotification.dart';

class SaveImageScreen extends StatefulWidget {
  final List arguments;
  SaveImageScreen({this.arguments});
  @override
  _SaveImageScreenState createState() => _SaveImageScreenState();
}

class _SaveImageScreenState extends State<SaveImageScreen> {
  File image;
  bool savedImage;
  bool loading = false;
  int progress = 0;
  @override
  void initState() {
    super.initState();
    image = widget.arguments[0];
    savedImage = false;
  }

  Future saveImage() async {

    renameImage();
    await [Permission.storage].request();
    await GallerySaver.saveImage(image.path, albumName: "WallClod Editor");
    setState(() {
      savedImage = true;
      loading = true;
      progress = 0;
    });
    if (savedImage) {
      InAppNotification().imageDownloaded(
          context, Icons.done, Theme
          .of(context)
          .accentColor, 'Image Saved to Gallery');
    } else {
      InAppNotification().imageDownloaded(
          context, Icons.error_outline, Colors.red, "Sorry, couldn't save image");
    }
    setState(() {
      loading = false;
    });
  }

  void renameImage() {
    String ogPath = image.path;
    List<String> ogPathList = ogPath.split('/');
    String ogExt = ogPathList[ogPathList.length - 1].split('.')[1];
    DateTime today = new DateTime.now();
    String dateSlug =
        "${today.day.toString().padLeft(2, '0')}-${today.month.toString().padLeft(2, '0')}-${today.year.toString()}_${today.hour.toString().padLeft(2, '0')}-${today.minute.toString().padLeft(2, '0')}-${today.second.toString().padLeft(2, '0')}";
    image = image.renameSync(
        "${ogPath.split('/cache')[0]}/WallClod_Editor_$dateSlug.$ogExt");
    print(image.path);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.file(image,
            height: double.infinity,
            fit: BoxFit.cover,
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
                        CircularProfileAvatar('https://images.unsplash.com/photo-1488554378835-f7acf46e6c98?ixid=MnwxMjA3fDB8MHxzZWFyY2h8MTF8fGJsYWNrfGVufDB8fDB8fA%3D%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=400&q=60',
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
                        Text("My Captures", style: TextStyle(color: Colors.white, fontSize: 16),),
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
                    IconButton(
                    onPressed: savedImage
                    ? null
                        : () {
                    saveImage();
                    },
                    icon: Icon(Icons.download_sharp,
                        size: 25,
                        color: Colors.white,
                      ),
                    ),
                    IconButton(
                      onPressed: () async {
                        //String text =ImageUtils.fileToBase64(File(image.path));
                        //await setWallpaper(context: context, imgUrl: text);
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
      )
    );
  }
}
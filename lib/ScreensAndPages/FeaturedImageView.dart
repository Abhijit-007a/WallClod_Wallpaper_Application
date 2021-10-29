import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:simple_gesture_detector/simple_gesture_detector.dart';
import 'package:wall_clod/APINetworking/FirebaseAPI.dart';
import 'package:wall_clod/Models/FirebaseFile.dart';
import 'package:wall_clod/Utilities/SetWallpaper.dart';
import 'package:wall_clod/Widgets/InAppNotification.dart';

class FeaturedImageView extends StatelessWidget {
  final FirebaseFile file;

  const FeaturedImageView({
    Key key, this.file,
  }) : super(key: key);

    @override
    Widget build(BuildContext context) {

      final isImage = ['.jpeg', '.jpg', '.png'].any(file.name.contains);
      bool loading = false;
      double progress = 0;
      return Scaffold(
        backgroundColor: Color(0xFF272727),
          body: loading ? Padding(
            padding: const EdgeInsets.all(8.0),
            child: LinearProgressIndicator(
              minHeight: 30,
              value: progress,
            ),
          )
              : Stack(
            children: [
              isImage?
              Image.network(file.url,fit: BoxFit.cover,height: 900,width: double.infinity,)
              :Center(
                child: Text(
                  'Oops! Something Went Wrong',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
                           /*CircularProfileAvatar('',
                              child: Image.asset(name),
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
                            ),*/
                            SizedBox(width: 20.0,),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(file.name,
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 16),),
                                Text("Powered by WallClod", style: TextStyle(
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
                        IconButton(
                          onPressed: () async{
                            await FirebaseApi.downloadFile(file.ref);

                            InAppNotification().imageDownloaded(
                                context, Icons.done, Theme
                                .of(context)
                                .accentColor, 'Wallpaper Downloaded');
                          },
                          icon: Icon(Icons.download_sharp,
                            size: 25,
                            color: Colors.white,
                          ),
                        ),
                        IconButton(
                          onPressed: () async {
                            await setWallpaper(context: context, imgUrl: file.url);
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
      );
  }
}
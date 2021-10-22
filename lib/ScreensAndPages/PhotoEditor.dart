import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wall_clod/ScreensAndPages/EditPhotoScreen.dart';

class PhotoEditor extends StatefulWidget {

  @override
  _PhotoEditorState createState() => _PhotoEditorState();
}

class _PhotoEditorState extends State<PhotoEditor> {


  File _image ;
  final ImagePicker _picker = ImagePicker();

  Future getImageFromGallery() async{
    final image = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      _image = File(image.path);
    });
    Future.delayed(Duration(seconds: 0)).then(
            (value) => Navigator.push(
          context,
          CupertinoPageRoute(
            builder: (context) => EditPhotoScreen(
              arguments: [_image],
            ),
          ),
        ),
    );
  }

  Future getImageFromCamera() async{
    final image = await _picker.pickImage(source: ImageSource.camera);

    setState(() {
      _image = File(image.path);
    });
    Future.delayed(Duration(seconds: 0)).then(
          (value) => Navigator.push(
        context,
        CupertinoPageRoute(
          builder: (context) => EditPhotoScreen(
            arguments: [_image],
          ),
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF272727),
      body: Center(
      child:Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text('Upload your Image',style: TextStyle(color: Colors.white,fontSize: 18,letterSpacing: 4,fontWeight: FontWeight.w400),),
          SizedBox(height: MediaQuery.of(context).size.height * 0.05),
          Image.asset('assets/images/PhotoEditor.png'),
          SizedBox(height: MediaQuery.of(context).size.height * 0.07),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ElevatedButton(
                  onPressed: getImageFromGallery,
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Icon(Icons.file_upload),
                  ),
                style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        )
                    )
                ),
              ),
              ElevatedButton(
                  onPressed: getImageFromCamera,
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Icon(Icons.camera_alt),
                  ),
                style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                        )
                    )
                ),
              ),
            ],
          )
        ],
      )
      ),
    );
  }
}

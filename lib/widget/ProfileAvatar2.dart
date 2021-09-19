import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:flutter/material.dart';

class ProfileAvatar2 extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 110.0,right: 110.0,bottom: 10.0,top: 5.0),
      child: Center(
        child: CircularProfileAvatar('',
          child: Image.network('https://drive.google.com/uc?export=view&id=1xq7oR8nomaKjv1HOnRO3r2i3zMNKXFRc'),//sets image path, it should be a URL string. default value is empty string, if path is empty it will display only initials
          radius: 50, // sets radius, default 50.0
          borderWidth: 5,  // sets border, default 0.0
          borderColor: Colors.green, // sets border color, default Colors.white
          elevation: 20, // sets elevation (shadow of the profile picture), default value is 0.0
          cacheImage: true, // allow widget to cache image against provided url
          imageFit: BoxFit.cover,
          onTap: () {
            print('adil');
          }, // sets on tap
        ),
      ),
    );
  }
}

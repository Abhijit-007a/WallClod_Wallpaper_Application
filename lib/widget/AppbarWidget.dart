
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

AppBar buildAppBar(BuildContext context) {
  final icon = CupertinoIcons.moon_stars;

  return AppBar(
    backgroundColor: Color(0xFF2b3f5c),
    centerTitle: true,
    elevation: 50.0,
    title: Text('WallClod',
      style: TextStyle(letterSpacing: 5, fontFamily: 'Pacifico'),),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        bottom: Radius.circular(20),
      ),
    ),
    leading: IconButton(
      onPressed: () {
        Navigator.pop(context);
        },
      icon: Icon(Icons.arrow_back),),
  );
}
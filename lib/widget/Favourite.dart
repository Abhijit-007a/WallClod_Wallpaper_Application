import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Favourites extends StatelessWidget {

  final Function function;
  const Favourites({Key key, @required this.function}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () { function();},
      icon: Icon(FontAwesomeIcons.solidHeart,
        size: 20,
        color: Colors.white,
      ),
    );
  }
}

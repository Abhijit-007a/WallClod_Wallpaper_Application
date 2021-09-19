import 'package:flutter/material.dart';
import 'package:wall_clod/Widgets/AboutDevCardBody2.dart';

class AboutDevCard2 extends StatefulWidget {

  @override
  _AboutDevCard2State createState() => _AboutDevCard2State();
}

class _AboutDevCard2State extends State<AboutDevCard2> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 0, left: 15,right: 15,bottom: 5.0),
          child: Container(
          height: MediaQuery.of(context).size.height * 0.36,
            decoration: new BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(20),),
              color: Colors.purple,
              boxShadow: [
                BoxShadow(
                  color: Colors.black38,
                  blurRadius: 10.0, // soften the shadow
                  spreadRadius: 5.0, //extend the shadow
                  offset: Offset(
                    2.0, // Move to right 10  horizontally
                    2.0, // Move to bottom 10 Vertically
                  ),
                )
              ],
              gradient: new LinearGradient(
                  colors: [Color(0xFF04619F), Color(0xFF000000)],
                  begin: Alignment.centerRight,
                  end: Alignment.centerLeft
              ),
            ),
          ),
        ),
        AboutDevBody2(),
      ],
    );
  }
}

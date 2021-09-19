import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:wall_clod/Widgets/AboutDevCard1.dart';
import 'package:wall_clod/Widgets/AboutDevCard2.dart';
import 'package:wall_clod/Widgets/AboutDevHeadings.dart';

class AboutDeveloperPage extends StatefulWidget {
  const AboutDeveloperPage({Key key}) : super(key: key);

  @override
  _AboutDeveloperPageState createState() => _AboutDeveloperPageState();
}

class _AboutDeveloperPageState extends State<AboutDeveloperPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  AppBar(
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
      ),
      backgroundColor: Color(0xFF272727),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: 10.0,),
          Padding(
            padding: const EdgeInsets.only(left: 15.0),
            child: AboutDevHeadings(),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.01),
          AboutDevCard1(),
          SizedBox(height: MediaQuery.of(context).size.height * 0.02,),
          AboutDevCard2(),
        ],
      )
    );
  }
}

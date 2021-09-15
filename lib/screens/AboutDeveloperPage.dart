import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wall_clod/widget/AboutDevCard1.dart';
import 'package:wall_clod/widget/AboutDevCard2.dart';
import 'package:wall_clod/widget/AboutDevCardBody1.dart';
import 'package:wall_clod/widget/AboutDevHeadings.dart';
import 'package:wall_clod/widget/AppbarWidget.dart';
import 'package:wall_clod/widget/ProfileAvatar1.dart';

class AboutDeveloperPage extends StatefulWidget {
  const AboutDeveloperPage({Key key}) : super(key: key);

  @override
  _AboutDeveloperPageState createState() => _AboutDeveloperPageState();
}

class _AboutDeveloperPageState extends State<AboutDeveloperPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      backgroundColor: Color(0xFF272727),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: 10.0,),
          Padding(
            padding: const EdgeInsets.only(left: 15.0),
            child: AboutDevHeadings(),
          ),
          SizedBox(height: 10.0,),
          AboutDevCard1(),
          SizedBox(height: 20,),
          AboutDevCard2(),
        ],
      )
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wall_clod/screens/AboutDeveloperPage.dart';
import 'package:wall_clod/screens/FeedbackPage.dart';
import 'package:wall_clod/widget/SettingsMenu.dart';

class SettingsPage extends StatefulWidget {

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 12.0,top: 12.0,bottom: 12.0, left: 137.0),
            child: Row(
              children: [
                Icon(
                  Icons.settings,
                  color: Colors.blue,
                ),
                SizedBox(width: 20,),
                Text("Settings",
                  style: TextStyle(
                    fontSize: 17,
                    letterSpacing: 3,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 10,),
          Divider(height: 10,thickness: 2,color: Colors.white24,),
          SizedBox(height: 10,),
          SettingsMenu(
            text: "Help & Support Center",
            icon: "assets/images/helpdesk.png",
            press: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                  builder: (context) => FeedbackPage(),
                  ),
              );
            },
          ),
          SettingsMenu(
            text: "Rate Us",
            icon: "assets/images/star.png",
            press: () {

            },
          ),
          SettingsMenu(
            text: "Recommend your friends",
            icon: "assets/images/share.png",
            press: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AboutDeveloperPage(),
                ),
              );
            },
          ),
          SettingsMenu(
            text: "About Developers",
            icon: "assets/images/about.png",
            press: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AboutDeveloperPage(),
                ),
              );
            },
          ),
          SettingsMenu(
            text: "Buy me a coffee",
            icon: "assets/images/coffee.png",
            press: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AboutDeveloperPage(),
                ),
              );
            },
          ),
          SettingsMenu(
            text: "Version v1.0 ",
            icon: "assets/images/information.png",
            press: () {},
          ),
          SizedBox(height: 10,),
          Divider(height: 10,thickness: 2,color: Colors.white24,),
          Padding(
            padding: const EdgeInsets.only(top: 30.0,bottom: 12.0,),
            child: Column(
              mainAxisAlignment:MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("Powered by : Unsplash",
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white,
                  letterSpacing: 2
                ),
                ),
                SizedBox(height: 7,),
                Text("Developed by : Aesthetic Developers",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white,
                    letterSpacing: 2
                ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
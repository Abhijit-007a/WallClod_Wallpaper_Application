import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wall_clod/PaymentService/MainPaymentScreen.dart';
import 'package:wall_clod/ScreensAndPages/AboutDevelopersPage.dart';
import 'package:wall_clod/ScreensAndPages/FeedbackPage.dart';
import 'package:wall_clod/Widgets/SettingsMenu.dart';
import 'package:share/share.dart';

class SettingsPage extends StatefulWidget {

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {

  String _url = 'http://playstore.com';

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 12.0,top: 0.0,bottom: 12.0, left: 137.0),
            child: Row(
              children: [
                Icon(
                  Icons.settings,
                  color: Colors.blue,
                ),
                SizedBox(width: 15,),
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
          SizedBox( height: MediaQuery.of(context).size.height * 0.00001,),
          Divider(height: 5,thickness: 2,color: Colors.white24,),
          SizedBox(height: MediaQuery.of(context).size.height * 0.01,),
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
            text: "Recommend your friends",
            icon: "assets/images/share.png",
            press: () {
              Share.share('https://www.youtube.com/',subject: "Hey I found the best wallpaper application the Play Store. Have a try");
            },
          ),
          SettingsMenu(
            text: "Rate Us",
            icon: "assets/images/star.png",
            press: () {
              _launchURLPlayStore();
            },
          ),
          SettingsMenu(
            text: "Buy us a coffee",
            icon: "assets/images/coffee.png",
            press: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PaymentScreen(),
                ),
              );
            },
          ),
          SettingsMenu(
            text: "Version v1.0 ",
            icon: "assets/images/information.png",
            press: () {},
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.01,),
          Divider(height: 5,thickness: 2,color: Colors.white24,),
          Padding(
            padding: const EdgeInsets.only(top: 25.0,bottom: 10.0,),
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

  void _launchURLPlayStore() async =>
      await canLaunch(_url) ? await launch(_url) : throw 'Could not launch $_url';
}
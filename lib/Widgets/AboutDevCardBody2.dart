import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'ProfileAvatar2.dart';

class AboutDevBody2 extends StatefulWidget {

  @override
  _AboutDevBody2State createState() => _AboutDevBody2State();
}

class _AboutDevBody2State extends State<AboutDevBody2> {

  String _url1 = 'https://github.com/pritishprusty';
  String _url2 = 'https://www.linkedin.com/in/pritishprusty/';
  String _url3 = 'mailto:pritishprusty07@gmail.com';
  String _url4 = 'https://www.instagram.com/pritishprusty/';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ProfileAvatar2(),
            Padding(
              padding: const EdgeInsets.only(left: 125.0,right: 110.0,top: 15.0,bottom: 10.0),
              child: Text("Pritish Prusty",style: TextStyle(color: Colors.white,fontSize: 15,letterSpacing: 2),),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 150.0,right: 110.0),
              child: Text("Developer",style: TextStyle(color: Colors.white,fontSize: 12,letterSpacing: 2),),
            ),
            SizedBox(height: 10.0,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  onPressed: _launchUrl1,
                  icon: Icon(FontAwesomeIcons.github,
                    size: 25,
                    color: Colors.white,
                  ),
                ),
                IconButton(
                  onPressed: _launchUrl2,
                  icon: Icon(FontAwesomeIcons.linkedin,
                    size: 25,
                    color: Colors.white,
                  ),
                ),
                IconButton(
                  onPressed: _launchUrl3,
                  icon: Icon(FontAwesomeIcons.envelope,
                    size: 25,
                    color: Colors.white,
                  ),
                ),
                IconButton(
                  onPressed: _launchUrl4,
                  icon: Icon(FontAwesomeIcons.instagram,
                    size: 25,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ]
      ),
    );
  }

  void _launchUrl1() async =>
      await canLaunch(_url1)? await launch(_url1) : throw 'Could not launch $_url1';
  void _launchUrl2() async =>
      await canLaunch(_url2)? await launch(_url2) : throw 'Could not launch $_url2';
  void _launchUrl3() async =>
      await canLaunch(_url3)? await launch(_url3) : throw 'Could not launch $_url3';
  void _launchUrl4() async =>
      await canLaunch(_url4)? await launch(_url4) : throw 'Could not launch $_url4';
}

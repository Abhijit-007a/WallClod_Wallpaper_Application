

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Patreon extends StatefulWidget {

  @override
  _PatreonState createState() => _PatreonState();
}

class _PatreonState extends State<Patreon> {

  String _url1 = 'https://www.patreon.com/user?alert=2';


  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton.icon(
        icon: Icon(
          Icons.unsubscribe,
          color: Colors.pink,
          size: 24.0,
        ),
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.yellow),
        ),
        label: Text('Become a Patreon',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
        onPressed: () {
          _launchUrlBuyMeACoffee();
        },
      ),
    );
  }
  void _launchUrlBuyMeACoffee() async =>
      await canLaunch(_url1)? await launch(_url1) : throw 'Could not launch $_url1';
}

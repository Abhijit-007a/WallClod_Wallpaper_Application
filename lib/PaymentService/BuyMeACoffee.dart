import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class BuyMeACoffee extends StatefulWidget {

  @override
  _BuyMeACoffeeState createState() => _BuyMeACoffeeState();
}

class _BuyMeACoffeeState extends State<BuyMeACoffee> {

  String _url1 = 'https://www.buymeacoffee.com/AestheticDev';


  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton.icon(
        icon: Icon(
          Icons.coffee,
          color: Colors.pink,
          size: 24.0,
        ),
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.yellow),
        ),
        label: Text('Buy Me A Coffee',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
        onPressed: () {
          _launchUrlBuyMeACoffee();
        },
      ),
    );
  }
  void _launchUrlBuyMeACoffee() async =>
      await canLaunch(_url1)? await launch(_url1) : throw 'Could not launch $_url1';
}

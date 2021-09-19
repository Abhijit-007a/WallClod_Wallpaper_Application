import 'package:flutter/material.dart';

class SettingsMenu extends StatelessWidget {
  const SettingsMenu({
    Key  key,
    this.text,
    this.icon,
    this.press,
  }) : super(key: key);

  final String text, icon;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: TextButton(
        style: TextButton.styleFrom(
          primary: Colors.white,
          padding: EdgeInsets.only(left: 15,right: 15, top: 15,bottom: 15),
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          backgroundColor: Colors.white24,
        ),
        onPressed: press,
        child: Row(
          children: [
            Image.asset(
              icon,
              width: 25,
            ),
            SizedBox(width: 20),
            Expanded(child: Text(text)),
            Icon(Icons.arrow_forward_ios),
          ],
        ),
      ),
    );
  }
}
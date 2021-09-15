import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';


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
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: TextButton(
        style: TextButton.styleFrom(
          primary: Colors.white,
          padding: EdgeInsets.all(20),
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
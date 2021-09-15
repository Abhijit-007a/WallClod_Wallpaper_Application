import 'package:flutter/material.dart';

class AboutDevHeadings extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
          right: 12.0, top: 20.0, bottom: 12.0, left: 80.0),
      child: Row(
        children: [
          Icon(
            Icons.person_pin,
            color: Colors.yellowAccent,
          ),
          SizedBox(width: 10.0,),
          Text("About Developers",
            style: TextStyle(
              fontSize: 17,
              letterSpacing: 3,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wall_clod/Login_Signup/Screens/LoginWithPhonePage.dart';

class LoginButton extends StatefulWidget {
  @override
  _LoginButton createState() => _LoginButton();
}

class _LoginButton extends State<LoginButton> {


  @override
  Widget build(BuildContext context) {
    ElevatedButton.styleFrom(textStyle: const TextStyle(fontSize: 20));

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ElevatedButton.icon(
            icon: Icon(
              Icons.facebook,
              color: Colors.black,
              size: 25.0,
            ),
            label: Center(child: Text('                 Login With Facebook                        ')),
            onPressed: () {},
            style: ButtonStyle(
                padding: MaterialStateProperty.all(EdgeInsets.all(13)),
                foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
                backgroundColor: MaterialStateProperty.all<Color>(Colors.blueAccent),
                shadowColor: MaterialStateProperty.all<Color>(Colors.black54),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50.0),
                    )
                )
            ),
          ),

          SizedBox(height: 10),
          ElevatedButton.icon(
            icon: Icon(
              Icons.mail,
              color: Colors.black,
              size: 25.0,
            ),
            label: Center(child: Text('                 Login With Google                            ')),
            onPressed: () { },
            style: ButtonStyle(
                padding: MaterialStateProperty.all(EdgeInsets.all(13)),
                foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
                backgroundColor: MaterialStateProperty.all<Color>(Colors.redAccent),
                shadowColor: MaterialStateProperty.all<Color>(Colors.black54),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50.0),
                    )
                )
            ),
          ),
          SizedBox(height: 10),
          ElevatedButton.icon(
            icon: Icon(
              Icons.phone,
              color: Colors.black,
              size: 25.0,
            ),
            label: Center(child: Text('                 Login With Phone                            ')),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LoginAndSignupWithPhone()),
              );
            },
            style: ButtonStyle(
                padding: MaterialStateProperty.all(EdgeInsets.all(13)),
                foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
                backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
                shadowColor: MaterialStateProperty.all<Color>(Colors.black54),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50.0),
                    )
                )
            ),
          ),
        ],
      ),
    );
  }
}
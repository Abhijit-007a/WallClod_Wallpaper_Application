// import 'package:flutter/material.dart';
// import 'package:wall_clod/Login_Signup/Components/FadeAnimation.dart';
// import 'package:wall_clod/Login_Signup/Components/LoginButton.dart';
// import 'package:wall_clod/Login_Signup/Screens/SignupPage.dart';
//
//
// class LoginPage extends StatefulWidget {
//   @override
//   _LoginPage createState() => _LoginPage();
// }
//
// class _LoginPage extends State<LoginPage> {
//
//   @override
//   Widget build(BuildContext context) {
//
//
//     return Material(
//         child :Column(
//               children: <Widget>[
//                 Container(
//                   child: Column(
//                     children: <Widget>[
//                       SizedBox(height: 100.0,),
//                       FadeAnimation(1.0, Text("LOG IN", style: TextStyle(
//                           fontSize: 30,
//                           letterSpacing: 15,
//                           color: Colors.black,
//                           fontWeight: FontWeight.bold
//                           ),
//                         )
//                       ),
//                     ],
//                   ),
//                 ),
//                 SizedBox(height: 100.0,),
//                 Container(
//                   padding: EdgeInsets.symmetric(
//                       horizontal: 70
//                   ),
//                   child: Center(
//                     child: Image.asset("assets/images/group60.png"),
//                   ),
//                 ),
//                 SizedBox(height: 100.0,),
//                 LoginButton(),
//                 TextButton(
//                   child: Text('Create a new Account'),
//                   onPressed: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(builder: (context) => SignupPage()),
//                     );
//                   },
//                 ),
//               ],
//             )
//     );
//   }
// }
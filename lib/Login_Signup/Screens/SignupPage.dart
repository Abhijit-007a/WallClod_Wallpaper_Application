// import 'package:flutter/material.dart';
// import 'package:wall_clod/Login_Signup/Components/FadeAnimation.dart';
// import 'package:wall_clod/Login_Signup/Components/SignupButton.dart';
// import 'package:wall_clod/Login_Signup/Screens/LoginPage.dart';
//
//
// class SignupPage extends StatefulWidget {
//   @override
//   _SignupPage createState() => _SignupPage();
// }
//
// class _SignupPage extends State<SignupPage> {
//
//   @override
//   Widget build(BuildContext context) {
//
//
//     return Material(
//         child :Column(
//           children: <Widget>[
//             Container(
//               child: Column(
//                 children: <Widget>[
//                   SizedBox(height: 100.0,),
//                   FadeAnimation(1.0, Text("SIGN UP", style: TextStyle(
//                       fontSize: 30,
//                       letterSpacing: 15,
//                       color: Colors.black,
//                       fontWeight: FontWeight.bold
//                   ),
//                   )
//                   ),
//                 ],
//               ),
//             ),
//             SizedBox(height: 100.0,),
//             Container(
//               padding: EdgeInsets.symmetric(
//                   horizontal: 70
//               ),
//               child: Center(
//                 child: Image.asset("assets/images/group60.png"),
//               ),
//             ),
//             SizedBox(height: 100.0,),
//             SignupButton(),
//             TextButton(
//               child: Text('Back to Login'),
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => LoginPage()),
//                 );
//               },
//             ),
//           ],
//         )
//     );
//   }
// }
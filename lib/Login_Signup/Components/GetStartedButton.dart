//
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:wall_clod/Login_Signup/Screens/LoginPage.dart';
//
// class GetStaredButton extends StatefulWidget {
//   @override
//   _GetStaredButton createState() => _GetStaredButton();
// }
//
// class _GetStaredButton extends State<GetStaredButton> {
//
//
//   @override
//   Widget build(BuildContext context) {
//     ElevatedButton.styleFrom(textStyle: const TextStyle(fontSize: 20));
//
//
//
//     return Center(
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: <Widget>[
//               Padding(
//                 padding: const EdgeInsets.all(20.0),
//                 child: ElevatedButton(
//                     onPressed: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(builder: (context) => LoginPage()),
//                       );
//                     },
//                   style: ButtonStyle(
//                       padding: MaterialStateProperty.all(EdgeInsets.all(13)),
//                       foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
//                       backgroundColor: MaterialStateProperty.all<Color>(Colors.black),
//                       shadowColor: MaterialStateProperty.all<Color>(Colors.black54),
//                       shape: MaterialStateProperty.all<RoundedRectangleBorder>(
//                           RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(50.0),
//                           )
//                       )
//                   ),
//                   child: Center(
//                     child: Text(
//                       "Get Started",
//                       style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 16,
//                           fontWeight: FontWeight.bold
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         );
//   }
// }
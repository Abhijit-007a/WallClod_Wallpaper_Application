import 'package:flutter/material.dart';
import 'package:wall_clod/Login_Signup/Components/NumericPad.dart';

import 'OTPVerificationPage.dart';

class LoginAndSignupWithPhone extends StatefulWidget {
  @override
  _LoginAndSignupWithPhoneState createState() => _LoginAndSignupWithPhoneState();
}

class _LoginAndSignupWithPhoneState extends State<LoginAndSignupWithPhone> {

  String phoneNumber = "";

  @override
  Widget build(BuildContext context) {


    return Material(
        child: Column(
          children: <Widget>[
            Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: 50),
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 80,
                      ),
                      child: Center(
                        child: Image.asset("assets/images/group60.png"),
                      ),
                    ),
                    SizedBox(height: 10),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 14, horizontal: 74),
                      child: Text(
                        "You'll receive a 4 digit code to verify next.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 17,

                          color: Color(0xFF818181),
                        ),
                      ),
                    ),

                  ],
                ),
              ),
            Container(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Row(
                  children: <Widget>[
                    Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            "Enter your phone Number to verify:",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                            ),
                          ),

                          SizedBox(
                            height: 10,
                            width: 290,
                          ),

                          Text(
                            phoneNumber,
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),

                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => VerifyPhone(phoneNumber: phoneNumber)),
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.greenAccent,
                            borderRadius: BorderRadius.all(
                              Radius.circular(10),
                            ),
                          ),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 2,right: 2,top: 15,bottom: 15),
                              child: Icon(
                                Icons.arrow_forward_ios,
                                size: 25,
                                color: Color(0xFF1F1F1F),
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),



            NumericPad(
              onNumberSelected: (value) {
                setState(() {
                  if(value != -1){
                    phoneNumber = phoneNumber + value.toString();
                  }
                  else{
                    phoneNumber = phoneNumber.substring(0, phoneNumber.length - 1);
                  }
                }
                );
              },
            ),
          ],
        )
    );
  }
}
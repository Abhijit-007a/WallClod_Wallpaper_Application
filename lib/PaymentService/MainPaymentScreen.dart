import 'package:flutter/material.dart';
import 'package:wall_clod/PaymentService/BuyMeACoffee.dart';
import 'package:wall_clod/PaymentService/Patreon.dart';
import 'package:wall_clod/PaymentService/RazorpayPayment.dart';

class PaymentScreen extends StatefulWidget {

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF2b3f5c),
        centerTitle: true,
        elevation: 50.0,
        title: Text('WallClod', style: TextStyle(letterSpacing: 5,fontFamily: 'Pacifico'),),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
        ),
      ),
      backgroundColor: Color(0xFF272727),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 12.0, top: 20.0, bottom: 12.0, left: 70.0),
              child: Row(
                children: [
                  Icon(
                    Icons.coffee,
                    color: Colors.yellowAccent,
                  ),
                  SizedBox(width: 10.0,),
                  Text("Buy us a cup of Coffee",
                    style: TextStyle(
                      fontSize: 17,
                      letterSpacing: 3,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10.0,),
            Padding(
              padding: const EdgeInsets.only(left: 8.0,right: 8.0),
              child: Text("If you like what we at Aesthetic Developer are doing, "
                  "you can buy us a coffee and don't forget to appreciate us "
                  "on the play store by writing a small feedback about your experience.",
                  textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14,color: Colors.white38),
              ),
            ),
            SizedBox(height: 30.0,),
            RazorpayPayment(),
            SizedBox(height: 20.0,),
            BuyMeACoffee(),
            SizedBox(height: 20.0,),
            Patreon(),
          ],
        ),
      ),
    );
  }
}
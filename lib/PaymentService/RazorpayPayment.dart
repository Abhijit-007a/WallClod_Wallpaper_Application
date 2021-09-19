import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:wall_clod/Widgets/InAppNotification.dart';

class RazorpayPayment extends StatefulWidget {
  @override
  _RazorpayPaymentState createState() => _RazorpayPaymentState();
}

class _RazorpayPaymentState extends State<RazorpayPayment> {

  Razorpay _razorpay;
  TextEditingController _controller = TextEditingController();


  @override
  void initState() {
    _razorpay=Razorpay();
    super.initState();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
      Padding(
        padding: const EdgeInsets.only(left: 15.0,right: 15.0),
        child: TextField(
          controller: _controller,
          style: TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: 'Enter the Amount' ,
            hintStyle: TextStyle(fontSize: 11,color: Colors.white54),
            prefixIcon: const Icon(FontAwesomeIcons.rupeeSign, color: Colors.yellowAccent,),
            labelText: 'Amount',labelStyle: TextStyle(fontSize: 12,color: Colors.white),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide(
                color: Colors.white,
                width: 7,
              ),
            ),
          ),
        ),
      ),
      // SizedBox(height:20.0),
      // ElevatedButton(
      //   style: ButtonStyle(
      //     backgroundColor: MaterialStateProperty.all(Colors.yellow),
      //   ),
      //   child: Padding(
      //     padding: const EdgeInsets.only(left: 15.0,right: 15.0),
      //     child: Text('Pay with Razorpay',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
      //   ),
      //   onPressed: () {
      //     openCheckout();
      //   },
      // ),
    ]
    );
  }

  void openCheckout() async {
    var options = {
      'key': 'rzp_test_348vbbe81owJ42',
      'amount': (num.parse(_controller.text)*100).toString(),
      'name': 'Aesthetic Developers',
      'description': 'Thank You for your support',
      'prefill': {'contact': '', 'email': ''},
      'external': {
        'wallets': ['paytm']
      }
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint('Error: e');
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    InAppNotification().imageDownloaded(
        context, Icons.done, Theme.of(context).accentColor, 'Payment Success' + response.paymentId);
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    InAppNotification().imageDownloaded(
        context, Icons.done, Theme.of(context).accentColor, 'Payment Failed' + response.code.toString());
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    InAppNotification().imageDownloaded(
        context, Icons.done, Theme.of(context).accentColor, 'External Wallet' + response.walletName);
  }
}

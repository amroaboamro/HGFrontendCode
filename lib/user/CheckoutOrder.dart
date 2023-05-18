
import 'dart:convert';

import 'package:head_gasket/global.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
//rzp_test_59ZFuYiUqxL07G
//ZSejS4Ncus2RmkT0duo4DNKA

class RazorpayService {
  late Razorpay _razorpay;
  double orderPrice=0;
  var id;
  var delivery;
  Future<void> _sendOrder() async {
    final url = Uri.parse(global.ip + '/updateOrder/' + id);

    final orderData = {
      'delivery':delivery,
      'payment': 'Visa',
      'price': orderPrice.toString(),
      'status': 'Processing'
    };
    print(orderData);

    final response = await http.patch(url,
        body: jsonEncode(orderData),
        headers: {'Content-Type': 'application/json'}
    );
    print(response.body);

    if (response.statusCode == 200) {
      Fluttertoast.showToast(
        msg: 'Order sent successfully',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    } else {
      Fluttertoast.showToast(
        msg: 'Error sending order',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  void initialize() {
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    print("Payment Done");
    _sendOrder();
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    // Do something when payment fails
    print("Payment Fail");
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // Do something when an external wallet is selected
  }

  void pay( String amount) {
    var options = {
      'key': "rzp_test_59ZFuYiUqxL07G",
      'amount': (int.parse(amount) * 100)
          .toString(),
      'name': 'Flutter Store',
      'description': 'Payment for your order',
      'currency': 'USD',
      'timeout': 300,
      'prefill': {
        'contact': global.userData['phone'],
        'email': global.userData['email']
      }
    };
    _razorpay.open(options);
  }

  void clear() {
    _razorpay.clear();
  }
}
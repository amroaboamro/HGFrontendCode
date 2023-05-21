import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:head_gasket/global.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
//rzp_test_59ZFuYiUqxL07G
//ZSejS4Ncus2RmkT0duo4DNKA

class RazorpayService {
  late Razorpay _razorpay;
  var cartItems;
var function;

  void initialize() {
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }
  Future<void> _checkout() async {
print(cartItems);
    for (var item in cartItems) {
      final itemId = item.product.id;
      final quantity = item.quantity;
      print(itemId+'****'+quantity.toString());

      final url = global.ip+'/$itemId';
      final body = {'quantity': quantity.toString()}; // quantity users want to buy (subtract it from product quantity in database)

      final response = await http.patch(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(body),
      );

      if (response.statusCode == 200) {
        Fluttertoast.showToast(
          msg: 'Your Checkout placed successfully',
          backgroundColor: Colors.green,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
        );
        function();

      } else {

        print('Failed to update quantity for item $itemId');
      }
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    print("Payment Succeed");
    _checkout();
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
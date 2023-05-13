
import 'package:head_gasket/global.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
//rzp_test_59ZFuYiUqxL07G
//ZSejS4Ncus2RmkT0duo4DNKA

class RazorpayService {
  late Razorpay _razorpay;

  void initialize() {
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    print("Payment Done");
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
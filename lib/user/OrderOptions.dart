import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:head_gasket/Classes/Order.dart';
import 'package:head_gasket/Widget/background.dart';
import 'package:head_gasket/user/CheckoutOrder.dart';
import 'package:http/http.dart' as http;

class OrderOptions extends StatefulWidget {
  final Order order;

  OrderOptions({required this.order});

  @override
  _OrderOptionsState createState() => _OrderOptionsState();
}

class _OrderOptionsState extends State<OrderOptions> {
  final _razorpayService = RazorpayService();
  late double _price;
  String _subject1OptionSelected = 'Recovery vehicle';

  String _subject3OptionSelected = 'Visa Card';
  bool isVisa=true;

  // Method to update the price based on the user's selected options
  void _updatePrice(String subject, dynamic option) {
    setState(() {
      if (subject == 'Subject 1') {
        _subject1OptionSelected = option;
        if (option == 'Recovery vehicle') {
          _price += 20;
        } else if (option == 'by myself') {
          _price -= 20;
        }
      } else if (subject == 'Subject 3') {
        _subject3OptionSelected = option;
        if(option == 'Visa Card') isVisa=true;
        else isVisa=false;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _price = widget.order.price + 20;
    _razorpayService.initialize();
  }

  // Method to send the selected options for each subject to an API
  Future<void> _sendOrder() async {
    final url = Uri.parse(''+widget.order.id);

    final orderData = {
      'delivery': _subject1OptionSelected,
      'payment': _subject3OptionSelected,
      'price' : _price,
      'status': 'Processing'
    };
    print(orderData);

    final response = await http.post(url, body: json.encode(orderData));

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
      Navigator.of(context).pop();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Options'),
        backgroundColor: mainColor,
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.delivery_dining),
                Text(
                  ' Vehicle delivery method:',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10.0),
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: AssetImage('assets/images/recovery.jpg'),
                ),
                Expanded(
                  child: RadioListTile(
                    value: 'Recovery vehicle',
                    groupValue: _subject1OptionSelected,
                    onChanged: (value) => _updatePrice('Subject 1', value),
                    title: Text('Recovery vehicle'),
                  ),
                ),
                SizedBox(width: 10.0),
                Expanded(
                  child: RadioListTile(
                    value: 'by myself',
                    groupValue: _subject1OptionSelected,
                    onChanged: (value) => _updatePrice('Subject 1', value),
                    title: Text('By myself '),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.payment),
                Text(
                  'Payment:',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10.0),
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: AssetImage('assets/images/visa.jpg'),
                ),
                Expanded(
                  child: RadioListTile(
                    value: 'Visa Card',
                    groupValue: _subject3OptionSelected,
                    onChanged: (value) => _updatePrice('Subject 3', value),
                    title: Text('Visa Card'),
                  ),
                ),
                SizedBox(width: 10.0),

                Expanded(
                  child: RadioListTile(
                    value: 'On Delivery',
                    groupValue: _subject3OptionSelected,
                    onChanged: (value) => _updatePrice('Subject 3', value),
                    title: Text('On Delivery'),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Service',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      widget.order.serviceName,
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Location',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      widget.order.city +','+widget.order.street,
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 10.0),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'User',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      widget.order.user,
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Worker',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      widget.order.worker,
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),


              ],
            ),
            Text(
              'Details',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            SizedBox(height: 8),
            Text(
              widget.order.note,
              style: TextStyle(
                fontSize: 16,
              ),
            ),

            SizedBox(height: 30.0),
            Text(
              'Total Price: $_price',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),

            SizedBox(height: 30.0),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  if (isVisa) {
                    _razorpayService.pay(_price.toInt().toString());
                  } else {
                    _sendOrder();
                  }
                },
                child: Text(
                  'Place Order',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  primary: mainColor,
                  padding: EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
              ),
            )

          ],
        ),
      ),
    );
  }
}
//_razorpayService.pay(amount);

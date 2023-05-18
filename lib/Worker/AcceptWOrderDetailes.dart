import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../Classes/Order.dart';
import 'package:http/http.dart' as http;
import 'package:head_gasket/global.dart';

class OrderDetailsWidget extends StatefulWidget {
  final Order order;

  const OrderDetailsWidget({required this.order});

  @override
  _OrderDetailsWidgetState createState() => _OrderDetailsWidgetState();
}

class _OrderDetailsWidgetState extends State<OrderDetailsWidget> {
  final _formKey = GlobalKey<FormState>();
  late double _price;
  void sendData() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final response = await http.patch(
        Uri.parse(global.ip + '/updateOrder/'+widget.order.id),
        body: {
          'price': _price.toString(),
          'status': 'Waiting',
        },
      );

      if (response.statusCode == 200) {
        Fluttertoast.showToast(
          msg: 'Order placed successfully , now lets start Working!',
          backgroundColor: Colors.green,
        );
        Navigator.pop(context);
      } else {
        Fluttertoast.showToast(
          msg: 'Error accepting the order. Please try again later',
          backgroundColor: Colors.red,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Order Details',
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 16.0),
        Text(
          'Service: ${widget.order.serviceName} ',
          style: TextStyle(fontSize: 16.0),
        ),
        SizedBox(height: 8.0),
        Text(
          'Customer Name: ${widget.order.userName}',
          style: TextStyle(fontSize: 16.0),
        ),
        SizedBox(height: 8.0),
        Text(
          'Address: ${widget.order.city} ' + ',' + '${widget.order.street}',
          style: TextStyle(fontSize: 16.0),
        ),
        SizedBox(height: 8.0),
        Text(
          'Car Model : ${widget.order.carModel}',
          style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8.0),
        SizedBox(height: 16.0),
        Form(
          key: _formKey,
          child: TextFormField(
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Enter Price',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a price';
              }
              return null;
            },
            onSaved: (value) {
              _price = double.parse(value!);
            },
          ),
        ),
        SizedBox(height: 16.0),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              _formKey.currentState!.save();
              sendData();
            }
          },
          child: Text('Submit'),
          style: ElevatedButton.styleFrom(
            primary: Colors.green,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            padding: EdgeInsets.symmetric(vertical: 16.0),
          ),
        ),
      ],
    );
  }
}

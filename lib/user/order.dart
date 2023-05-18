import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:head_gasket/Classes/service.dart';
import 'package:head_gasket/Widget/background.dart';
import 'package:head_gasket/global.dart';
import 'package:head_gasket/user/ServicesScreen.dart';
import 'package:http/http.dart' as http;

class OrderPage extends StatefulWidget {
  final String serviceName;
  final String workerEmail;
  final String workerName;
  OrderPage({required this.serviceName, required this.workerEmail,required this.workerName});

  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  final _formKey = GlobalKey<FormState>();
  String? _firstName;
  String? _lastName;
  String? _email;
  String? _phone;
  String? _location;
  String? _carModel;
  String? _serviceName;
  String? _note;
  String? _workerEmail;
  String? _workerName;

  void _loadDataFromAPI() {
    _firstName = global.userData['firstName'];
    _lastName = global.userData['lastName'];
    _email = global.userData['email'];
    _phone = global.userData['phone'];
    _location = global.userData['city'] + ',' + global.userData['street'];
    _carModel = global.userData['carModel'];
    _note = '';
  }

  Future<void> _submitForm() async {
    try {
      final url = Uri.parse(global.ip + '/addOrder');
      final response = await http.post(url, body: {
        // 'major': _serviceName,
        // 'carBrand': _carBrand,
        // 'bio': _aboutWorker,
        // 'role': 'worker'
        // workeremail,useremail,Servicename,note,car model,location,
        'userEmail': _email,
        'userName': global.userData['firstName'] + ' '+ global.userData['lastName'],
        'carModel':_carModel,
        'city': global.userData['city'],
        'street': global.userData['street'],
        'workerEmail': _workerEmail,
        'workerName': _workerName,
        'note': _note,
        'serviceName': _serviceName,
        'status': 'Requested',
      });

      final responseData = json.decode(response.body);
      print(responseData);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('your order sent successfully'),
        ),
      );
      Navigator.pop(context);
    } catch (error) {
      Fluttertoast.showToast(
        msg: 'Failed to send the order',
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
  void initState() {
    super.initState();
    _loadDataFromAPI();
    _serviceName = widget.serviceName;
    _workerEmail = widget.workerEmail;
     _workerName = widget.workerName;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order'),
        centerTitle: true,
        backgroundColor: mainColor,
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage('https://picsum.photos/200'),
                  radius: 50.0,
                ),
                SizedBox(height: 16.0),
                Text(
                  'First Name',
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8.0),
                TextFormField(
                  readOnly: true,
                  style: TextStyle(fontSize: 16.0),
                  decoration: InputDecoration(
                    hintText: _firstName,
                    contentPadding: EdgeInsets.all(12.0),
                    filled: true,
                    fillColor: Colors.grey[100],
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
                SizedBox(height: 16.0),
                Text(
                  'Last Name',
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8.0),
                TextFormField(
                  readOnly: true,
                  style: TextStyle(fontSize: 16.0),
                  decoration: InputDecoration(
                    hintText: _lastName,
                    contentPadding: EdgeInsets.all(12.0),
                    filled: true,
                    fillColor: Colors.grey[100],
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
                SizedBox(height: 16.0),
                Text(
                  'Email',
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8.0),
                TextFormField(
                  readOnly: true,
                  style: TextStyle(fontSize: 16.0),
                  decoration: InputDecoration(
                    hintText: _email,
                    contentPadding: EdgeInsets.all(12.0),
                    filled: true,
                    fillColor: Colors.grey[100],
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
                SizedBox(height: 16.0),
                Text(
                  'Phone',
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8.0),
                TextFormField(
                  readOnly: true,
                  style: TextStyle(fontSize: 16.0),
                  decoration: InputDecoration(
                    hintText: _phone,
                    contentPadding: EdgeInsets.all(12.0),
                    filled: true,
                    fillColor: Colors.grey[100],
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
                SizedBox(height: 16.0),
                Text(
                  'Location',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8.0),
                TextFormField(
                  readOnly: true,
                  style: TextStyle(fontSize: 16.0),
                  decoration: InputDecoration(
                    hintText: _location,
                    contentPadding: EdgeInsets.all(12.0),
                    filled: true,
                    fillColor: Colors.grey[100],
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
                SizedBox(height: 16.0),
                Text(
                  'Car Model',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8.0),
                TextFormField(
                  readOnly: true,
                  style: TextStyle(fontSize: 16.0),
                  decoration: InputDecoration(
                    hintText: _carModel,
                    contentPadding: EdgeInsets.all(12.0),
                    filled: true,
                    fillColor: Colors.grey[100],
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  onChanged: (value) {
                    _carModel = value;
                  },
                ),
                SizedBox(height: 16.0),
                Text(
                  'Service Type',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8.0),
                TextFormField(
                  readOnly: true,
                  style: TextStyle(fontSize: 16.0),
                  decoration: InputDecoration(
                    hintText: _serviceName,
                    contentPadding: EdgeInsets.all(12.0),
                    filled: true,
                    fillColor: Colors.grey[100],
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
                SizedBox(height: 16.0),
                Text(
                  'Note',
                  style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: mainColor),
                ),
                SizedBox(height: 8.0),
                TextFormField(
                  initialValue: _note,
                  style: TextStyle(fontSize: 16.0),
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(12.0),
                    filled: true,
                    fillColor: Colors.grey[100],
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  onChanged: (value) {
                    _note = value;
                  },
                ),
                SizedBox(height: 16.0),
                Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    child: ElevatedButton(
                      onPressed: () {
                        _submitForm();
                      },
                      child: Text(
                        'Submit',
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                            horizontal: 32.0, vertical: 16.0),
                        primary: mainColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32.0),
                        ),
                        elevation: 3.0,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

import '../Widget/background.dart';

class ServiceForm extends StatefulWidget {
  @override
  _ServiceFormState createState() => _ServiceFormState();
}

class _ServiceFormState extends State<ServiceForm> {
  final _formKey = GlobalKey<FormState>();
  List<String> _services = [];

  String? _serviceName;
  String? _carBrand;
  String _aboutWorker = '';
  List<String> carBrands = [];

  Future<List<String>> fetchCarBrands() async {
    final response = await http.get(Uri.parse(''));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return List<String>.from(data);
    } else {
      throw Exception('Failed to fetch car brands');
    }

  }

  Future<List<String>> fetchServices() async {
    final response = await http.get(Uri.parse(''));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return List<String>.from(data);
    } else {
      throw Exception('Failed to fetch services');
    }

  }

  Future<void> _submitForm() async {

    try {
      final url = Uri.parse('');
      final response = await http.post(url, body: {
        'service_name': _serviceName,
        'car_brand': _carBrand,
        'about_worker': _aboutWorker,
      });

      final responseData = json.decode(response.body);
      print(responseData);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Service provider account created successfully'),
        ),
      );

      setState(() {
        _serviceName = '';
        _carBrand = '';
        _aboutWorker = '';
      });
    } catch (error) {
      Fluttertoast.showToast(
        msg: 'Failed to create service provider account',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  void initState() {
    super.initState();
    // Fetch the services list from the API and initialize the _services list
    fetchServices().then((services) {
      setState(() {
        _services = services;
      });
    });
    fetchCarBrands().then((brands) {
      setState(() {
        carBrands = brands;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mainColor,
        title: Text('Join as a Service Provider'),
      ),
      body: Background(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: 'Service Name',
                    ),
                    value: _serviceName,
                    items: _services.map((service) {
                      return DropdownMenuItem<String>(
                        value: service,
                        child: Text(service),
                      );
                    }).toList(),
                    validator: (value) {
                      if (value == null) {
                        return 'Please select a service name';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      setState(() {
                        _serviceName = value!;
                      });
                    },
                  ),

                  SizedBox(height: 20),
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: 'Car Brand',
                    ),
                    value: _carBrand,
                    items: carBrands.map((carBrand) {
                      return DropdownMenuItem<String>(
                        value: carBrand,
                        child: Text(carBrand),
                      );
                    }).toList(),
                    validator: (value) {
                      if (value == null) {
                        return 'Please select a car brand';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      setState(() {
                        _carBrand = value!;
                      });
                    },
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'About You',
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter some information about yourself';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      _aboutWorker = value;
                    },
                  ),
                  SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        if (_serviceName!.isEmpty ||
                            _carBrand!.isEmpty ||
                            _aboutWorker.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Please fill in all the fields'),
                            ),
                          );
                        } else {
                          _submitForm();
                        }
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 50.0,
                        vertical: 15.0,
                      ),
                      child: Text(
                        'Join',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: mainColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:head_gasket/Widget/background.dart';

class OrderPage extends StatefulWidget {
 final String serviceType;
 OrderPage({required this.serviceType});

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
  String? _serviceType;
  String? _note;

  // Function to load data from API and populate the form fields
  void _loadDataFromAPI() {
    // You can implement the API call and data loading logic here
    // and update the _firstName, _lastName, _email, etc. variables
    // with the fetched values.
    // For this example, we'll just hardcode some sample values:
    _firstName = 'John';
    _lastName = 'Doe';
    _email = 'johndoe@example.com';
    _phone = '555-1234';
    _location = 'New York, NY';
    _carModel = 'Toyota Camry';
    _note = '';
  }

  @override
  void initState() {
    super.initState();
    _loadDataFromAPI();
    _serviceType=widget.serviceType;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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

                SizedBox(height: 16.0),Text(
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

                SizedBox(height: 16.0),Text(
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
                    hintText: _serviceType,
                    contentPadding: EdgeInsets.all(12.0),
                    filled: true,
                    fillColor: Colors.grey[100],
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),

                SizedBox(height: 16.0),Text(
                  'Note',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: mainColor

                  ),
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
                      onPressed: () {},
                      child: Text(
                        'Submit',
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0), backgroundColor: mainColor,
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

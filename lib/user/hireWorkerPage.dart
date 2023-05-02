import 'package:flutter/material.dart';
import 'package:head_gasket/Classes/Worker.dart';

class HireWorkerPage extends StatefulWidget {
  final Worker worker;

  const HireWorkerPage({Key? key, required this.worker}) : super(key: key);

  @override
  _HireWorkerPageState createState() => _HireWorkerPageState();
}

class _HireWorkerPageState extends State<HireWorkerPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hire ${widget.worker.firstName}'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Please enter your information and a message to ${widget.worker.firstName}:',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20.0),
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Your Name',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20.0),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email Address',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email address';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20.0),
                TextFormField(
                  controller: _phoneController,
                  decoration: InputDecoration(
                    labelText: 'Phone Number',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your phone number';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20.0),
                TextFormField(
                  controller: _messageController,
                  maxLines: null,
                  decoration: InputDecoration(
                    labelText: 'Message',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a message';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 40.0),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        // Call the API to send the data
                        // Here you can replace the print statements with API call
                        print('Name: ${_nameController.text}');
                        print('Email: ${_emailController.text}');
                        print('Phone: ${_phoneController.text}');
                        print('Message: ${_messageController.text}');
                        Navigator.pop(context);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.blue,
                      padding: EdgeInsets.symmetric(
                        horizontal: 40.0,
                        vertical: 20.0,
                      ),
                      textStyle: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    child: Text('Send Message'),
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

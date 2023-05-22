import 'package:flutter/material.dart';
import 'package:head_gasket/Widget/background.dart';

class AboutUsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About Us'),
        backgroundColor: mainColor,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                color: mainColor,
                child: Image.asset(
                  'assets/images/logo.png', // Replace with your logo image path
                  width: 300.0,
                  height: 250.0,
                ),
              ),
              SizedBox(height: 20.0),
              Text(
                'Head Gasket APP',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10.0),
              Text(
                'Version 1.0.0',
                style: TextStyle(fontSize: 16.0),
              ),
              SizedBox(height: 20.0),
              Text(
                'We are dedicated to providing the best car maintenance solutions to our customers. Our app helps you keep track of your vehicle\'s service history, schedule maintenance appointments, and receive timely reminders for oil changes, tire rotations, and more.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16.0),
              ),
              SizedBox(height: 20.0),
              Text(
                'Contact Us',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10.0),
              Text(
                'Phone: +1 123-456-7890',
                style: TextStyle(fontSize: 16.0),
              ),
              Text(
                'Email: info@headgasketapp.com',
                style: TextStyle(fontSize: 16.0),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

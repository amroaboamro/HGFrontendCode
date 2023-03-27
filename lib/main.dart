import 'package:flutter/material.dart';
import 'package:head_gasket/ResetPass.dart';
import 'package:head_gasket/test.dart';
import 'login.dart';
import 'sign_up.dart';
import 'package:head_gasket/Home.dart';
import 'profile.dart';
import 'profileDetails.dart';
import 'test.dart';
import 'ForgetPassword.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Head Gasket',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch:Colors.blueGrey,
        scaffoldBackgroundColor: Colors.blueGrey.shade50,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home:SignUpScreen(),
    );
  }
}

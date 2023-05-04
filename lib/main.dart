import 'package:flutter/material.dart';
import 'package:head_gasket/Classes/service.dart';
import 'package:head_gasket/ResetPass.dart';
import 'package:head_gasket/HomePage.dart';
import 'package:head_gasket/test.dart';
import 'package:head_gasket/user/Checkout.dart';
import 'package:head_gasket/user/JoinASProvider.dart';
import 'package:head_gasket/user/MyOrders.dart';
import 'package:head_gasket/user/Store.dart';
import 'package:head_gasket/user/profilePage.dart';
import 'login.dart';
import 'sign_up.dart';
import 'package:head_gasket/Home.dart';
import 'HomePage.dart';
import 'ForgetPassword.dart';
import 'user/ServicesScreen.dart';

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
        primarySwatch: Colors.blueGrey,
        scaffoldBackgroundColor: Colors.blueGrey.shade50,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home:LoginScreen(),
    );
  }
}

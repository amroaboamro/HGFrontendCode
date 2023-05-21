import 'package:flutter/material.dart';
import 'package:head_gasket/Admin/AdminHome.dart';
import 'package:head_gasket/Worker/WMyOrder.dart';
import 'package:head_gasket/login.dart';
import 'package:head_gasket/user/MyOrders.dart';
import 'package:head_gasket/user/OrderOptions.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
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
      home: LoginScreen(),
    );
  }
}

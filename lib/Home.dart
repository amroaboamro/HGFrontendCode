import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:head_gasket/Widget/background.dart';
import 'package:head_gasket/profile.dart';
import 'package:head_gasket/profileDetails.dart';
import 'package:head_gasket/services.dart';
import 'package:head_gasket/test.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

int _page = 0;
final List<Widget> _children = [
  Test(),
  Services(),
  ProfileDetails(),
  ProfileDetails(),
  ProfileDetails(),
];

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _children[_page],
      bottomNavigationBar: CurvedNavigationBar(
        color: mainColor,
        onTap: (index) {
          setState(() {
            _page = index;
          });
        },
        buttonBackgroundColor: Colors.blueGrey.shade200,
        backgroundColor: Colors.blueGrey.shade50,
        height: 45,
        items: [
          Icon(
            Icons.home,
            color: Colors.white,
            size: 20,
          ),
          Icon(
            Icons.directions_car_sharp,
            color: Colors.white,
            size: 20,
          ),
          Icon(
            Icons.local_grocery_store,
            color: Colors.white,
            size: 20,
          ),
          Icon(
            Icons.local_offer_rounded,
            color: Colors.white,
            size: 20,
          ),
          Icon(
            Icons.account_circle,
            color: Colors.white,
            size: 20,
          ),
        ],
      ),
    );
  }
}

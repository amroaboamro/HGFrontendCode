import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:head_gasket/Widget/background.dart';
import 'package:head_gasket/Worker/HomePage.dart';
import 'package:head_gasket/global.dart';
import 'package:head_gasket/user/ServicesScreen.dart';
import 'package:head_gasket/user/MyOrders.dart';
import 'package:head_gasket/user/Store.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;

class WorkerHome extends StatefulWidget {
  final userId;

  WorkerHome({Key? key, required this.userId}) : super(key: key);

  @override
  State<WorkerHome> createState() => _WorkerHomeState();
}

class _WorkerHomeState extends State<WorkerHome> {
  int _page = 0;
  final List<Widget> _children = [
    WorkerHomePage(),
    Services(),
    StorePage(),
    MyOrders(),
  ];
  Future<Map<String, dynamic>> fetchUserData(String userId) async {
    /* print(userId);
    print(global.token);


    final response = await http.get(
      Uri.parse(global.ip + '/userInfo/'+global.userEmail),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${global.token}'
      },
    );

    // final response = await http.get(Uri.parse(global.ip+'/userInfo/mostafa234567@com'));

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      print(data);
      return data;
    } else {
      // If unsuccessful, throw an error
      print("fffffffffffff");
      throw Exception('Failed to fetch user data');
    }*/
    return Future.delayed(Duration(seconds: 2), () {
      return {
        "firstName": "Amr",
        "lastName": "abo Amr",
        "major": "Plumber",
        "rating": 4.5,
        "imageUrl": "assets/images/key.jpg",
        "phone": "555-1234",
        "email": "johndoe@example.com",
        "city": "Miami",
        "street": "123 Main St",
        "latitude": 25.7743,
        "longitude": -80.1937,
        "bio":
            "I'm a plumber with over 10 years of experience. Call me for all your plumbing needs!",
        "carBrand":"BMW",
      };
    });
  }

  @override
  void initState() {
    global.userEmail = widget.userId;
    super.initState();
    fetchUserData(widget.userId).then((data) {
      setState(() {
        _children[0] = WorkerHomePage();
      });
      global.userData = data;
      print(global.userData);
    }).catchError((error) {
      print(error);
    });
  }

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
        ],
      ),
    );
  }
}

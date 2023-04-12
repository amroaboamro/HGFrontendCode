import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:head_gasket/Widget/background.dart';
import 'package:head_gasket/profileDetails.dart';
import 'package:head_gasket/user/ServicesScreen.dart';
import 'package:head_gasket/HomePage.dart';
import 'package:head_gasket/user/EditProfile.dart';
import 'package:head_gasket/user/MyOrders.dart';
import 'user/profilePage.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Home extends StatefulWidget {
  final userId;



  Home({Key? key,required this.userId}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {


  var  _userData;
  int _page = 0;
   final List<Widget> _children = [
    HomePage(userData:{
      'name' : '---',
      'email': '-----',
      'carModel' : '-----',
    } , ),
    Services(),

     MyOrders(),
     MyOrders(),




   ];

  Future <Map<String,dynamic>> fetchUserData(String userId) async {
  // final response=await http.get(Uri.parse('' + userId));
  //
  // if(response.statusCode == 200){
  //   var data = json.decode(response.body);
  //   return data;
  // }
  // else {
  //   // If unsuccessful, throw an error
  //   throw Exception('Failed to fetch user data');
  // }
  return Future.delayed(Duration(seconds:5) , (){
    return {
      'name' : 'Amro',
      'email': 'email@email.com',
      'carModel' : 'Mercedes Benz E350',
    };
  });



}

  @override
  void initState() {
    super.initState();
     fetchUserData(widget.userId).then((data) {
      setState(() {
        _userData = data;
        _children[0] = HomePage(userData: _userData);
      });

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

import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:head_gasket/Widget/background.dart';
import 'package:head_gasket/global.dart';
import 'package:head_gasket/user/ServicesScreen.dart';
import 'package:head_gasket/HomePage.dart';
import 'package:head_gasket/user/MyOrders.dart';
import 'package:head_gasket/user/Store.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;

import 'main.dart';

class Home extends StatefulWidget {
  final userId;

  Home({Key? key, required this.userId}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Future checkIfNotify() async{

    var res= await http.get(Uri.parse(global.ip+"/users/notify"),headers: {
      'Content-Type': 'application/json; charset=UTF-8',
    });

    if(true) {
      //  Map<String, dynamic> DB = jsonDecode(res.body);
      if (true) {
        FirebaseMessaging.onMessage.listen((RemoteMessage message) {
          RemoteNotification? notification = message.notification;
          AndroidNotification? android = message.notification?.android;
          if (notification != null && android != null) {
            flutterLocalNotificationsPlugin.show(
                notification.hashCode,
                notification.title,
                notification.body,
                NotificationDetails(
                  android: AndroidNotificationDetails(
                    channel.id,
                    channel.name,
                    color: Colors.pink,
                    playSound: true,
                    icon: '@mipmap/ic_launcher',
                  ),
                ));
          }
        });
        FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
          print('A new onMessageOpenedApp event was published!');
          RemoteNotification? notification = message.notification;
          AndroidNotification? android = message.notification?.android;
          if (notification != null && android != null) {
            showDialog(
                context: context,
                builder: (_) {
                  return AlertDialog(
                    title: Text("${notification.title}"),
                    content: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [Text("${notification.body}")],
                      ),
                    ),
                  );
                });
          }
        });
        flutterLocalNotificationsPlugin.show(
            0,
            "Imprtant Meassge!",
             "marked your class as completed",
            NotificationDetails(
                android: AndroidNotificationDetails(channel.id, channel.name,
                    importance: Importance.high,
                    color: Colors.blue,
                    playSound: true,
                    icon: '@mipmap/ic_launcher')));
      }
    }
  }
  var _userData;
  int _page = 0;
  final List<Widget> _children = [
    HomePage(
      userData: {
        'firstName': '---',
        'lastName': '---',
        'email': '-----',
        'carModel': '-----',
      },
    ),
    Services(),
    StorePage(),
    MyOrders(),
  ];

  Future<Map<String, dynamic>> fetchUserData(String userId) async {
    print(userId);
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
    }
    // return Future.delayed(Duration(seconds: 5), () {
    //   return {
    //     'name': 'Amro',
    //     'email': 'email@email.com',
    //     'carModel': 'Mercedes Benz E350',
    //   };
    // });
  }

  @override
  void initState() {
    global.userEmail = widget.userId;
    super.initState();
    fetchUserData(widget.userId).then((data) {
      global.userData = data;
      print(global.userData);
      setState(() {
        _userData = data;
        _children[0] = HomePage(userData: _userData);
      });
    }).catchError((error) {
      print(error);
    });
    checkIfNotify();

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

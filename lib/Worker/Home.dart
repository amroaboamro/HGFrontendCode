import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:head_gasket/Widget/background.dart';
import 'package:head_gasket/Worker/HomePage.dart';
import 'package:head_gasket/Worker/WMyOrder.dart';
import 'package:head_gasket/Worker/timePlanning.dart';
import 'package:head_gasket/global.dart';
import 'package:head_gasket/user/ServicesScreen.dart';
import 'package:head_gasket/user/MyOrders.dart';
import 'package:head_gasket/user/Store.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:blurry_modal_progress_hud/blurry_modal_progress_hud.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../main.dart';

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
    OrdersPage(),
    EventCalendarPage(),
  ];
  Future<Map<String, dynamic>> fetchUserData(String userId) async {
    print(userId);
    print(global.token);

    final response = await http.get(
      Uri.parse(global.ip + '/userInfo/' + global.userEmail),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${global.token}'
      },
    );

    // final response = await http.get(Uri.parse(global.ip+'/userInfo/mostafa234567@com'));

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
    
      return data;
    } else {
      throw Exception('Failed to fetch user data');
    }
  }
  // Future checkIfNotify() async{
  //
  //   if (global.userData['workerNotify']!="n") {
  //     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
  //       RemoteNotification? notification = message.notification;
  //       AndroidNotification? android = message.notification?.android;
  //       if (notification != null && android != null) {
  //         flutterLocalNotificationsPlugin.show(
  //             notification.hashCode,
  //             notification.title,
  //             notification.body,
  //             NotificationDetails(
  //               android: AndroidNotificationDetails(
  //                 channel.id,
  //                 channel.name,
  //                 color: Colors.pink,
  //                 playSound: true,
  //                 icon: '@mipmap/ic_launcher',
  //               ),
  //             ));
  //       }
  //     });
  //     FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
  //
  //       RemoteNotification? notification = message.notification;
  //       AndroidNotification? android = message.notification?.android;
  //       if (notification != null && android != null) {
  //         showDialog(
  //             context: context,
  //             builder: (_) {
  //               return AlertDialog(
  //                 title: Text("${notification.title}"),
  //                 content: SingleChildScrollView(
  //                   child: Column(
  //                     crossAxisAlignment: CrossAxisAlignment.start,
  //                     children: [Text("${notification.body}")],
  //                   ),
  //                 ),
  //               );
  //             });
  //       }
  //     });
  //     flutterLocalNotificationsPlugin.show(
  //         0,
  //         "News!",
  //         global.userData['workerNotify'],
  //         NotificationDetails(
  //             android: AndroidNotificationDetails(channel.id, channel.name,
  //                 importance: Importance.high,
  //                 color: Colors.blue,
  //                 playSound: true,
  //                 icon: '@mipmap/ic_launcher')));
  //     final response = await http.patch(
  //       Uri.parse(global.ip + '/userUpdate/'+global.userEmail),
  //       body: {
  //         'workerNotify': "n",
  //       },
  //     );
  //     if(response.statusCode==200)print('user notified successfully');
  //   }
  //
  //
  // }

  var _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  void initState() {
    global.userEmail = widget.userId;
    super.initState();
    fetchUserData(widget.userId).then((data) {
      setState(() {
        global.userData = data;

      });

      //checkIfNotify();
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
          Icon(
            Icons.calendar_today,
            color: Colors.white,
            size: 20,
          ),
        ],
      ),
    );
  }
}

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:head_gasket/Admin/AdminHome.dart';
import 'package:head_gasket/Classes/Order.dart';
import 'package:head_gasket/Worker/CarReport.dart';
import 'package:head_gasket/Worker/WMyOrder.dart';
import 'package:head_gasket/login.dart';
import 'package:head_gasket/user/MyOrders.dart';
import 'package:head_gasket/user/OrderOptions.dart';
import 'package:head_gasket/user/ReportReview.dart';

import 'Worker/timePlanning.dart';

const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel', //id
    'High Importance Notifications', //title
    importance: Importance.high,
    playSound: true);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('A bg message just showed up : ${message.messageId}');
}
Future<void> main() async {
  FlutterError.onError = (details) {
    FlutterError.presentError(details);
  };


  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    name: 'myApps',
    options: FirebaseOptions(
      apiKey: "XXX",
      appId: "XXX",
      messagingSenderId: "XXX",
      projectId: "XXX",
    ),
  );
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
      AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await  FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  Order order = Order.fromJson({
    '_id': '123456789',
    'serviceName': 'Car Repair',
    'price': 100.0,
    'note': 'Please check the engine.',
    'status': 'Pending',
    'date': '2023-05-14T66',
    'userName': 'John Doe',
    'workerName': 'Mike Smith',
    'street': '123 Main Street',
    'city': 'Cityville',
    'carModel': 'Toyota Camry',
    'delivery': 'Pickup',
    'payment': 'Credit Card',
    'userEmail': 'john.doe@example.com',
    'workerEmail': 'mike.smith@example.com',
    'estimatedTime': '2 days',
    'price1': 50.0,
    'price2': 150.0,
    'problem': 'Engine misfiring',
  });
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GARAGY',
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

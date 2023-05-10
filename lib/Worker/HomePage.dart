import 'package:flutter/material.dart';
import 'package:head_gasket/Classes/service.dart';
import 'package:head_gasket/Widget/background.dart';
import 'package:head_gasket/Worker/workerProfile.dart';
import 'package:head_gasket/global.dart';
import 'package:head_gasket/user/JoinASProvider.dart';
import 'package:head_gasket/user/MyOrders.dart';
import 'package:head_gasket/user/ServicesScreen.dart';
import 'package:head_gasket/Classes/service.dart';
import 'package:head_gasket/login.dart';
import 'package:head_gasket/user/ChangePass.dart';
import 'package:head_gasket/user/Store.dart';
import 'package:head_gasket/user/profilePage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class WorkerHomePage extends StatefulWidget {
  @override
  _WorkerHomePageState createState() => _WorkerHomePageState();
}

class _WorkerHomePageState extends State<WorkerHomePage> {
  late List<dynamic> services;

  Future<List<dynamic>> fetch5RandomServices() async {
    final response = await http.get(Uri.parse(global.ip + '/services'));

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      print(data);
      return data;
    } else {
      throw Exception('Failed to fetch user data');
    }

    //[

    //]

//     return Future.delayed(Duration(seconds: 3), () {
//       return json.decode('''
// {
//   "0": {
//     "name": "Battery",
//     "img": "assets/images/battery.jpg",
//     "type": "Emergency"

//   },
//   "1": {
//     "name": "Key",
//     "img": "assets/images/key.jpg",
//     "type": "care"
//   }
// }
// ''');
//     });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mainColor,
        actions: [
          IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.notifications,
              )),
          IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.chat,
              )),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(global.userData['firstName'] +
                  " " +
                  global.userData['lastName']),
              accountEmail: Text(global.userData['email']),
              currentAccountPicture: CircleAvatar(
                backgroundImage: AssetImage(global.userData['imageUrl']),
              ),
            ),
            ListTile(
              title: Row(
                children: [
                  Icon(Icons.person),
                  Text(" Profile"),
                ],
              ),
              onTap: () {
                Navigator.of(context).push(
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) =>
                    WorkerProfilePage(),                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                      var begin = Offset(0.5, 1.0);
                      var end = Offset.zero;
                      var curve = Curves.ease;

                      var tween = Tween(begin: begin, end: end)
                          .chain(CurveTween(curve: curve));

                      return SlideTransition(
                        position: animation.drive(tween),
                        child: child,
                      );
                    },
                  ),
                );
              },
            ),
            ListTile(
                title: Row(
                  children: [
                    Icon(
                      Icons.local_offer_rounded,
                    ),
                    Text("My Orders"),
                  ],
                ),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (_) => MyOrders(),
                  );
                }),
            ListTile(
                title: Row(
                  children: [
                    Icon(Icons.vpn_key),
                    Text(" Change Password"),
                  ],
                ),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (_) => ChangePasswordPage(),
                  );
                }),
            ListTile(
              title: Row(
                children: [
                  Icon(Icons.contact_support),
                  Text(" Contact us"),
                ],
              ),
              onTap: () {},
            ),
            ListTile(
                title: Row(
                  children: [
                    Icon(Icons.logout),
                    Text(" Logout"),
                  ],
                ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => LoginScreen()));
                }),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(20),
              child: Container(
                alignment: Alignment.bottomLeft,
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundImage:
                          NetworkImage('https://picsum.photos/200'),
                      radius: 30.0,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Column(
                      children: [
                        Text(
                          'Hi, ' +
                              global.userData['firstName'] +
                              " " +
                              global.userData['lastName'],
                          style: TextStyle(
                              fontSize: 30, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.left,
                        ),
                        Text(
                          global.userData['major'],
                          style: TextStyle(
                              color: Colors.grey, fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Services',
                    style: TextStyle(
                      fontSize: 22.0,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Services())),
                    child: Text(
                      'See All',
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 16.0,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: 200.0,
              child: FutureBuilder<List<dynamic>>(
                future: fetch5RandomServices(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    services = snapshot.data!;

                    return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: services.length,
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                          // onTap: () => Navigator.push(
                          //   context,
                          //   // MaterialPageRoute(
                          //   //   builder: (_) => DestinationScreen(
                          //   //     destination: destination,
                          //   //   ),
                          //   // ),
                          // ),
                          child: Container(
                            margin: EdgeInsets.all(15.0),
                            child: Stack(
                              alignment: Alignment.topCenter,
                              children: <Widget>[
                                Positioned(
                                  top: 100.0,
                                  child: Padding(
                                    padding: EdgeInsets.all(5.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Center(
                                          child: Text(
                                            services[index]['serviceName'],
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.w600,
                                              letterSpacing: 1,
                                            ),
                                          ),
                                        ),
                                        Text(
                                          services[index]['serviceType'],
                                          style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.w600,
                                            letterSpacing: 1,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Container(
                                  child: Stack(
                                    children: <Widget>[
                                      Hero(
                                        tag: 'destination.imageUrl',
                                        child: CircleAvatar(
                                          radius: 50,
                                          backgroundImage: AssetImage(services[
                                                  index][
                                              'imgUrl']), //services[index]['serviceImage']
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Best Selling',
                    style: TextStyle(
                      fontSize: 22.0,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => print('See All'),
                    child: Text(
                      'See All',
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 16.0,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 15),
            Container(
              height: size.height * 0.6,
              child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: 20,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Container(
                        width: size.width * 0.9,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(30.0),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black.withOpacity(0.3),
                                  blurRadius: 15,
                                  offset: Offset(5, 5))
                            ]),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Hero(
                                    tag: 'destination.imageUrl',
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(20.0),
                                      child: Image(
                                        height: 100.0,
                                        width: 100.0,
                                        image: AssetImage(
                                            'assets/images/flatTire.jpg'),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Product Name',
                                        style: TextStyle(
                                          fontSize: 20,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 12,
                                      ),
                                      Row(
                                        children: [
                                          Icon(Icons.folder_open_rounded),
                                          SizedBox(
                                            width: 10.0,
                                          ),
                                          Text('BMW'),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 10.0,
                                      ),
                                      Row(
                                        children: [
                                          Icon(Icons.attach_money),
                                          SizedBox(
                                            width: 10.0,
                                          ),
                                          Text(
                                            '150',
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),

                            // Row(
                            //   mainAxisAlignment: MainAxisAlignment.end,
                            //   children: <Widget>[
                            //     TextButton(
                            //       child: const Text('BUY TICKETS'),
                            //       onPressed: () {/* ... */},
                            //     ),
                            //     const SizedBox(width: 8),
                            //   ],
                            // ),
                          ],
                        ),
                      ),
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
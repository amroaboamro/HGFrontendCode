import 'package:flutter/material.dart';
import 'package:head_gasket/Classes/service.dart';
import 'package:head_gasket/Widget/background.dart';
import 'package:head_gasket/ServicesScreen.dart';
import 'package:head_gasket/Classes/service.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomePage extends StatefulWidget {
  Map<Object, dynamic> userData;

  HomePage({required this.userData});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late List<dynamic> services;

  Future<List<dynamic>> fetch5RandomServices() async {
    final response =
        await http.get(Uri.parse('http://127.0.0.1:3000/services'));

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      print(data);
      return data;
    } else {
      throw Exception('Failed to fetch user data');
    }
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
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the drawer if there isn't enough vertical
        // space to fit everything.
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: [
            Container(
              height: size.height * 0.3,
              decoration: BoxDecoration(
                color: Color(0XCC318383),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    backgroundImage: AssetImage('assets/images/profile.png'),
                    radius: size.height * .08,
                  ),
                  Text(
                    widget.userData['email'],
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              title: Row(
                children: [
                  Icon(Icons.person),
                  Text(" Profile"),
                ],
              ),
              onTap: () {},
            ),
            ListTile(
              title: Row(
                children: [
                  Icon(Icons.vpn_key),
                  Text(" Change Password"),
                ],
              ),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
              },
            ),
            ListTile(
              title: Row(
                children: [
                  Icon(Icons.car_repair),
                  Text(" Join as Service Provider"),
                ],
              ),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
              },
            ),
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
              onTap: () {},
            ),
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
                child: Column(
                  children: [
                    Text(
                      'Hi, ' +
                          widget.userData['firstName'] +
                          " " +
                          widget.userData['lastName'],
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.left,
                    ),
                    Text(
                      widget.userData['carModel'],
                      style: TextStyle(
                          color: Colors.grey, fontWeight: FontWeight.bold),
                    )
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
                                        // Text(
                                        //   destination.description,
                                        //   style: TextStyle(
                                        //     color: Colors.grey,
                                        //   ),
                                        // ),
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
                                          backgroundImage: AssetImage(
                                              services[index]['serviceImage']),
                                        ),
                                      ),
                                      // Positioned(
                                      //   left: 10.0,
                                      //   bottom: 10.0,
                                      //   child: Column(
                                      //     crossAxisAlignment: CrossAxisAlignment.start,
                                      //     children: <Widget>[
                                      //       // Text(
                                      //       //   'destination.city',
                                      //       //   style: TextStyle(
                                      //       //     color: Colors.black,
                                      //       //     fontSize: 18.0,
                                      //       //     fontWeight: FontWeight.w600,
                                      //       //     letterSpacing: 1.2,
                                      //       //   ),
                                      //       // ),
                                      //       // Row(
                                      //       //   children: <Widget>[
                                      //       //     Icon(
                                      //       //       Icons.location_on_outlined,
                                      //       //       size: 10.0,
                                      //       //       color: Colors.black,
                                      //       //     ),
                                      //       //     SizedBox(width: 5.0),
                                      //       //     Text(
                                      //       //       'destination.country',
                                      //       //       style: TextStyle(
                                      //       //         color: Colors.black,
                                      //       //       ),
                                      //       //     ),
                                      //       //   ],
                                      //       // ),
                                      //     ],
                                      //   ),
                                      // ),
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

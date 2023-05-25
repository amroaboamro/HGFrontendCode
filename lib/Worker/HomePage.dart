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
import 'package:head_gasket/user/WorkerProfile.dart';
import 'package:head_gasket/user/aboutUs.dart';
import 'package:head_gasket/user/profilePage.dart';
import 'package:head_gasket/Home.dart';
import 'package:http/http.dart' as http;
import 'package:smooth_star_rating_null_safety/smooth_star_rating_null_safety.dart';
import 'dart:convert';

import '../Chat/ChatHomeScreen.dart';
import '../Chat/MethodsChat.dart';
import '../Classes/Worker.dart';

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

  Future<List<Worker>> _fetchWorkersList() async {
    final response = await http.get(Uri.parse(global.ip + '/topWorkers'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List;
      List<Worker> workers =
          data.map((workerJson) => Worker.fromJson(workerJson)).toList();
      return workers;
    } else {
      throw Exception('Failed to load workers');
    }

  }
  Future<dynamic> fetchImageForWorker(Worker worker) async {
    final response = await http.get(Uri.parse(global.ip + '/getImage/' + worker.email));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data;
    } else {
      throw Exception('Failed to fetch image for worker');
    }
  }

  late Future<List<Worker>> _workers;
  List<Worker>? workers;
  Future<Map<String, dynamic>> fetchImage() async {
    final response =
        await http.get(Uri.parse(global.ip + "/getImage/" + global.userEmail));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      return data;
    } else {
      throw Exception('Failed to fetch image');
    }
  }

  @override
  void initState() {
    super.initState();
    _workers = _fetchWorkersList();
    fetchImage().then((value) {
      setState(() {
        global.Imagetest = value['image'];
      });
    });
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
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) =>
                        HomeScreen(global.userData['email'])));
              },
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
                backgroundImage: global.Imagetest != ""
                    ? MemoryImage(base64Decode(global.Imagetest))
                    : AssetImage('assets/images/profile.png') as ImageProvider,
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
                        WorkerProfile(),
                    transitionsBuilder:
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
                  Text(" About us"),
                ],
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AboutUsPage()),
                );
              },
            ),
            ListTile(
                title: Row(
                  children: [
                    Icon(Icons.logout),
                    Text(" Logout"),
                  ],
                ),
                onTap: () {
                  signOut(context).then((value) => {
                    Navigator.pop(context),
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => LoginScreen()))
                  });
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
                      backgroundImage: global.Imagetest != ""
                          ? MemoryImage(base64Decode(global.Imagetest))
                          : AssetImage('assets/images/profile.png')
                              as ImageProvider,
                      radius: 30,
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
                                        tag: 'des',
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
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Top Workers',
                    style: TextStyle(
                      fontSize: 22.0,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 15),
            FutureBuilder<List<Worker>>(
              future: _fetchWorkersList(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                } else if (snapshot.hasData) {
                  List<Worker> workers = snapshot.data!;

                  return Container(
                    height: size.height * 0.4,
                    child: ListView.builder(
                      padding: EdgeInsets.only(top: 10.0, bottom: 15.0),
                      itemCount: workers.length,
                      itemBuilder: (BuildContext context, int index) {
                        Worker worker = workers[index];

                        return GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              PageRouteBuilder(
                                pageBuilder: (context, animation, secondaryAnimation) =>
                                    WorkerProfilePage(worker: worker),
                                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                  var begin = Offset(0.0, 1.0);
                                  var end = Offset.zero;
                                  var curve = Curves.ease;

                                  var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

                                  return SlideTransition(
                                    position: animation.drive(tween),
                                    child: child,
                                  );
                                },
                              ),
                            );
                          },
                          child: Theme(
                            data: ThemeData(
                              cardTheme: CardTheme(
                                color: Colors.blueGrey.shade50,
                                elevation: 4.0, // Set the card elevation
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                ),
                              ),
                            ),
                            child: Card(
                              elevation: 4.0,
                              child: Container(
                                padding: EdgeInsets.all(10.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    FutureBuilder<dynamic>(
                                      future: fetchImageForWorker(worker),
                                      builder: (context, imageSnapshot) {
                                        if (imageSnapshot.connectionState == ConnectionState.waiting) {
                                          return CircularProgressIndicator();
                                        } else if (imageSnapshot.hasError) {
                                          return CircleAvatar(
                                            backgroundImage: AssetImage('assets/images/profile.png'),
                                            radius: 50,
                                          );
                                        } else if (imageSnapshot.hasData) {
                                          dynamic imageData = imageSnapshot.data;
                                          String imageUrl = imageData['image'];

                                          return CircleAvatar(
                                            backgroundImage:
                                            MemoryImage(base64Decode(imageUrl)),

                                            radius: 50,
                                          );
                                        }

                                        return SizedBox();
                                      },
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 10.0),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              worker.name,
                                              style: TextStyle(
                                                fontSize: 18.0,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            SizedBox(height: 5.0),
                                            Text(
                                              worker.major,
                                              style: TextStyle(
                                                fontSize: 16.0,
                                                color: Colors.grey[600],
                                              ),
                                            ),
                                            SizedBox(height: 10.0),
                                            SmoothStarRating(
                                              rating: worker.rating ?? 0.0,
                                              size: 20,
                                              filledIconData: Icons.star,
                                              halfFilledIconData: Icons.star_half,
                                              defaultIconData: Icons.star_border,
                                              starCount: 5,
                                              allowHalfRating: false,
                                              color: Colors.yellow,
                                              borderColor: Colors.grey,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }

                return SizedBox();
              },
            ),
          ],
        ),
      ),
    );
  }
}

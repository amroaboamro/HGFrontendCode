import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:head_gasket/Classes/service.dart';
import 'package:head_gasket/Widget/background.dart';
import 'package:head_gasket/Worker/workerProfile.dart';
import 'package:head_gasket/global.dart';
import 'package:head_gasket/user/MyOrders.dart';
import 'package:head_gasket/user/ServicesScreen.dart';
import 'package:head_gasket/login.dart';
import 'package:head_gasket/user/ChangePass.dart';
import 'package:head_gasket/user/WorkerProfile.dart';
import 'package:head_gasket/user/aboutUs.dart';
import 'package:http/http.dart' as http;
import 'package:smooth_star_rating_null_safety/smooth_star_rating_null_safety.dart';
import 'dart:convert';

import '../Chat/ChatHomeScreen.dart';
import '../Chat/MethodsChat.dart';
import '../Classes/Worker.dart';
import '../Classes/Order.dart';
import '../user/ServiceScreen.dart';

class WorkerHomePage extends StatefulWidget {
  @override
  _WorkerHomePageState createState() => _WorkerHomePageState();
}

class _WorkerHomePageState extends State<WorkerHomePage> {
  Future<void> _updateOrderStatus(String id, String status) async {
    try {
      final response = await http.patch(
        Uri.parse(global.ip + '/updateOrder/$id'),
        body: jsonEncode({'status': status}),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        setState(() {});
        Fluttertoast.showToast(
          msg: 'Order status updated successfully!',
          backgroundColor: Colors.blueGrey,
        );
        Navigator.of(context).pop();
      } else {
        Fluttertoast.showToast(
          msg: 'Failed to update order status. Please try again later.',
          backgroundColor: Colors.red,
        );
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'Failed to update order status. Please try again later.',
        backgroundColor: Colors.red,
      );
    }
  }

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
  }

  Future<List<Order>> _fetchOrders() async {
    final response = await http.get(
        Uri.parse(global.ip + '/workerOrders/' + global.userData['email']));
    if (response.statusCode == 200) {
      final jsonList = jsonDecode(response.body) as List<dynamic>;
      return jsonList.map((json) => Order.fromJson(json)).toList();
    } else {
      throw Exception('Failed to fetch orders');
    }
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
    final response =
    await http.get(Uri.parse(global.ip + '/getImage/' + worker.email));
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
    Size size = MediaQuery
        .of(context)
        .size;
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
                // Navigator.of(context).push(MaterialPageRoute(
                //     builder: (BuildContext context) =>
                //         HomeScreen(global.userData['email'])));
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
              accountEmail: Text(global.userEmail),
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
                  // //signOut(context).then((value) =>
                  // {
                  //   Navigator.pop(context),
                  //   Navigator.push(
                  //       context,
                  //       MaterialPageRoute(
                  //           builder: (context) => LoginScreen())),
                  //   global.Imagetest = ""
                  // });

                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => LoginScreen()));
                    global.Imagetest = "";
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
                          'Hi,' +
                              global.userData['firstName']! +
                              " " +
                              global.userData['lastName']!,
                          style: TextStyle(
                              fontSize: 30, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.left,
                        ),
                        Text(
                          global.userData['major'] != null
                              ? global.userData['major']
                              : '---',
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
                    onTap: () =>
                        Navigator.push(context,
                            MaterialPageRoute(
                                builder: (context) => Services())),
                    child: Text(
                      'See All',
                      style: TextStyle(
                        color: Theme
                            .of(context)
                            .primaryColor,
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
                          onTap: () =>
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      ServiceScreen(
                                          service: Service(
                                              services[index]['imgUrl'],
                                              services[index]['serviceName'],
                                              services[index]['serviceType']),

                                      ),
                                ),
                              ),
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
                    'Processing Tests',
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
            FutureBuilder<List<Order>>(
              future: _fetchOrders(),
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
                  List<Order> orders = snapshot.data!;
                  List<Order> processingOrders = orders
                      .where((order) => order.status == "Processing")
                      .toList();

                  return Container(
                    height: size.height * 0.4,
                    child: ListView.builder(
                      padding: EdgeInsets.only(top: 10.0, bottom: 15.0),
                      itemCount: processingOrders.length,
                      itemBuilder: (BuildContext context, int index) {
                        Order order = processingOrders[index];

                        return Card(
                          elevation: 4.0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                            side: BorderSide(
                              color: Colors.blueGrey,
                              width: 1.0,
                            ),
                          ),
                          child: Container(
                            padding: EdgeInsets.all(10.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15.0),
                              gradient: LinearGradient(
                                colors: [
                                  mainColor.withOpacity(0.7),
                                  Colors.green.shade100
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                            ),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundImage:
                                AssetImage('assets/images/order.png'),
                                radius: 30,
                              ),
                              title: Text(
                                order.userName,
                                style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    order.serviceName,
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(height: 5.0),
                                  Text(
                                    order.carModel,
                                    style: TextStyle(
                                      fontSize: 14.0,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                              trailing: GestureDetector(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text('Mark as Completed'),
                                        content: Text(
                                            'Are you sure the order is completed?'),
                                        actions: <Widget>[
                                          TextButton(
                                            child: Text('Cancel'),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                          TextButton(
                                            child: Text('Confirm'),
                                            onPressed: () async {
                                              // Send status to API and show toast
                                              await _updateOrderStatus(
                                                  order.id, 'Completed');
                                              setState(() {});
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 6.0, horizontal: 12.0),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.check,
                                        color: mainColor,
                                        size: 20.0,
                                      ),
                                      SizedBox(width: 5.0),
                                      Text(
                                        'Done',
                                        style: TextStyle(
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.w500,
                                          color: mainColor,
                                        ),
                                      ),
                                    ],
                                  ),
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
            )
          ],
        ),
      ),
    );
  }
}

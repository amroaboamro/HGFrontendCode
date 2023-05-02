import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:head_gasket/global.dart';
import 'package:head_gasket/user/map.dart';
import 'package:smooth_star_rating_null_safety/smooth_star_rating_null_safety.dart';
import '../Classes/service.dart';
import '../Classes/Worker.dart';
import 'package:http/http.dart' as http;

import 'WorkerProfile.dart';

class ServiceScreen extends StatefulWidget {
  final Service service;

  ServiceScreen({required this.service});

  @override
  _ServiceScreenState createState() => _ServiceScreenState();
}

class _ServiceScreenState extends State<ServiceScreen> {
  late Future<List<Worker>> _workers;
  List<Worker>? workers;
  String _searchQuery = '';
  bool _showSearchBar = false;
  var userLat = global.userData['latitude']; // User's latitude
  var userLng = global.userData['longitude']; // User's longitude

  Future<List<Worker>> _fetchWorkersList() async {
    // final response = await http.get(Uri.parse('https://example.com/api/workers'));
    // if (response.statusCode == 200) {
    //   final data = jsonDecode(response.body) as List;
    //   List<Worker> workers = data.map((workerJson) => Worker.fromJson(workerJson)).toList();
    //   workers.sort((a, b) => a.distanceTo(userLat, userLng).compareTo(b.distanceTo(userLat, userLng)));
    //   return workers;
    // } else {
    //   throw Exception('Failed to load workers');
    // }
    return Future.delayed(Duration(seconds: 1), () {
      final data = jsonDecode('''[
  {
    "firstName": "John",
    "lastName": "Doe",
    "major": "Plumber",
    "rating": 4.5,
    "imageUrl": "assets/images/key.jpg",
    "phone": "555-1234",
    "email": "johndoe@example.com",
    "city": "Miami",
    "street": "123 Main St",
    "latitude": 25.7743,
    "longitude": -80.1937,
    "bio": "I'm a plumber with over 10 years of experience. Call me for all your plumbing needs!"
  },
  {
    "firstName": "Jane",
    "lastName": "Smith",
    "major": "Electrician",
    "rating": 4.8,
    "imageUrl": "assets/images/key.jpg",
    "phone": "555-5678",
    "email": "janesmith@example.com",
    "city": "Miami",
    "street": "456 Oak Ave",
    "latitude": 25.7821,
    "longitude": -80.2395,
    "bio": "Need an electrician? Look no further! I'm here to help with all your electrical needs."
  },
  {
    "firstName": "Mark",
    "lastName": "Johnson",
    "major": "Carpenter",
    "rating": 4.2,
    "imageUrl": "assets/images/key.jpgg",
    "phone": "555-9012",
    "email": "markjohnson@example.com",
    "city": "Miami",
    "street": "789 Elm St",
    "latitude": 25.7617,
    "longitude": -80.1918,
    "bio": "I'm a skilled carpenter with a passion for building things. Let me help bring your vision to life!"
  },
  {
    "firstName": "Sarah",
    "lastName": "Lee",
    "major": "Handyman",
    "rating": 4.1,
    "imageUrl": "assets/images/key.jpg",
    "phone": "555-3456",
    "email": "sarahlee@example.com",
    "city": "Miami",
    "street": "321 Pine St",
    "latitude": 25.7751,
    "longitude": -80.1937,
    "bio": "Need help with odd jobs around the house? I'm your gal! From painting to plumbing, I can do it all."
  },
  {
    "firstName": "David",
    "lastName": "Brown",
    "major": "Gardener",
    "rating": 4.6,
    "imageUrl": "assets/images/key.jpg",
    "phone": "555-6789",
    "email": "davidbrown@example.com",
    "city": "Miami",
    "street": "543 Maple Ave",
    "latitude": 25.7528,
    "longitude": -80.2229,
    "bio": "Love your lawn and garden again! I'll make sure your yard looks beautiful year-round."
  }
]


''') as List;
      List<Worker> workers =
          data.map((workerJson) => Worker.fromJson(workerJson)).toList();
      workers.sort((a, b) => a
          .distanceTo(userLat, userLng)
          .compareTo(b.distanceTo(userLat, userLng)));
      return workers;
    });
  }

  @override
  void initState() {
    super.initState();
    _workers = _fetchWorkersList();
  }

  @override
  Widget build(BuildContext context) {
    if (global.userData['latitude'] == null) {
      return MapScreen();
    }

    Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: Column(
        children: <Widget>[
          Stack(
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).size.height * 0.4,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      offset: Offset(0.0, 2.0),
                      blurRadius: 6.0,
                    ),
                  ],
                ),
                child: Hero(
                  tag: widget.service.imgUrl,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(30.0),
                    child: Image(
                      width: screenSize.width,
                      image: AssetImage(widget.service.imgUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 40.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    IconButton(
                      icon: Icon(Icons.arrow_back),
                      iconSize: 30.0,
                      color: Colors.white,
                      onPressed: () => Navigator.pop(context),
                    ),
                    Row(
                      children: <Widget>[
                        IconButton(
                          icon: Icon(Icons.search),
                          iconSize: 30.0,
                          color: Colors.white,
                          onPressed: () {
                            setState(() {
                              _showSearchBar = !_showSearchBar;
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Positioned(
                left: 20.0,
                bottom: 20.0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      widget.service.serviceName,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 35.0,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.2,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MapScreen(
                                      users: workers,
                                    )));
                      },
                      child: Row(
                        children: <Widget>[
                          Icon(
                            Icons.location_on,
                            size: 20.0,
                            color: Colors.white70,
                          ),
                          SizedBox(width: 5.0),
                          Text(
                            global.userData['city'],
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 20.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          if (_showSearchBar)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                onChanged: (query) {
                  setState(() {
                    _searchQuery = query;
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Search for workers',
                  filled: true,
                  fillColor: Colors.white,
                  prefixIcon: Icon(Icons.search, color: Colors.grey),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 15.0, vertical: 13.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(
                      width: 1,
                      color: Colors.blueGrey,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(
                      width: 1,
                      color: Colors.blueGrey,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(
                      width: 0.5,
                      color: Colors.blue,
                    ),
                  ),
                ),
              ),
            ),
          FutureBuilder<List<Worker>>(
            future: _workers,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('Error: ${snapshot.error}'),
                );
              } else {
                workers = snapshot.data!;
                List<Worker> _filteredWorkers = [];
                if (_searchQuery.isNotEmpty) {
                  _filteredWorkers = workers!
                      .where((worker) => worker.name
                          .toLowerCase()
                          .contains(_searchQuery.toLowerCase()))
                      .toList();
                } else {
                  _filteredWorkers = workers!;
                }
                return Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.only(top: 10.0, bottom: 15.0),
                    itemCount: _filteredWorkers.length,
                    itemBuilder: (BuildContext context, int index) {
                      Worker worker = _filteredWorkers[index];
                      return Stack(
                        children: <Widget>[
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                PageRouteBuilder(
                                  pageBuilder: (context, animation,
                                          secondaryAnimation) =>
                                      WorkerProfilePage(worker: worker),
                                  transitionsBuilder: (context, animation,
                                      secondaryAnimation, child) {
                                    var begin = Offset(0.0, 1.0);
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
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                              elevation: 4.0,
                              child: Container(
                                padding: EdgeInsets.all(15.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    CircleAvatar(
                                      backgroundImage:
                                          AssetImage(worker.imageUrl),
                                      radius: 50.0,
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10.0),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
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
                                              halfFilledIconData:
                                                  Icons.star_half,
                                              defaultIconData:
                                                  Icons.star_border,
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
                        ],
                      );
                    },
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}

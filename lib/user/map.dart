import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:head_gasket/global.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'WorkerProfile.dart';

class MapScreen extends StatefulWidget {
final  List<dynamic>? users ;
  MapScreen({this.users});
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LatLng? _currentLocation;

  MapController _mapController = MapController();

  String city='';
  String street='';

  // Get the user's current location
  void _getUserLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      setState(() {
        _currentLocation = LatLng(position.latitude, position.longitude);

      });

      // Get the city and street from the user's location
      await setCityAndStreet(_currentLocation!);

    } catch (e) {
      print(e);
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Location Permission Error'),
            content: Text(
                'Please grant the app permission to access your location.'),
            actions: <Widget>[
              ElevatedButton(
                child: Text('OK'),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          );
        },
      );
    }
  }

  Future<void> setCityAndStreet(LatLng location) async {
    List<Placemark> placeMarks = await placemarkFromCoordinates(location.latitude, location.longitude);
    setState(() {
      city = placeMarks[0].locality!;
      street = placeMarks[0].street!;
    });


      _mapController.move(_currentLocation!, 13.0);
  }

  // Send the user's location, city and street to the API
  void _sendUserLocation() async {
    print(city);
    print(street);
    print(_currentLocation);
    print(global.userEmail);
    final response = await http.patch(
      Uri.parse(global.ip+'updateLocation'+global.userEmail),
      body: json.encode({
        'latitude': _currentLocation!.latitude,
        'longitude': _currentLocation!.longitude,
        'city': city,
        'street': street,
      }),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      Fluttertoast.showToast(
        msg: 'User location sent successfully',
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.green,
      );
    } else {
      Fluttertoast.showToast(
        msg: 'Failed to send user location',
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
      );
    }
  }

  // Fetch users from the API based on the user's location


  @override
  void initState() {
    Fluttertoast.showToast(
      msg: 'Please choose your location',
      gravity: ToastGravity.CENTER,
      backgroundColor: Colors.yellowAccent,
      textColor: Colors.black,
    );
    super.initState();
    _getUserLocation();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Current Location'),

              Text(
                '$city, $street',
                style: TextStyle(fontSize: 14),
              ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.done),
            onPressed: (){
              global.userData['city']=city;
              global.userData['street']=street;
              global.userData['longitude']=_currentLocation?.longitude;
              global.userData['latitude']=_currentLocation?.latitude;
              _sendUserLocation();
            },
          ),
        ],
      ),

      body: FlutterMap(

        mapController: _mapController ,
        options: MapOptions(
          center: _currentLocation ?? LatLng(0, 0),
          zoom: 13.0,
            onTap: (LatLng latLng){
            print(latLng);
            setState(() {

              _currentLocation = latLng;
              setCityAndStreet(_currentLocation!);
            });


            }
           // add this line
        ),




        layers: [
          TileLayerOptions(
            urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
            subdomains: ['a', 'b', 'c'],
          ),
          if(widget.users != null)
          MarkerLayerOptions(
            markers: widget.users!
                .map((user) => Marker(
                      point: LatLng(user.latitude, user.longitude),
                      builder: (ctx) => GestureDetector(
                        onTap: (){
                          Navigator.of(context).push(
                            PageRouteBuilder(
                              pageBuilder: (context, animation, secondaryAnimation) => WorkerProfilePage(worker: user),
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
                          child: Icon(Icons.person,size: 30,color: Colors.deepOrange,) ),
                    ))
                .toList(),
          ),
          MarkerLayerOptions(
            markers: _currentLocation != null
                ? [
                    Marker(
                      point: _currentLocation!,
                      builder: (ctx) => Icon(Icons.location_on),
                    )
                  ]
                : [],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {

          _getUserLocation();
        },
        child: Icon(Icons.location_searching),
      ),
    );
  }
}

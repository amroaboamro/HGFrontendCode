import 'package:flutter/material.dart';
import 'package:head_gasket/Widget/background.dart';
import 'package:head_gasket/Worker/EditWorkerProfile.dart';
import 'package:head_gasket/global.dart';
import 'package:smooth_star_rating_null_safety/smooth_star_rating_null_safety.dart';

import '../user/map.dart';

class WorkerProfile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Profile'),
        backgroundColor: mainColor,
      ),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height *1.5,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              SizedBox(height: 24.0),

              Stack(
                alignment: Alignment.topRight,
                children: [
                  Center(
                    child: CircleAvatar(
                      radius: 60.0,
                      backgroundImage: AssetImage(
                          'assets/images/profile.png'),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.edit,
                            color: mainColor,
                          ),
                          onPressed: () => Navigator.push(context,
                              MaterialPageRoute(builder: (context) => EditWorkerProfile(userData: global.userData,))),
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.location_on,
                            color: mainColor,
                          ),
                          onPressed: () => Navigator.push(context,
                              MaterialPageRoute(builder: (context) => MapScreen())), ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.0),
              Center(
                child: Text(
                 global.userData['firstName']+' '+global.userData['lastName'] ,
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 8.0),
              Center(
                child: Text(
                  global.userData['email'],
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.grey,
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  'About Me',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 8.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  global.userData['bio'],
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.grey,
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              Container(

                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24.0)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      blurRadius: 8.0,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 16.0),
                      Text(
                        'Major',
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8.0),
                      Row(
                        children: [
                          Chip(
                            label: Text(global.userData['major']),
                            backgroundColor: mainColor,
                            labelStyle: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: 8.0),
                          Chip(
                            label: Text(global.userData['carBrand']),
                            backgroundColor:mainColor,
                            labelStyle: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16.0),
                      Text(
                        'Rating',
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SmoothStarRating(
                        rating:double.parse(global.userData['rating'].toString()) ?? 0.0,
                        size: 24,
                        filledIconData: Icons.star,
                        halfFilledIconData: Icons.star_half,
                        defaultIconData: Icons.star_border,
                        starCount: 5,
                        allowHalfRating: false,
                        color: Colors.yellow,
                        borderColor: Colors.grey,
                      ),
                      SizedBox(height: 16.0),
                      Text(
                        'Location',
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8.0),
                      ListTile(
                        title: Text(
                          global.userData['city'],
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle:Text(global.userData['street']),

                      ),

                      SizedBox(height: 16.0),
                      Text(
                        'Contact',
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8.0),
                      SizedBox(height: 8.0),
                      Row(
                        children: [
                          Icon(Icons.email),
                          SizedBox(width: 8),
                          Text(
                            global.userData['email'],
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8.0),
                      Row(
                        children: [
                          Icon(Icons.phone),
                          SizedBox(width: 8),
                          Text(
                            global.userData['phone'],
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

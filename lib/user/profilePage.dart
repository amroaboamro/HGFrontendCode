import 'package:flutter/material.dart';
import 'package:head_gasket/user/EditProfile.dart';

import '../Widget/background.dart';

class ProfilePage extends StatefulWidget {
  final Map<String, dynamic> userData;
  ProfilePage({required this.userData});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text('My Profile'),
        backgroundColor: mainColor,
        elevation: 0,
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          EditProfilePage(userData: widget.userData)));
            },
            child: Container(
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 13, right: 20, top: 10, bottom: 10),
                child: Row(
                  children: [
                    Icon(
                      Icons.edit,
                      color: Colors.white,
                      size: 18,
                    ),
                    SizedBox(
                      width: 3,
                    ),
                    Text(
                      'Edit',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: <Widget>[
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundImage:
                            NetworkImage('https://picsum.photos/200'),
                        radius: 40.0,
                      ),
                      SizedBox(width: 16.0),
                      Column(
                        children: [
                          Text(
                            widget.userData['firstName'] +
                                ' ' +
                                widget.userData['lastName'],
                            style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 5.0),
                          Text(
                            'Product Designer',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 15.0,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Row(
                    children: [
                      Text(
                        'Email: ' + widget.userData['email'],
                        style: TextStyle(
                          color: Colors.grey[500],
                          fontSize: 16.0,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.0),
                  Row(
                    children: [
                      Text(
                        'Location: ' + widget.userData['location'],
                        style: TextStyle(
                          color: Colors.grey[500],
                          fontSize: 16.0,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.0),
                  Row(
                    children: [
                      Text(
                        'Car Model: ' + widget.userData['carModel'],
                        style: TextStyle(
                          color: Colors.grey[500],
                          fontSize: 16.0,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.0),
                  Row(
                    children: [
                      Text(
                        'Phone: ' + widget.userData['phone'],
                        style: TextStyle(
                          color: Colors.grey[500],
                          fontSize: 16.0,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 16.0),
          Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'My Skills',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Row(
                    children: <Widget>[
                      Chip(
                        label: Text('UI Design'),
                      ),
                      SizedBox(width: 8.0),
                      Chip(
                        label: Text('UX Design'),
                      ),
                      SizedBox(width: 8.0),
                      Chip(
                        label: Text('Mobile App Design'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

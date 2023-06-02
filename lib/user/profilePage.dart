import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:head_gasket/user/EditProfile.dart';
import 'package:head_gasket/global.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';


import '../Widget/background.dart';
class ServiceHistoryItem {
  final String date;
  final String description;

  ServiceHistoryItem({required this.date, required this.description});
}

class ProfilePage extends StatefulWidget {
  final Map<String, dynamic> userData;
  ProfilePage({required this.userData});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  List<ServiceHistoryItem> serviceHistory = [];

  @override
  void initState() {
    super.initState();
    fetchServiceHistory();
  }

  Future<void> fetchServiceHistory() async {
    final url = Uri.parse(global.ip + '/userHistoryOrders/'+global.userEmail);
    final response = await http.get(url);
    final data = jsonDecode(response.body);
    print(data.toString());
    final List<dynamic> serviceData = data;
    setState(() {
      serviceHistory = serviceData
          .map((item) =>
          ServiceHistoryItem(
            date: item['date'],
            description: item['serviceName'],
          ))
          .toList();
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text('Car Profile'),
        backgroundColor: mainColor,
        elevation: 0,
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditProfilePage(userData: widget.userData),
                ),
              );
            },
            child: Container(
              child: Padding(
                padding: const EdgeInsets.only(left: 13, right: 20, top: 10, bottom: 10),
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
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.grey, Colors.blueGrey],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 16),
                    CircleAvatar(
                      backgroundImage: global.Imagetest != ""
                          ? MemoryImage(base64Decode(global.Imagetest))
                          : AssetImage('assets/images/profile.png') as ImageProvider,
                      radius: 60,
                    ),
                    SizedBox(height: 16),
                    Text(
                      widget.userData['carModel'],
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      'Name: ${widget.userData['firstName']+' '+widget.userData['lastName']}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                      ),
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      'Phone: ${widget.userData['phone']}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                      ),
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      'Location: ${widget.userData['city']+','+widget.userData['street']}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                      ),
                    ),
                    SizedBox(height: 32),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                'Service History',
                                style: TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 16.0),
                              Expanded(
                                child: ListView.builder(
                                  itemCount: serviceHistory.length,
                                  itemBuilder: (context, index) {
                                    final item = serviceHistory[index];
                                    return ListTile(
                                      leading: CircleAvatar(
                                        backgroundColor: Colors.grey[200],
                                        child: Icon(
                                          Icons.car_repair,
                                          color: Colors.black,
                                        ),
                                      ),
                                      title: Text(
                                        DateFormat('EEEE, MMMM d, yyyy - hh:mm a')
                                            .format(
                                            DateTime.parse( item.date))
                                       ,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      subtitle: Text(item.description),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 16.0),
        ],
      ),
    );
  }

}

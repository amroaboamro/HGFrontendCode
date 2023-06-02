import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:head_gasket/global.dart';
import 'package:http/http.dart' as http;

import '../Widget/background.dart';

class RequestAdminPage extends StatefulWidget {
  @override
  _RequestAdminPageState createState() => _RequestAdminPageState();
}

class _RequestAdminPageState extends State<RequestAdminPage> {
  List<RequestData> requestDataList = [];
  bool _isDisposed = false;

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final response = await http.get(Uri.parse(global.ip + '/getJoinRequests'));
      if (response.statusCode == 200 && !_isDisposed) {
        final List<dynamic> responseData = json.decode(response.body);
        setState(() {
          requestDataList =
              responseData.map((data) => RequestData.fromJson(data)).toList();
        });
      } else {
        if (!_isDisposed) {
          print('Failed to fetch data: ${response.statusCode}');
        }
      }
    } catch (error) {
      if (!_isDisposed) {
        print('Failed to fetch data: $error');
      }
    }
  }

  void updateRequestStatus(String requestId, String status,RequestData data) async {
    try {
      final response = await http.post(
        Uri.parse(global.ip + '/addWorker/'+data.email+'/'+requestId),
        body: json.encode(
            {
              'role': status,
              'major':data.serviceName,
              'carBrand':data.carBrand,
              'bio':data.bio,
            }
            ),
        headers: {'Content-Type': 'application/json'},
      );
      print(response.body);

      if (response.statusCode == 200) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Success'),
              content: Text('The request status has been updated.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    setState(() {
                      fetchData();
                    });
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Error'),
              content: Text('Failed to update the request status.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      }
    } catch (error) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text(
                'An error occurred while updating the request status: $error'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Requests'),
        backgroundColor: mainColor,
      ),
      body: ListView.builder(
        itemCount: requestDataList.length,
        itemBuilder: (BuildContext context, int index) {
          final requestData = requestDataList[index];
          return RequestCard(
            id: requestData.id,
            workerName: requestData.workerName,
            requestImage: requestData.avatarUrl ?? '',
            serviceName: requestData.serviceName,
            carBrand: requestData.carBrand,
            phone: requestData.phone,
            email: requestData.email,
            bio: requestData.bio,
            onAccept: () {
              updateRequestStatus(requestData.id, 'worker',requestData);
            },
            onCancel: () {
              updateRequestStatus(requestData.id, 'Basic',requestData);
            },
          );
        },
      ),
    );
  }
}

class RequestCard extends StatelessWidget {
  final String workerName;
  final String requestImage;
  final String serviceName;
  final String carBrand;
  final String phone;
  final String email;
  final String bio;
  final VoidCallback onAccept;
  final VoidCallback onCancel;

  final String id;

  const RequestCard({
    required this.workerName,
    required this.requestImage,
    required this.serviceName,
    required this.carBrand,
    required this.phone,
    required this.email,
    required this.bio,
    required this.onAccept,
    required this.onCancel,required this.id
  });

  Future<String> fetchImageForRequest(String id) async {
    try {
      final response =
          await http.get(Uri.parse(global.ip + '/getCertificate/' + id));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['image'];
      } else {
        throw Exception('Failed to fetch image for worker');
      }
    } catch (error) {
      throw Exception('Failed to fetch image for worker: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(16.0),
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FutureBuilder(
              future: fetchImageForRequest(id),
              builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircleAvatar(
                    radius: 32.0,
                    backgroundColor: Colors.grey[300],
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return CircleAvatar(
                    radius: 32.0,
                    backgroundColor: Colors.grey[300],
                    child: Icon(
                      Icons.error_outline,
                      size: 48.0,
                      color: Colors.red,
                    ),
                  );
                } else {
                  return GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (BuildContext context) {
                            return Scaffold(
                              body: Center(
                                child: Hero(
                                  tag: 'imageTag',
                                  child: Image.memory(
                                    base64Decode(snapshot.data!),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                    child: Hero(
                      tag: phone,
                      child: CircleAvatar(
                        radius: 32.0,
                        backgroundImage:
                            MemoryImage(base64Decode(snapshot.data!)),
                      ),
                    ),
                  );
                }
              },
            ),
            SizedBox(width: 16.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    workerName,
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    'Service: $serviceName',
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.grey[800],
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    'Car Brand: $carBrand',
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.grey[800],
                    ),
                  ),

                  SizedBox(height: 8.0),
                  Text(
                    'Phone: $phone',
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.grey[800],
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    'Email: $email',
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.grey[800],
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    'Bio: $bio',
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.grey[800],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 16.0),
            Column(
              children: [
                ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Accept Request'),
                          content: Text(
                              'Are you sure you want to accept this service provider?'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                                onAccept();
                              },
                              child: Text('Accept'),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text('Cancel'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    primary: mainColor,
                    onPrimary: Colors.black,
                    textStyle: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                    padding: EdgeInsets.symmetric(
                      vertical: 12.0,
                      horizontal: 16.0,
                    ),
                  ),
                  child: Text('Accept'),
                ),
                SizedBox(height: 8.0),
                ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Cancel Request'),
                          content: Text(
                              'Are you sure you want to cancel this request?'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                                onCancel();
                              },
                              child: Text('Cancel Request'),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text('Keep Request'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.red,
                    onPrimary: Colors.white,
                    textStyle: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                    padding: EdgeInsets.symmetric(
                      vertical: 12.0,
                      horizontal: 16.0,
                    ),
                  ),
                  child: Text('Cancel'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class RequestData {
  final String workerName;
  final String serviceName;
  final String carBrand;
  final String phone;
  final String email;
  final String bio;

  String? avatarUrl;
  final String id;

  RequestData({
    required this.id,
    required this.workerName,
    this.avatarUrl,
    required this.serviceName,
    required this.carBrand,
    required this.phone,
    required this.email,
    required this.bio,
  });

  factory RequestData.fromJson(Map<String, dynamic> json) {
    return RequestData(
      id: json['_id'],
      workerName: json['firstName'] + ' ' + json['lastName'],
      serviceName: json['serviceName'],
      carBrand: json['carBrand'],
      phone: json['phone'],
      email: json['workerEmail'],
      bio: json['bio'],
    );
  }
}

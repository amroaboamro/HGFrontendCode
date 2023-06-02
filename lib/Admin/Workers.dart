import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:smooth_star_rating_null_safety/smooth_star_rating_null_safety.dart';

import '../Widget/background.dart';
import 'package:head_gasket/global.dart';

class Worker {
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String carModel;
  final String city;
  final String street;
  final String serviceName;
  final String carBrand;
  final double rating;

  Worker({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.carModel,
    required this.city,
    required this.street,
    required this.serviceName,
    required this.carBrand,
    required this.rating,
  });
}

class WorkersPage extends StatefulWidget {
  @override
  _WorkersPageState createState() => _WorkersPageState();
}

class _WorkersPageState extends State<WorkersPage> {
  List<Worker> _workers = [];
  List<Worker> _filteredWorkers = []; // List to store filtered workers
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void _filterWorkers(String query) {
    if (query.isEmpty) {
      setState(() {
        _filteredWorkers = _workers;
      });
    } else {
      setState(() {
        _filteredWorkers = _workers
            .where((worker) =>
                worker.firstName.toLowerCase().contains(query.toLowerCase()) ||
                worker.lastName.toLowerCase().contains(query.toLowerCase()))
            .toList();
      });
    }
  }

  Future<void> fetchData() async {
    final response = await http.get(Uri.parse(global.ip + '/allWorkers'));

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body) as List<dynamic>;

      final List<Worker> workers = jsonData.map((workerJson) {
        return Worker(
          firstName: workerJson['firstName'],
          lastName: workerJson['lastName'],
          email: workerJson['email'],
          phone: workerJson['phone'],
          carModel: workerJson['carModel'],
          city: workerJson['city'],
          street: workerJson['street'],
          serviceName: workerJson['major'],
          carBrand: workerJson['carBrand'],
          rating: workerJson['rating'].toDouble(),
        );
      }).toList();

      setState(() {
        _workers = workers;
        _filteredWorkers = workers;
      });
    } else {
      print('Failed to fetch workers. Status code: ${response.statusCode}');
    }


  }

  Future<void> deleteWorker(String email) async {
    try {
      final response =
          await http.delete(Uri.parse(global.ip + '/removeUser/$email'));
      if (response.statusCode == 200) {
        setState(() {
          _workers.removeWhere((worker) => worker.email == email);
          _filteredWorkers.removeWhere((worker) => worker.email == email);
        });
      } else {
        print('Error deleting worker: ${response.statusCode}');
      }
    } catch (error) {
      print('Error deleting worker: $error');
    }
  }

  void _showDeleteConfirmationDialog(Worker worker) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Worker'),
          content: Text(
              'Are you sure you want to delete ${worker.firstName} ${worker.lastName}?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                deleteWorker(worker.email);
                Navigator.of(context).pop();
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                _filterWorkers(value);
              },
              decoration: InputDecoration(
                labelText: 'Search',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columnSpacing: 20.0,
                dataRowHeight: 60.0,
                columns: [
                  DataColumn(
                    label: Row(
                      children: [
                        Icon(Icons.person),
                        SizedBox(width: 5.0),
                        Text('Name'),
                      ],
                    ),
                  ),
                  DataColumn(
                    label: Row(
                      children: [
                        Icon(Icons.star),
                        SizedBox(width: 5.0),
                        Text('Rating'),
                      ],
                    ),
                  ),
                  DataColumn(
                    label: Row(
                      children: [
                        Icon(Icons.email),
                        SizedBox(width: 5.0),
                        Text('Email'),
                      ],
                    ),
                  ),
                  DataColumn(
                    label: Row(
                      children: [
                        Icon(Icons.phone),
                        SizedBox(width: 5.0),
                        Text('Phone'),
                      ],
                    ),
                  ),
                  DataColumn(
                    label: Row(
                      children: [
                        Icon(Icons.directions_car),
                        SizedBox(width: 5.0),
                        Text('Car Model'),
                      ],
                    ),
                  ),
                  DataColumn(
                    label: Row(
                      children: [
                        Icon(Icons.location_city),
                        SizedBox(width: 5.0),
                        Text('Location'),
                      ],
                    ),
                  ),
                  DataColumn(
                    label: Row(
                      children: [
                        Icon(Icons.work),
                        SizedBox(width: 5.0),
                        Text('Service'),
                      ],
                    ),
                  ),
                  DataColumn(
                    label: Row(
                      children: [
                        Icon(Icons.delete),
                        SizedBox(width: 5.0),
                        Text('Action'),
                      ],
                    ),
                  ),
                ],
                rows: _filteredWorkers.map((worker) {
                  return DataRow(
                    color: MaterialStateColor.resolveWith((states) {
                      return worker.rating >= 4.0
                          ? mainColor.withOpacity(0.5)!
                          : Colors.transparent;
                    }),
                    cells: [
                      DataCell(
                        Row(
                          children: [
                            CircleAvatar(
                              child: Text(
                                '${worker.firstName[0]}${worker.lastName[0]}',
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                            SizedBox(width: 10.0),
                            Text('${worker.firstName} ${worker.lastName}'),
                          ],
                        ),
                      ),
                      DataCell(
                        SmoothStarRating(
                          rating: worker.rating,
                          size: 20,
                          filledIconData: Icons.star,
                          halfFilledIconData: Icons.star_half,
                          defaultIconData: Icons.star_border,
                          starCount: 5,
                          allowHalfRating: true,
                          spacing: 2.0,
                          color: Colors.amber,
                        ),
                      ),
                      DataCell(Text(worker.email)),
                      DataCell(Text(worker.phone)),
                      DataCell(Text(worker.carModel)),
                      DataCell(
                        Text('${worker.city}, ${worker.street}'),
                      ),
                      DataCell(Text(worker.serviceName)),
                      DataCell(
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            _showDeleteConfirmationDialog(worker);
                          },
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

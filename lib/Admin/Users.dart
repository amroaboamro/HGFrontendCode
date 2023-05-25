import 'package:flutter/material.dart';
import 'package:head_gasket/Widget/background.dart';
import 'package:head_gasket/global.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class User {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String carModel;
  final String city;
  final String street;

  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.carModel,
    required this.city,
    required this.street,
  });
}

class UsersPage extends StatefulWidget {
  @override
  _UsersPageState createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  List<User> _users = [];
  List<User> _filteredUsers = []; // List to store filtered users
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void _filterUsers(String query) {
    if (query.isEmpty) {
      setState(() {
        _filteredUsers = _users;
      });
    } else {
      setState(() {
        _filteredUsers = _users
            .where((user) =>
                user.firstName.toLowerCase().contains(query.toLowerCase()) ||
                user.lastName.toLowerCase().contains(query.toLowerCase()))
            .toList();
      });
      print(_filteredUsers.toString());
    }
  }

  Future<void> fetchData() async {
    try {
      final response = await http.get(Uri.parse(global.ip + '/allUsers'));
      final jsonData = jsonDecode(response.body);
      List<User> users = [];
      for (var user in jsonData) {
        users.add(User(
          id: user['_id'],
          firstName: user['firstName'],
          lastName: user['lastName'],
          email: user['email'],
          phone: user['phone'],
          carModel: user['carModel'],
          city: user['city'],
          street: user['street'],
        ));
      }
      setState(() {
        _users = users;
        _filteredUsers = users;
      });
    } catch (error) {
      print('Error fetching data: $error');
    }
//     Future.delayed(Duration(seconds: 1),(){
//         List<User> users = [];
//         final jsonData = jsonDecode('''

//    [
//     {
//       "id": "1",
//       "firstName": "John",
//       "lastName": "Doe",
//       "email": "johndoe@example.com",
//       "phone": "1234567890",
//       "carModel": "Toyota Camry",
//       "city": "New York",
//       "street": "123 Main St"
//     },
//     {
//       "id": "2",
//       "firstName": "Jane",
//       "lastName": "Smith",
//       "email": "janesmith@example.com",
//       "phone": "0987654321",
//       "carModel": "Honda Accord",
//       "city": "Los Angeles",
//       "street": "456 Elm St"
//     }
//   ]

// ''');

//         for (var user in jsonData) {
//           users.add(User(
//             id: user['id'],
//             firstName: user['firstName'],
//             lastName: user['lastName'],
//             email: user['email'],
//             phone: user['phone'],
//             carModel: user['carModel'],
//             city: user['city'],
//             street: user['street'],
//           ));
//         }
//         setState(() {
//           _users = users;
//           _filteredUsers = users;
//         });
//     });
  }

  Future<void> deleteUser(String userId) async {
    try {
      final response =
          await http.delete(Uri.parse(global.ip + '/removeUser/$userId'));
      if (response.statusCode == 200) {
        Navigator.of(context).pop();
        setState(() {
          _users.removeWhere((user) => user.email == userId);
        });
      } else {
        print('Error deleting user: ${response.statusCode}');
      }
    } catch (error) {
      print('Error deleting user: $error');
    }
  }

  void _showDeleteConfirmationDialog(User user) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete User'),
          content: Text(
              'Are you sure you want to delete ${user.firstName} ${user.lastName}?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Delete'),
              onPressed: () {
                deleteUser(user.email);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _searchController,
                onChanged: (value) {
                  print(value);
                  _filterUsers(value);
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
            Center(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Container(
                    padding: EdgeInsets.all(16.0),
                    child: DataTable(
                      columnSpacing: 20.0,
                      dataRowHeight: 60.0,
                      columns: [
                        DataColumn(
                          label: Row(
                            children: [
                              Icon(Icons.person, color: Colors.black),
                              SizedBox(width: 4.0),
                              Text(
                                'First Name',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16.0,
                                    color: Colors.black),
                              ),
                            ],
                          ),
                        ),
                        DataColumn(
                          label: Row(
                            children: [
                              Icon(Icons.person, color: Colors.black),
                              SizedBox(width: 4.0),
                              Text(
                                'Last Name',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16.0,
                                    color: Colors.black),
                              ),
                            ],
                          ),
                        ),
                        DataColumn(
                          label: Row(
                            children: [
                              Icon(Icons.email, color: Colors.black),
                              SizedBox(width: 4.0),
                              Text(
                                'Email',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16.0,
                                    color: Colors.black),
                              ),
                            ],
                          ),
                        ),
                        DataColumn(
                          label: Row(
                            children: [
                              Icon(Icons.phone, color: Colors.black),
                              SizedBox(width: 4.0),
                              Text(
                                'Phone',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16.0,
                                    color: Colors.black),
                              ),
                            ],
                          ),
                        ),
                        DataColumn(
                          label: Row(
                            children: [
                              Icon(Icons.car_rental, color: Colors.black),
                              SizedBox(width: 4.0),
                              Text(
                                'Car Model',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16.0,
                                    color: Colors.black),
                              ),
                            ],
                          ),
                        ),
                        DataColumn(
                          label: Row(
                            children: [
                              Icon(Icons.location_city, color: Colors.black),
                              SizedBox(width: 4.0),
                              Text(
                                'City',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16.0,
                                    color: Colors.black),
                              ),
                            ],
                          ),
                        ),
                        DataColumn(
                          label: Row(
                            children: [
                              Icon(Icons.location_on, color: Colors.black),
                              SizedBox(width: 4.0),
                              Text(
                                'Street',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16.0,
                                    color: Colors.black),
                              ),
                            ],
                          ),
                        ),
                        DataColumn(
                          label: Row(
                            children: [
                              Icon(Icons.delete, color: Colors.black),
                              SizedBox(width: 4.0),
                              Text(
                                'Actions',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16.0,
                                    color: Colors.black),
                              ),
                            ],
                          ),
                        ),
                      ],
                      rows: _filteredUsers.map((user) {
                        final bool isEvenRow =
                            _filteredUsers.indexOf(user) % 2 == 0;
                        final Color rowColor = isEvenRow
                            ? Colors.grey[200]!
                            : mainColor.withOpacity(0.5);

                        return DataRow(
                          color: MaterialStateColor.resolveWith(
                              (states) => rowColor),
                          cells: [
                            DataCell(
                              Row(
                                children: [
                                  Container(
                                    width: 40.0,
                                    height: 40.0,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: mainColor,
                                    ),
                                    child: Center(
                                      child: Text(
                                        user.firstName[0] + user.lastName[0],
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16.0,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 10.0),
                                  Text(
                                    user.firstName,
                                    style: TextStyle(fontSize: 16.0),
                                  ),
                                ],
                              ),
                            ),
                            DataCell(
                              Text(
                                user.lastName,
                                style: TextStyle(fontSize: 16.0),
                              ),
                            ),
                            DataCell(
                              Text(
                                user.email,
                                style: TextStyle(fontSize: 16.0),
                              ),
                            ),
                            DataCell(
                              Text(
                                user.phone,
                                style: TextStyle(fontSize: 16.0),
                              ),
                            ),
                            DataCell(
                              Text(
                                user.carModel,
                                style: TextStyle(fontSize: 16.0),
                              ),
                            ),
                            DataCell(
                              Text(
                                user.city,
                                style: TextStyle(fontSize: 16.0),
                              ),
                            ),
                            DataCell(
                              Text(
                                user.street,
                                style: TextStyle(fontSize: 16.0),
                              ),
                            ),
                            DataCell(
                              IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () =>
                                    _showDeleteConfirmationDialog(user),
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                    )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

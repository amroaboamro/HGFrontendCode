import 'package:flutter/material.dart';
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
    // try {
    //   final response = await http.get(Uri.parse('your_api_url/users'));
    //   final jsonData = jsonDecode(response.body);
    //   List<User> users = [];
    //   for (var user in jsonData) {
    //     users.add(User(
    //       id: user['id'],
    //       firstName: user['firstName'],
    //       lastName: user['lastName'],
    //       email: user['email'],
    //       phone: user['phone'],
    //       carModel: user['carModel'],
    //       city: user['city'],
    //       street: user['street'],
    //     ));
    //   }
    //   setState(() {
    //     _users = users;
    //       _filteredUsers = users;
    //   });
    // } catch (error) {
    //   print('Error fetching data: $error');
    // }
    Future.delayed(Duration(seconds: 1),(){
        List<User> users = [];
        final jsonData = jsonDecode('''

   [
    {
      "id": "1",
      "firstName": "John",
      "lastName": "Doe",
      "email": "johndoe@example.com",
      "phone": "1234567890",
      "carModel": "Toyota Camry",
      "city": "New York",
      "street": "123 Main St"
    },
    {
      "id": "2",
      "firstName": "Jane",
      "lastName": "Smith",
      "email": "janesmith@example.com",
      "phone": "0987654321",
      "carModel": "Honda Accord",
      "city": "Los Angeles",
      "street": "456 Elm St"
    }
  ]

''');

        for (var user in jsonData) {
          users.add(User(
            id: user['id'],
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
    });
  }

  Future<void> deleteUser(String userId) async {
    try {
      final response = await http.delete(Uri.parse('your_api_url/users/$userId'));
      if (response.statusCode == 200) {
        Navigator.of(context).pop();
        setState(() {
          _users.removeWhere((user) => user.id == userId);
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
          content: Text('Are you sure you want to delete ${user.firstName} ${user.lastName}?'),
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

                deleteUser(user.id);
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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              onChanged: (value){
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
                  horizontalMargin: 10.0,
                  headingRowHeight: 60.0,
                  dataRowHeight: 80.0,
                  columns: [
                    DataColumn(
                      label: Text(
                        'First Name',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Last Name',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Email',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Phone',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Car Model',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'City',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Street',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Actions',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
                      ),
                    ),
                  ],
                  rows: _filteredUsers.map((user) {
                    return DataRow(cells: [
                      DataCell(
                        Text(
                          user.firstName,
                          style: TextStyle(fontSize: 16.0),
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
                          onPressed: () => _showDeleteConfirmationDialog(user),
                        ),
                      ),
                    ]);
                  }).toList(),
                ),
              ),
            ),
          ),
        ],
      ),

    );
  }

}

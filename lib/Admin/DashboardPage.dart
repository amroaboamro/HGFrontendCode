import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:head_gasket/Widget/background.dart';
import 'package:head_gasket/global.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:charts_flutter_new/flutter.dart' as charts;
class User {
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String carModel;

  User({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.carModel,
  });
}

class Order {
  final String serviceName;
  final String clientName;
  final String workerName;
  final String location;
  final double price;
  final String paymentMethod;

  Order({
    required this.serviceName,
    required this.clientName,
    required this.workerName,
    required this.location,
    required this.price,
    required this.paymentMethod,
  });
}

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int usersCount = 20;
  int workersCount = 10;
  int ordersCount = 0;
  int productsCount = 12;
  int servicesCount = 20;
  int carModelsCount = 0;
  List<dynamic> users = [];
  List<dynamic> orders = [];

  Future<void> fetchDataUsersAndOrders() async {
    try {
      final usersResponse = await http.get(Uri.parse(global.ip+'/getRecentUsers'));
      final ordersResponse = await http.get(Uri.parse(global.ip+'/getRecentOrders'));

      if (usersResponse.statusCode == 200 && ordersResponse.statusCode == 200) {
        final usersJson = json.decode(usersResponse.body);
        final ordersJson = json.decode(ordersResponse.body);

        setState(() {
          users = usersJson
              .map((userJson) => User(
            firstName: userJson['firstName'],
            lastName: userJson['lastName'],
            email: userJson['email'],
            phone: userJson['phone'],
            carModel: userJson['carModel'],
          ))
              .toList();

          orders = ordersJson
              .map((orderJson) => Order(
            serviceName: orderJson['serviceName'],
            clientName: orderJson['userName'],
            workerName: orderJson['workerName'],
            location: '${orderJson['city']}, ${orderJson['street']}',
            price: orderJson['price'].toDouble(),
            paymentMethod: orderJson['payment'],
          ))
              .toList();
        });
      } else {
        print('Failed to fetch data');
      }
    } catch (error) {
      print('Error: $error');
    }

  }

  late List<charts.Series<Data, String>> _chartData = [];

  @override
  void initState() {
    super.initState();
    _generateChartData();

    fetchData();
    fetchDataUsersAndOrders();
  }

  Future<void> fetchData() async {
    try {
      final response = await http.get(Uri.parse(global.ip +'/getNumbers'));

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        setState(() {
          usersCount = responseData['users'];
          workersCount = responseData['workers'];
          ordersCount = responseData['orders'];
          productsCount = responseData['products'];
          servicesCount = responseData['services'];
          carModelsCount = responseData['car_models'];
        });

        _generateChartData();
      } else {
        print('Error fetching data. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching data: $error');
    }
  }

  void _generateChartData() {
    final data = [
      Data('Users', usersCount),
      Data('Workers', workersCount),
      Data('Orders', ordersCount),
      Data('Products', productsCount),
      Data('Services', servicesCount),
      Data('Car Models', carModelsCount),
    ];
    _chartData = [
      charts.Series<Data, String>(
        id: 'Data',
        domainFn: (Data data, _) => data.label,
        measureFn: (Data data, _) => data.value,
        data: data,
        colorFn: (_, __) => charts.ColorUtil.fromDartColor(mainColor),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [

            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildDataCard('Users', usersCount,false),
                _buildDataCard('Workers', workersCount,false),
                _buildDataCard('Orders', ordersCount,false),
                _buildDataCard('Services', servicesCount,true),
              ],
            ),
              SizedBox(height: 20),
            _buildChart(),
            SizedBox(height: 20),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Column(

            children: [
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Recent Users',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              DataTable(
                columnSpacing: 20.0,
                horizontalMargin: 10.0,
                columns: [
                  DataColumn(
                    label: Text('First Name'),
                  ),
                  DataColumn(
                    label: Text('Last Name'),
                  ),
                  DataColumn(
                    label: Text('Email'),
                  ),
                  DataColumn(
                    label: Text('Phone'),
                  ),
                  DataColumn(
                    label: Text('Car Model'),
                  ),

                ],
                rows: users.map(
                      (user) {
                    return DataRow(
                      cells: [
                        DataCell(
                          Row(
                            children: [
                              Icon(Icons.person),
                              SizedBox(width: 5.0),
                              Text(user.firstName),
                            ],
                          ),

                          onTap: () {
                            print('Tapped on first name: ${user.firstName}');
                          },
                        ),
                        DataCell(Text(user.lastName)),
                        DataCell(Text(user.email)),
                        DataCell(Text(user.phone)),
                        DataCell(Text(user.carModel)),

                      ],
                      color: MaterialStateColor.resolveWith(
                            (states) {
                          final rowIndex = users.indexOf(user);
                          return rowIndex % 2 == 0 ? Colors.grey[200]! : mainColor.withOpacity(0.5);
                        },
                      ),
                    );
                  },
                ).toList(),
              ),

            ],
          ),
        ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      'Recent Orders',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
        DataTable(
          columnSpacing: 20.0,
          horizontalMargin: 10.0,
          columns: [
            DataColumn(label: Text('Service Name')),
            DataColumn(label: Text('Client Name')),
            DataColumn(label: Text('Worker Name')),
            DataColumn(label: Text('Location')),
            DataColumn(label: Text('Price')),
            DataColumn(label: Text('Payment Method')),
          ],
          rows: orders.map(
                (order) {
              return DataRow(
                cells: [
                  DataCell(Text(order.serviceName)),
                  DataCell(Text(order.clientName)),
                  DataCell(Text(order.workerName)),
                  DataCell(Text(order.location)),
                  DataCell(Text(order.price.toString())),
                  DataCell(Text(order.paymentMethod)),
                ],
                color: MaterialStateColor.resolveWith(
                      (states) {
                    final rowIndex = orders.indexOf(order);
                    return rowIndex % 2 == 0 ? Colors.grey[200]! : mainColor.withOpacity(0.5);
                  },
                ),
              );
            },
          ).toList(),
        ),
                ],
              ),
            )


          ],
        ),
      ),
    );
  }

  Widget _buildDataCard(String title, int count,bool isGreen) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),

          gradient:  isGreen
              ? LinearGradient(
            colors: [mainColor, Colors.blueGrey.shade700],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          )
              : LinearGradient(
            colors: [Colors.white, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        padding: EdgeInsets.all(20.0),
        child: Column(
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color:isGreen? Colors.white : Colors.black,
              ),
            ),
            SizedBox(height: 10),
            Text(
              count.toString(),
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color:isGreen? Colors.white : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChart() {
    return Container(
      height: 300,
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: charts.BarChart(
        _chartData,
        animate: true,
        vertical: true,
        barRendererDecorator: charts.BarLabelDecorator<String>(
          insideLabelStyleSpec: charts.TextStyleSpec(
            color: charts.MaterialPalette.white,
            fontSize: 12,
          ),
          outsideLabelStyleSpec: charts.TextStyleSpec(
            color: charts.MaterialPalette.black,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}

class Data {
  final String label;
  final int value;

  Data(this.label, this.value);
}

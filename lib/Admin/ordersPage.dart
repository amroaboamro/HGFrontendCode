import 'package:flutter/material.dart';

import '../Classes/Order.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:head_gasket/global.dart';

class OrderPage extends StatefulWidget {
  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  List<Order> orders = [];
  List<Order> filteredOrders = [];
  List<String> statuses = [
    'Requested',
    'Processing',
    'Waiting',
    'Completed',
    'Canceled',
    'All'
  ];
  String selectedStatus = 'All';
  Future<void> fetchOrders() async {
    final response = await http.get(Uri.parse(global.ip + '/allOrders'));
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      List<Order> fetchedOrders = [];
      for (var orderData in jsonData) {
        Order order = Order.fromJson(orderData);
        fetchedOrders.add(order);
      }
      setState(() {
        orders = fetchedOrders;
        filterOrdersByStatus();
      });
    } else {
      print('Error fetching orders: ${response.statusCode}');
    }

//          Future.delayed(Duration(seconds: 1),(){
//       final jsonList = jsonDecode('''[
//   {
//     "_id": "1",
//     "serviceName": "Service 1",
//     "price": 29.99,
//     "note": "Order note 1",
//     "status": "Completed",
//     "date": "2023-05-20T12:30:00",
//     "userName": "John Doe",
//     "workerName": "Jane Smith",
//     "street": "123 Main Street",
//     "city": "New York",
//     "carModel": "Toyota Camry",
//     "delivery": "Express",
//     "payment": "Credit Card"
//   },
//   {
//     "_id": "2",
//     "serviceName": "Service 2",
//     "price": 49.99,
//     "note": "Order note 2",
//     "status": "Requested",
//     "date": "2023-05-21T09:45:00",
//     "userName": "Alice Johnson",
//     "workerName": "Mike Anderson",
//     "street": "456 Elm Street",
//     "city": "Los Angeles",
//     "carModel": "Honda Civic",
//     "delivery": "Standard",
//     "payment": "Cash"
//   }

// ]''') as List<dynamic>;
//       List<Order> fetchedOrders = [];
//              for (var orderData in jsonList) {
//                Order order = Order.fromJson(orderData);
//                fetchedOrders.add(order);
//              }
//              setState(() {
//                orders = fetchedOrders;
//                filterOrdersByStatus();
//              });
//              });
  }

  void filterOrdersByStatus() {
    if (selectedStatus == 'All') {
      filteredOrders = List.from(orders);
    } else {
      filteredOrders =
          orders.where((order) => order.status == selectedStatus).toList();
    }
  }

  @override
  void initState() {
    super.initState();
    fetchOrders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Wrap(
              spacing: 8.0,
              children: statuses.map((status) {
                return ChoiceChip(
                  label: Text(status),
                  selected: selectedStatus == status,
                  onSelected: (isSelected) {
                    setState(() {
                      selectedStatus = isSelected ? status : 'All';
                      filterOrdersByStatus();
                    });
                  },
                );
              }).toList(),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: <DataColumn>[
                  DataColumn(
                    label: Row(
                      children: [
                        Icon(Icons.assignment),
                        SizedBox(width: 4),
                        Text('Service Name'),
                      ],
                    ),
                  ),
                  DataColumn(
                    label: Row(
                      children: [
                        Icon(Icons.person),
                        SizedBox(width: 4),
                        Text('Client Name'),
                      ],
                    ),
                  ),
                  DataColumn(
                    label: Row(
                      children: [
                        Icon(Icons.work),
                        SizedBox(width: 4),
                        Text('Worker Name'),
                      ],
                    ),
                  ),
                  DataColumn(
                    label: Row(
                      children: [
                        Icon(Icons.info),
                        SizedBox(width: 4),
                        Text('Status'),
                      ],
                    ),
                  ),
                  DataColumn(
                    label: Row(
                      children: [
                        Icon(Icons.location_on),
                        SizedBox(width: 4),
                        Text('Location'),
                      ],
                    ),
                  ),
                  DataColumn(
                    label: Row(
                      children: [
                        Icon(Icons.calendar_today),
                        SizedBox(width: 4),
                        Text('Date'),
                      ],
                    ),
                  ),
                  DataColumn(
                    label: Row(
                      children: [
                        Icon(Icons.payment),
                        SizedBox(width: 4),
                        Text('Payment Method'),
                      ],
                    ),
                  ),
                  DataColumn(
                    label: Row(
                      children: [
                        Icon(Icons.attach_money),
                        SizedBox(width: 4),
                        Text('Price'),
                      ],
                    ),
                  ),
                ],
                rows: List<DataRow>.generate(
                  filteredOrders.length,
                  (index) {
                    Color statusColor;
                    switch (filteredOrders[index].status) {
                      case 'Requested':
                        statusColor = Colors.blue;
                        break;
                      case 'Processing':
                        statusColor = Colors.orange;
                        break;
                      case 'Waiting':
                        statusColor = Colors.yellow;
                        break;
                      case 'Completed':
                        statusColor = Colors.green;
                        break;
                      case 'Canceled':
                        statusColor = Colors.red;
                        break;
                      default:
                        statusColor = Colors.grey;
                    }

                    return DataRow(
                      cells: <DataCell>[
                        DataCell(Text(filteredOrders[index].serviceName)),
                        DataCell(Text(filteredOrders[index].userName)),
                        DataCell(Text(filteredOrders[index].workerName)),
                        DataCell(Container(
                          decoration: BoxDecoration(
                            color: statusColor,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          padding: EdgeInsets.all(4),
                          child: Text(
                            filteredOrders[index].status,
                            style: TextStyle(color: Colors.white),
                          ),
                        )),
                        DataCell(Text(filteredOrders[index].city +
                            ',' +
                            filteredOrders[index].street)),
                        DataCell(Text(filteredOrders[index].date)),
                        DataCell(Text(filteredOrders[index].payment)),
                        DataCell(Text('\$${filteredOrders[index].price}')),
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: OrderPage(),
  ));
}

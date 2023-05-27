import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../Classes/Order.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:head_gasket/global.dart';

class OrderPage extends StatefulWidget {
  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  Future<void> _updateOrderStatus(String id ,String status) async {
    try {
      final response = await http.patch(
        Uri.parse(global.ip + '/updateOrder/$id'),
        body: jsonEncode({'status': status}),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        setState(() {
          fetchOrders();

        });
        Fluttertoast.showToast(
          msg: 'Order status canceled successfully!',
          backgroundColor: Colors.green,
        );
        Navigator.of(context).pop();
      } else {
        Fluttertoast.showToast(
          msg: 'Failed to update order status. Please try again later.',
          backgroundColor: Colors.red,
        );
      }
    }
    catch(e){
      Fluttertoast.showToast(
        msg: 'Failed to update order status. Please try again later.',
        backgroundColor: Colors.red,
      );

    }
  }

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
                        DataCell(Row(
                          children: [
                            Text(filteredOrders[index].serviceName),
                            if(orders[index].status!='Canceled')

                              IconButton(onPressed: (){

                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text('Confirm Cancel'),
                                    content: Text(
                                        'Are you sure you want to cancel this order?'),
                                    actions: <Widget>[
                                      TextButton(
                                        child: Text('Cancel'),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                      TextButton(
                                        child: Text('Confirm'),
                                        onPressed: () async {
                                          // Send status to API and show toast
                                          await _updateOrderStatus(orders[index].id,'Canceled');
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );


                            }, icon: Icon(Icons.cancel) ,color: Colors.red,),

                          ],
                        ),
                        ),
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

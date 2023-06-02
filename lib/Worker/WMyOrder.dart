import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:head_gasket/Widget/background.dart';
import 'package:head_gasket/Worker/CarReport.dart';
import 'package:head_gasket/Worker/reportView.dart';
import 'package:http/http.dart' as http;
import '../Classes/Order.dart';
import '../user/OrderDetails.dart';
import 'AcceptWOrderDetailes.dart';
import 'package:head_gasket/global.dart';

class OrdersPage extends StatefulWidget {
  @override
  _OrdersPageState createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  void notify(String userEmail) async {

    final response = await http.patch(
      Uri.parse(global.ip + '/userUpdate/'+userEmail),
      body: {
        'userNotify': 'Your order has new changes',
      },
    );

    if (response.statusCode == 200) {
      Fluttertoast.showToast(
        msg: 'We will notify user with changes',
        backgroundColor: Colors.green,
      );
    } else {
      Fluttertoast.showToast(
        msg: 'Error sending notification to the user',
        backgroundColor: Colors.red,
      );
    }

  }

  Future<void> _updateOrderStatus(String id, String status,notifyFunc) async {
    try {
      final response = await http.patch(
        Uri.parse(global.ip + '/updateOrder/$id'),
        body: jsonEncode({'status': status}),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        setState(() {});
        Fluttertoast.showToast(
          msg: 'Order status updated successfully!',
          backgroundColor: Colors.green,
        );
        Navigator.of(context).pop();
        notifyFunc();
      } else {
        Fluttertoast.showToast(
          msg: 'Failed to update order status. Please try again later.',
          backgroundColor: Colors.red,
        );
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'Failed to update order status. Please try again later.',
        backgroundColor: Colors.red,
      );
    }
  }

  Future<List<Order>> _fetchOrders() async {
    final response = await http.get(
        Uri.parse(global.ip + '/workerOrders/' + global.userData['email']));
    if (response.statusCode == 200) {
      final jsonList = jsonDecode(response.body) as List<dynamic>;
      return jsonList.map((json) => Order.fromJson(json)).toList();
    } else {
      throw Exception('Failed to fetch orders');
    }
    return Future.delayed(Duration(seconds: 2), () {
      final jsonList = jsonDecode(
          '''[  {    "_id": "1",    "orderNumber": "10100",    "serviceName": "Car Wash",    "price": 50.0,    "note": "Please use only eco-friendly products",    "status": "Requested",    "date": "2023-05-13",    "user": "John Doe",    "worker": "Jane Smith",    "street": "123 Main St.",    "city": "Anytown",    "carModel": "Honda Civic"  },  {    "_id": "2",    "orderNumber": "1056",    "serviceName": "Oil Change",    "price": 80.0,    "note": "Please check the brake pads as well",    "status": "Processing",    "date": "2023-05-14",    "user": "Alice Johnson",    "worker": "Bob Brown",    "street": "456 Oak Ave.",    "city": "Somecity",    "carModel": "Toyota Camry"  },  {    "_id": "3",    "orderNumber": "11200",    "serviceName": "Car Detailing",    "price": 120.0,    "note": "Please remove all pet hair",    "status": "Completed",    "date": "2023-05-15",    "user": "Emily Chen",    "worker": "David Lee",    "street": "789 Pine St.",    "city": "Anycity",    "carModel": "Ford Mustang"  },  {    "_id": "4",    "orderNumber": "1050",    "serviceName": "Car Detailing",    "price": 120.0,    "note": "Please remove all pet hair",    "status": "Waiting",    "date": "2023-05-15",    "user": "Emily Chen",    "worker": "David Lee",    "street": "789 Pine St.",    "city": "Anycity",    "carModel": "Ford Mustang"  },  {    "_id": "5",    "orderNumber": "1000",    "serviceName": "Tire Rotation",    "price": 60.0,    "note": "Please make sure to rotate all 4 tires",    "status": "Canceled",    "date": "2023-05-16",    "user": "Mark Davis",    "worker": "Lisa Kim",    "street": "1010 Elm St.",    "city": "Anothercity",    "carModel": "Nissan Altima"  }]

''') as List<dynamic>;
      return jsonList.map((json) => Order.fromJson(json)).toList();
    });
  }

  List<Order> _orders = [];

  String _selectedStatus = 'All';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,

        title: Text('Orders'),
        backgroundColor: mainColor,
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/ranger.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            SizedBox(
              height: 30,
            ),
            _buildFilterChips(),
            SizedBox(
              height: 30,
            ),
            Expanded(
              child: FutureBuilder<List<Order>>(
                future: _fetchOrders(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (snapshot.hasData) {
                    _orders = snapshot.data!;
                    return ListView.builder(
                      itemCount: _orders.length,
                      itemBuilder: (BuildContext context, int index) {
                        final order = _orders[index];
                        if (_selectedStatus != 'All' &&
                            order.status != _selectedStatus) {
                          return SizedBox.shrink();
                        }
                        return _buildOrderCard(order);
                      },
                    );
                  }

                  return Container();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChips() {
    return Wrap(
      spacing: 10.0,
      children: [
        ChoiceChip(
          label: Text('All'),
          selected: _selectedStatus == 'All',
          onSelected: (selected) {
            setState(() {
              _selectedStatus = 'All';
            });
          },
          selectedColor: mainColor,
        ),
        ChoiceChip(
          label: Text('Requested'),
          selected: _selectedStatus == 'Requested',
          onSelected: (selected) {
            setState(() {
              _selectedStatus = 'Requested';
            });
          },
          selectedColor: Colors.blue.shade200,
        ),
        ChoiceChip(
          label: Text('Waiting'),
          selected: _selectedStatus == 'Waiting',
          onSelected: (selected) {
            setState(() {
              _selectedStatus = 'Waiting';
            });
          },
          selectedColor: Colors.orange.shade200,
        ),
        ChoiceChip(
          label: Text('Processing'),
          selected: _selectedStatus == 'Processing',
          onSelected: (selected) {
            setState(() {
              _selectedStatus = 'Processing';
            });
          },
          selectedColor: Colors.yellow.shade200,
        ),
        ChoiceChip(
          label: Text('Completed'),
          selected: _selectedStatus == 'Completed',
          onSelected: (selected) {
            setState(() {
              _selectedStatus = 'Completed';
            });
          },
          selectedColor: Colors.green.shade200,
        ),
        ChoiceChip(
          label: Text('Canceled'),
          selected: _selectedStatus == 'Canceled',
          onSelected: (selected) {
            setState(() {
              _selectedStatus = 'Canceled';
            });
          },
          selectedColor: Colors.red.shade200,
        ),
      ],
    );
  }

  Widget _buildOrderCard(Order order) {
    final Color statusColor = _getStatusColor(order.status);
    return Card(
      margin: const EdgeInsets.all(8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      elevation: 4.0,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                if(order.status!='Completed')

                  Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => OrderDetails(order: order)),
                );
                if(order.status=='Completed')
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ReportReviewPage(order: order),
                    ),
                  );
              },
              child: CircleAvatar(
                radius: 32.0,
                backgroundColor: Colors.grey[200],
                backgroundImage: AssetImage('assets/images/order.png'),
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: CircleAvatar(
                    radius: 30.0,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.car_repair_rounded,
                      size: 32.0,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: 16.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Order ${order.serviceName}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Text('Car: ${order.carModel}'),
                  SizedBox(height: 8.0),
                  Text('Service: ${order.serviceName}'),
                  SizedBox(height: 8.0),
                  Text(
                    'Status: ${order.status}',
                    style: TextStyle(
                      color: statusColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8.0),
                  if (order.status == 'Requested')
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      content: SingleChildScrollView(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            OrderDetailsWidget(
                                              order: order,
                                            )
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                              child: Text('Accept'),
                              style: ElevatedButton.styleFrom(
                                primary: Colors.green,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                padding: EdgeInsets.symmetric(vertical: 16.0),
                              ),
                            ),
                          ),
                          SizedBox(width: 16.0),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text('Confirm Deny'),
                                      content: Text(
                                          'Are you sure you want to deny this order?'),
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
                                            await _updateOrderStatus(
                                                order.id, 'Canceled',(){
                                                  notify(order.userEmail);
                                            });
                                            setState(() {});
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              child: Text('Deny'),
                              style: ElevatedButton.styleFrom(
                                primary: Colors.red,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                padding: EdgeInsets.symmetric(vertical: 16.0),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  SizedBox(height: 8.0),
                  if (order.status == 'Processing')
                    Row(
                      children: [
                        Checkbox(
                          value: false,
                          onChanged: (value) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => WorkerReport(order: order)),
                            );
                          },
                        ),
                        Text('Complete Report'),
                      ],
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case ''
          'Requested':
        return Colors.blue;
      case 'Waiting':
        return Colors.orange;
      case 'Processing':
        return Colors.yellow;
      case 'Completed':
        return Colors.green;
      case 'Canceled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}

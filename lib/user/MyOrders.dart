import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:head_gasket/global.dart';
import 'package:head_gasket/user/OrderOptions.dart';
import '../Classes/Order.dart';
import '../Widget/background.dart';
import 'OrderDetails.dart';
import 'package:http/http.dart' as http;



class MyOrders extends StatefulWidget {
  const MyOrders({Key? key}) : super(key: key);

  @override
  _MyOrdersState createState() => _MyOrdersState();
}

class _MyOrdersState extends State<MyOrders> {
  List<String> filterOptions = ['All','Requested','Waiting' , 'Processing','Completed', 'Canceled'];

  String selectedOption = 'All';

   List<Order> orders = [];

  Future<void> _updateOrderStatus(String id ,String status) async {
    try {
      final response = await http.post(
        Uri.parse('https://aasa.com/orders/$id'),
        body: jsonEncode({'status': status}),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        setState(() {});
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

  Future<List<Order>> _fetchOrders() async {
    final response =
        await http.get(Uri.parse(global.ip+'/orders/'+global.userData['email']+'/'+global.userData['role']));
    if (response.statusCode == 200) {

      final jsonList = jsonDecode(response.body) as List<dynamic>;
      print(response.body);

      return jsonList.map((json) => Order.fromJson(json)).toList();
    } else {
      throw Exception('Failed to fetch orders');
    }
//     return Future.delayed(Duration(seconds: 1),(){
//       final jsonList = jsonDecode('''[  {    "_id": "1",    "orderNumber": "10100",    "serviceName": "Car Wash",    "price": 50.0,    "note": "Please use only eco-friendly products",    "status": "Requested",    "date": "2023-05-13",    "user": "John Doe",    "worker": "Jane Smith",    "street": "123 Main St.",    "city": "Anytown",    "carModel": "Honda Civic"  },  {    "_id": "2",    "orderNumber": "1056",    "serviceName": "Oil Change",    "price": 80.0,    "note": "Please check the brake pads as well",    "status": "Processing",    "date": "2023-05-14",    "user": "Alice Johnson",    "worker": "Bob Brown",    "street": "456 Oak Ave.",    "city": "Somecity",    "carModel": "Toyota Camry"  },  {    "_id": "3",    "orderNumber": "11200",    "serviceName": "Car Detailing",    "price": 120.0,    "note": "Please remove all pet hair",    "status": "Completed",    "date": "2023-05-15",    "user": "Emily Chen",    "worker": "David Lee",    "street": "789 Pine St.",    "city": "Anycity",    "carModel": "Ford Mustang"  },  {    "_id": "4",    "orderNumber": "1050",    "serviceName": "Car Detailing",    "price": 120.0,    "note": "Please remove all pet hair",    "status": "Waiting",    "date": "2023-05-15",    "user": "Emily Chen",    "worker": "David Lee",    "street": "789 Pine St.",    "city": "Anycity",    "carModel": "Ford Mustang"  },  {    "_id": "5",    "orderNumber": "1000",    "serviceName": "Tire Rotation",    "price": 60.0,    "note": "Please make sure to rotate all 4 tires",    "status": "Canceled",    "date": "2023-05-16",    "user": "Mark Davis",    "worker": "Lisa Kim",    "street": "1010 Elm St.",    "city": "Anothercity",    "carModel": "Nissan Altima"  }]
//
// ''') as List<dynamic>;
//       return jsonList.map((json) => Order.fromJson(json)).toList();
//     });
  }

  List<Order> getFilteredOrders() {
    if (selectedOption == 'All') {
      return orders;
    } else {
      return orders.where((order) => order.status == selectedOption).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Orders'),
        backgroundColor: mainColor,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Sort By',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16),
                Wrap(

                  children: filterOptions.map((String option) {
                    return Container(
                      margin: EdgeInsets.symmetric(horizontal: 8),
                      child: ChoiceChip(
                        label: Text(option),
                        labelStyle: TextStyle(
                          color: selectedOption == option
                              ? Colors.white
                              : Colors.black,
                        ),
                        backgroundColor: selectedOption == option
                            ? mainColor
                            : Colors.grey[300],
                        selectedColor: mainColor,
                        selected: selectedOption == option,
                        onSelected: (bool selected) {
                          setState(() {
                            selectedOption = selected ? option : 'All';
                            // Do something with the selected option
                          });
                        },
                      ),
                    );
                  }).toList(),
                ),

              ],
            ),
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
        orders = snapshot.data!;
        return ListView.builder(
          itemCount: getFilteredOrders().length,
          itemBuilder: (BuildContext context, int index) {
            Order order = getFilteredOrders()[index];
            Color statusColor =
                Colors.grey; // Default color for unknown status
            switch (order.status) {
              case 'Requested':
                statusColor = Colors.blue;
                break;
              case 'Completed':
                statusColor = Colors.green;
                break;
              case 'Waiting':
                statusColor = Colors.orange;
                break;
              case 'Processing':
                statusColor = Colors.yellow;
                break;
              case 'Canceled':
                statusColor = Colors.red;
                break;
            }
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          CircleAvatar(
                            backgroundImage: AssetImage(
                                'assets/images/order.png'),
                            radius: 30,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            order.serviceName,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                'Paid :\$ ' + order.price.toString(),
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.blueGrey,
                                ),
                              ),
                              SizedBox(
                                width: 30,
                              ),
                              Text(
                                order.date,
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.blueGrey,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [


                              Text(
                                order.status,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: statusColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(
                                width: 30,
                              ),
                              ElevatedButton(
                                child: Text(
                                  'Details',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.white, //background
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    side: BorderSide(color: Colors.black, width: 2),
                                  ),
                                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => OrderDetails(order: order),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                          SizedBox(height: 10,),
                          if (order.status == 'Waiting')
                          Row(
                            children: [
                              ElevatedButton(
                                child: Text(
                                  'Accept',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.green, //background
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  padding:
                                  EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => OrderOptions(order: order),
                                    ),
                                  );

                                },
                              ),
                              SizedBox(width: 10),
                              ElevatedButton(
                                child: Text(
                                  'Cancel',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.red, //background
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  padding:
                                  EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                                ),
                                onPressed: () {
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
                                              await _updateOrderStatus(order.id,'Canceled');
                                              setState(() {});
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                              ),
                            ],
                          ),

                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      }
      return Container();
    }
    ),
          ),
        ],
      ),
    );
  }
}

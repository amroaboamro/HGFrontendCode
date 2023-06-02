import 'package:flutter/material.dart';
import 'package:head_gasket/global.dart';

import '../Classes/Order.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

import '../Widget/background.dart';

class ReportReviewPage extends StatefulWidget {
  final Order order;

  ReportReviewPage({required this.order});

  @override
  State<ReportReviewPage> createState() => _ReportReviewPageState();
}

class _ReportReviewPageState extends State<ReportReviewPage> {
  var remainTime;

  Future<void> _updateOrderStatus(String id, String status) async {
    try {
      final response = await http.patch(
        Uri.parse(global.ip + '/updateOrder/$id'),
        body: jsonEncode({'status2': status}),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        setState(() {});
        Fluttertoast.showToast(
          msg: 'Order status updated successfully!',
          backgroundColor: Colors.green,
        );
        notify(widget.order.userEmail);
        Navigator.of(context).pop();
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

  Future fetchRemainTime(Order order) async {
    final response =
    await http.get(Uri.parse(global.ip + '/getRemainTime/' + order.id));
    print(response.body);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        remainTime = data['time'];
      });
    } else {
      throw Exception('Failed to fetch time for order');
    }
  }

  Future<dynamic> fetchImageForOrder(Order order) async {
    final response =
    await http.get(Uri.parse(global.ip + '/getOrderImage/' + order.id));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data;
    } else {
      throw Exception('Failed to fetch image for order');
    }
  }

  void notify(String userEmail) async {
    final response = await http.patch(
      Uri.parse(global.ip + '/userUpdate/' + userEmail),
      body: {
        'userNotify': 'Congratulations Your car is ready now !!',
      },
    );

    if (response.statusCode == 200) {
      Fluttertoast.showToast(
        msg: 'We will notify the user with changes',
        backgroundColor: Colors.green,
      );
    } else {
      Fluttertoast.showToast(
        msg: 'Error sending notification to the user',
        backgroundColor: Colors.red,
      );
    }
  }


  var orderImage;

  @override
  void initState() {
    super.initState();
    fetchImageForOrder(widget.order).then((value) {
      setState(() {
        orderImage = value['image'];
      });
    });
    fetchRemainTime(widget.order);
  }
  Color _getColorByStatus(String status) {
    switch (status) {
      case 'working':
        return Colors.yellow;
      case 'pending':
        return Colors.blue;
      case 'Completed':
        return Colors.green;
      case 'canceled':
        return Colors.red;
      default:
        return Colors.yellow; // Default color
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('Report Review'),
        backgroundColor: mainColor,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 200,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                image: DecorationImage(
                  image: orderImage != null
                      ? Image.memory(
                    base64Decode(orderImage),
                    fit: BoxFit.cover,
                  ).image
                      : Image.asset(
                    'assets/images/order.png',
                    fit: BoxFit.cover,
                  ).image,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    color: _getColorByStatus(widget.order.status2),
                    child: GestureDetector(
                      onTap: () {
                        if (widget.order.status2 == 'working') {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Mark as Done'),
                                content: Text('Are you sure you want to mark this as done?'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      _updateOrderStatus(widget.order.id, 'Completed');
                                    },
                                    child: Text('Mark as Done'),
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
                        }
                      },
                      child: ListTile(
                        leading: Icon(Icons.info, size: 24.0, color: mainColor),
                        title: Text(
                          'Maintenance Status',
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              (widget.order.status2=='working')?"In the Garage": widget.order.status2,
                              style: TextStyle(
                                fontSize: 14.0,
                                color: Colors.black87,
                              ),
                            ),
                            Text(
                              remainTime!=null ? remainTime :'',
                              style: TextStyle(
                                fontSize: 14.0,
                                color: Colors.black87,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),

                  ListTile(
                    leading: Icon(
                      Icons.date_range_rounded,
                      size: 24.0,
                      color: mainColor,
                    ),
                    title: Text(
                      'Starting Date',
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      widget.order.status2 == 'working'
                          ? DateFormat('EEEE, MMMM d, yyyy - hh:mm a')
                          .format(
                          DateTime.parse(widget.order.startingTime))
                          : "------",
                      style: TextStyle(
                        fontSize: 14.0,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.date_range_rounded,
                      size: 24.0,
                      color: mainColor,
                    ),
                    title: Text(
                      'Delivery Date',
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      widget.order.status2 == 'working'
                          ? DateFormat('EEEE, MMMM d, yyyy - hh:mm a')
                          .format(
                          DateTime.parse(widget.order.endingTime))
                          : "------",
                      style: TextStyle(
                        fontSize: 14.0,
                        color: Colors.black87,
                      ),
                    ),
                  ),


                  Row(
                    children: [
                      Expanded(
                        child: ListTile(
                          leading: Icon(Icons.attach_money,
                              size: 24.0, color: mainColor),
                          title: Text(
                            'Price Range',
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            widget.order.price1.toString() +
                                " - " +
                                widget.order.price2.toString() +
                                "\$",
                            style: TextStyle(
                              fontSize: 14.0,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ),

                      Expanded(
                        child: ListTile(
                          leading:
                          Icon(Icons.timer, size: 24.0, color: mainColor),
                          title: Text(
                            'Estimated Time',
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            widget.order.estimatedTime.toString()+'h',
                            style: TextStyle(
                              fontSize: 14.0,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ),

                    ],
                  ),
                  SizedBox(height: 15.0),
                  Center(
                    child: ListTile(
                      leading: Icon(
                        Icons.description,
                        size: 24.0,
                        color: mainColor,
                      ),
                      title: Text(
                        'Testing Result\n(' +
                            DateFormat('EEEE, MMMM d, yyyy - hh:mm a')
                                .format(DateTime.parse(widget.order.date)) +
                            ")",
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        widget.order.problem,
                        style: TextStyle(
                          fontSize: 14.0,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 15.0),
                  Row(
                    children: [
                      Expanded(
                        child: ListTile(
                          leading:
                          Icon(Icons.build, size: 24.0, color: mainColor),
                          title: Text(
                            'Service',
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            widget.order.serviceName,
                            style: TextStyle(
                              fontSize: 16.0,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: ListTile(
                          leading: Icon(Icons.local_shipping,
                              size: 24.0, color: mainColor),
                          title: Text(
                            'Delivery',
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            widget.order.delivery,
                            style: TextStyle(
                              fontSize: 14.0,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 15.0),
                  Row(
                    children: [
                      Expanded(
                        child: ListTile(
                          leading:
                          Icon(Icons.person, size: 24.0, color: mainColor),
                          title: Text(
                            'User Name',
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            widget.order.userName,
                            style: TextStyle(
                              fontSize: 14.0,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: ListTile(
                          leading:
                          Icon(Icons.work, size: 24.0, color: mainColor),
                          title: Text(
                            'Worker Name',
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            widget.order.workerName,
                            style: TextStyle(
                              fontSize: 14.0,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 15.0),
                  Row(
                    children: [
                      Expanded(
                        child: ListTile(
                          leading: Icon(Icons.location_on,
                              size: 24.0, color: mainColor),
                          title: Text(
                            'Location',
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            '${widget.order.street}, ${widget.order.city}',
                            style: TextStyle(
                              fontSize: 14.0,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: ListTile(
                          leading: Icon(Icons.directions_car,
                              size: 24.0, color: mainColor),
                          title: Text(
                            'Car Model',
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            widget.order.carModel,
                            style: TextStyle(
                              fontSize: 14.0,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 15.0),

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

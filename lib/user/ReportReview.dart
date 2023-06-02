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
        'workerNotify': 'there is a new car in your Garage',
      },
    );

    if (response.statusCode == 200) {
      Fluttertoast.showToast(
        msg: 'We will notify the worker with changes',
        backgroundColor: Colors.green,
      );
    } else {
      Fluttertoast.showToast(
        msg: 'Error sending notification to the worker',
        backgroundColor: Colors.red,
      );
    }
  }

  void submitReport() async {
    Map<String, dynamic> payload = {
      'status2': 'working',
      'email': widget.order.workerEmail,
      'estimatedTime': widget.order.estimatedTime,
    };
    print(widget.order.workerEmail);

    String jsonPayload = json.encode(payload);

    try {
      Uri apiUrl = Uri.parse(global.ip + '/updateOrder/' + widget.order.id);
      http.Response response = await http.patch(
        apiUrl,
        headers: {'Content-Type': 'application/json'},
        body: jsonPayload,
      );
      print(response.body);

      if (response.statusCode == 200) {
        Fluttertoast.showToast(
            msg: 'Report submitted successfully.',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            backgroundColor: mainColor);
        notify(widget.order.workerEmail);
        Navigator.of(context).pop();
      } else {
        Fluttertoast.showToast(
            msg: 'Failed to submit the report. Please try again.',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            backgroundColor: Colors.red);
      }
    } catch (error) {
      Fluttertoast.showToast(
          msg: 'An error occurred. Please try again.',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          backgroundColor: Colors.red);
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
                    child: ListTile(
                      leading: Icon(Icons.info, size: 24.0, color: mainColor),
                      title: Text(
                        'Maintenance Status',
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(

                        (widget.order.status2=='working')?"In the Garage": widget.order.status2,
                        style: TextStyle(
                          fontSize: 14.0,
                          color: Colors.black87,
                        ),
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
                  Row(
                    children: [
                      Expanded(
                        child: ListTile(
                          leading:
                          Icon(Icons.timer, size: 24.0, color: mainColor),
                          title: Text(
                            'Remainnig Time',
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            remainTime == null
                                ? "-----"
                                : remainTime.toString(),
                            style: TextStyle(
                              fontSize: 14.0,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: ListTile(
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
                  if (widget.order.status2 == 'pending')
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              submitReport();
                            },
                            style: ElevatedButton.styleFrom(
                              primary: Colors.green,
                            ),
                            child: Text('Accept'),
                          ),
                        ),
                        SizedBox(width: 10.0),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              _updateOrderStatus(widget.order.id, 'canceled');
                            },
                            style: ElevatedButton.styleFrom(
                              primary: Colors.red,
                            ),
                            child: Text('Deny'),
                          ),
                        ),
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
}

import 'package:flutter/material.dart';
import 'package:head_gasket/Classes/Order.dart';
import 'package:head_gasket/Widget/background.dart';
import 'package:head_gasket/global.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';



class WorkerReport extends StatefulWidget {
  final Order order;
  WorkerReport({required this.order});
  @override
  _WorkerReportState createState() => _WorkerReportState();
}

class _WorkerReportState extends State<WorkerReport> {
  double priceLowerRange = 0.0;
  double priceUpperRange = 0.0;
  int estimatedTimeHours = 0;
  String problemDescription = '';
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
  void submitReport() async {
    if (priceLowerRange <= 0.0 || priceUpperRange <= 0.0 || estimatedTimeHours <= 0 || problemDescription.isEmpty) {
      Fluttertoast.showToast(
        msg: 'Please fill in all the fields before submitting the report.',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );
      return;
    }

    Map<String, dynamic> payload = {
      'status':'Completed',
      'price1': priceLowerRange.toString(),
      'price2': priceUpperRange,
      'estimatedTime': estimatedTimeHours,
      'problem': problemDescription,
      'status2':'pending',
    };

    String jsonPayload = json.encode(payload);

    try {
      Uri apiUrl = Uri.parse(global.ip+'/updateOrder/'+widget.order.id);
      http.Response response = await http.patch(
        apiUrl,
        headers: {'Content-Type': 'application/json'},
        body: jsonPayload,
      );


      if (response.statusCode == 200) {
        Fluttertoast.showToast(
          msg: 'Report submitted successfully.',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          backgroundColor: mainColor
        );
        notify(widget.order.userEmail);
        Navigator.of(context).pop();
      } else {
        Fluttertoast.showToast(
          msg: 'Failed to submit the report. Please try again.',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          backgroundColor: Colors.red
        );
      }
    } catch (error) {
      Fluttertoast.showToast(
        msg: 'An error occurred. Please try again.',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
          backgroundColor: Colors.red

      );
    }
  }




  String getFormattedTime() {
    int days = estimatedTimeHours ~/ 24;
    int hours = estimatedTimeHours % 24;

    String formattedTime = '';
    if (days > 0) {
      formattedTime += '$days day${days > 1 ? 's' : ''} ';
    }
    if (hours > 0) {
      formattedTime += '$hours hour${hours > 1 ? 's' : ''}';
    }

    return formattedTime;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Worker Report'),
        backgroundColor: mainColor,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Price Range:',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                children: [
                  Icon(Icons.attach_money),
                  SizedBox(width: 10.0),
                  Expanded(
                    child: TextField(
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        setState(() {
                          priceLowerRange = double.tryParse(value) ?? 0.0;
                        });
                      },
                      decoration: InputDecoration(
                        labelText: 'Lower Range',
                      ),
                    ),
                  ),
                  SizedBox(width: 10.0),
                  Icon(Icons.arrow_forward),
                  SizedBox(width: 10.0),
                  Expanded(
                    child: TextField(
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        setState(() {
                          priceUpperRange = double.tryParse(value) ?? 0.0;
                        });
                      },
                      decoration: InputDecoration(
                        labelText: 'Upper Range',
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.0),
              Text(
                'Estimated Time:',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                children: [
                  Icon(Icons.schedule),
                  SizedBox(width: 10.0),
                  Expanded(
                    child: TextField(
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        setState(() {
                          estimatedTimeHours = int.tryParse(value) ?? 0;
                        });
                      },
                      decoration: InputDecoration(
                        labelText: 'Estimated Time (hours)',
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.0),
              Text(
                'Formatted Time:',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                getFormattedTime(),
                style: TextStyle(fontSize: 16.0),
              ),
              SizedBox(height: 20.0),
              Text(
                'Problem Description:',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextField(
                onChanged: (value) {
                  setState(() {
                    problemDescription = value;
                  });
                },
                maxLines: 4,
                decoration: InputDecoration(
                  labelText: 'Enter Problem Description',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () {
                  submitReport();
                },
                child: Text(
                  'Save Report',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  primary: mainColor,
                  padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 15.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

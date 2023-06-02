import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:head_gasket/Widget/background.dart';
import 'package:head_gasket/Worker/reportView.dart';
import 'package:head_gasket/global.dart';
import 'package:http/http.dart' as http;
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../Classes/Order.dart';

class EventCalendarPage extends StatefulWidget {
  @override
  _EventCalendarPageState createState() => _EventCalendarPageState();
}

class _EventCalendarPageState extends State<EventCalendarPage> {
  List<Appointment> _events = [];
  bool isScheduleView = true;

  late List<Order> orders=[];
  @override
  void initState() {
    super.initState();
    fetchAppointments();
  }
  Future<void> fetchAppointments() async {
    final url = global.ip + '/workerOrders/' + global.userData['email'];

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final jsonList = jsonDecode(response.body) as List<dynamic>;
         orders =jsonList.map((json) => Order.fromJson(json)).toList();
        setState(() {
          print(orders[0].id);
          _events = orders.where((data) => data.status2=='working')
              .map((data) =>  Appointment(
            startTime: DateTime.parse(data.startingTime),
            endTime: DateTime.parse(data.endingTime),
            subject: data.userName,
            color: _getRandomColor(),
            id: data.id,
          ))
              .toList();
        });
      } else {
        print('API request failed with status code ${response.statusCode}');
      }
    } catch (e) {
      print('Error occurred while fetching appointments: $e');
    }
  }



  Color _getRandomColor() {
    // Generate a random color for each event
    final Random random = Random();
    return Color.fromARGB(
      255,
      random.nextInt(256),
      random.nextInt(256),
      random.nextInt(256),
    );
  }

  @override
  Widget build(BuildContext context) {

    void toggleView() {
      setState(() {
        isScheduleView = !isScheduleView;
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Event Calendar'),
        backgroundColor: mainColor,
        automaticallyImplyLeading: false,


      ),
      body:
          SfCalendar(
        view: CalendarView.timelineWeek,
        dataSource: _getCalendarDataSource(),
            onTap: (CalendarTapDetails details) {
              if (details.targetElement == CalendarElement.appointment) {
                Appointment appointment = details.appointments![0];


                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ReportReviewPage(order: orders.firstWhere((data) => data.id==appointment.id))),
                );
    }
            },
      )

    );
  }


  _DataSource _getCalendarDataSource() {
    return _DataSource(_events);
  }
}

class _DataSource extends CalendarDataSource {
  _DataSource(List<Appointment> source) {
    appointments = source;
  }
}

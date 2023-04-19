import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:head_gasket/Widget/background.dart';
import 'package:head_gasket/Classes/service.dart';
import '../Widget/ServicesCarousel.dart';
import 'map.dart';

class Services extends StatefulWidget {
  const Services({Key? key}) : super(key: key);

  @override
  _ServicesState createState() => _ServicesState();
}

class _ServicesState extends State<Services> {
  Future<List<Service>>? _services;
  List<Service>? servicesList=[];
  bool _searchClicked = false;


  @override
  void initState() {
    super.initState();
    _services = _fetchServices();
  }
  List<Service> filteredServices = [];

  void filterServices(String query) {
    if (query.isNotEmpty && query != '') {
      setState(() {
        filteredServices = servicesList?.where((service) => service.name.toLowerCase().contains(query.toLowerCase())).toList() ??[];
      });
    } else {
      setState(() {
        filteredServices =[];
      });
    }
  }
  Future<List<Service>> _fetchServices() async {
    // final response = await http.get(Uri.parse('url'));
    // if (response.statusCode == 200) {
    //   final List<dynamic> jsonList = json.decode(response.body);
    //   final services = jsonList.map((json) => Service.fromJson(json)).toList().cast<Service>();
    //   return services;
    // } else {
    //   throw Exception('Failed to load services');
    // }
   return Future.delayed(Duration(seconds: 1),(){
      final List<dynamic> jsonList = json.decode(
          '''[  {    "imgUrl": "assets/images/flatTire.jpg",    "name": "Flat Tire",    "type": "Emergency"  },
          {    "imgUrl": "assets/images/gasPump.jpeg",    "name": "Fuel",    "type": "Emergency"  },
            {    "imgUrl": "assets/images/motor.jpg",    "name": "Motor",    "type": "Maintenance"  }, 
             {    "imgUrl": "assets/images/battery.jpg",    "name": "Service 3",    "type": "Emergency"  },
             {
  "imgUrl": "assets/images/recovery.jpg",
  "name": "Auto Repair",
  "type": "Care"
}
             ]''');
      final services = jsonList.map((json) => Service.fromJson(json)).toList().cast<Service>();
        return services;


   });
  }



  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text('Services'),
        ),

          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: IconButton(
                onPressed: () {
                  setState(() {
                    _searchClicked = !_searchClicked;
                  });
                },
                icon: Icon(
                  Icons.search,
                  color: Colors.white,
                ),
              ),
            ),
            if (_searchClicked)
              Expanded(
                child: TextField(
                  onChanged: (value) => filterServices(value),
                  decoration: InputDecoration(
                    hintText: 'Search...',
                  ),
                ),
              ),

        ],
        backgroundColor: mainColor,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 20,
            ),
            FutureBuilder<List<Service>>(
              future: _services,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                } else {
                  servicesList =snapshot.data;
                  if(filteredServices.isEmpty && !_searchClicked)filteredServices=servicesList!;
                  return Column(
                    children: [
                      if (filteredServices.isNotEmpty &&
                          filteredServices
                              .any((service) => service.type == 'Emergency'))
                        ServiceCarousel(
                          services: filteredServices
                              .where((service) => service.type == 'Emergency')
                              .toList(),
                          name: 'Emergency',
                        ),
                      if (filteredServices.isNotEmpty &&
                          filteredServices
                              .any((service) => service.type == 'Maintenance'))
                        ServiceCarousel(
                          services: filteredServices
                              .where((service) => service.type == 'Maintenance')
                              .toList(),
                          name: 'Maintenance',
                        ),
                      if (filteredServices.isNotEmpty &&
                          filteredServices.any((service) => service.type == 'Care'))
                        ServiceCarousel(
                          services:
                          filteredServices.where((service) => service.type == 'Care').toList(),
                          name: 'Care',
                        ),
                    ],
                  );

              }
              },
            ),
          ],
        ),
      ),
    );
  }


}

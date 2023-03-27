import 'package:flutter/material.dart';
import 'package:head_gasket/Classes/service.dart';
import 'package:head_gasket/Widget/background.dart';

class Test extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('title')),
      drawer: Drawer(
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the drawer if there isn't enough vertical
        // space to fit everything.
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text('Drawer Header'),
            ),
            ListTile(
              title: const Text('Item 1'),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Item 2'),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: Column(
        children: <Widget>[
          Container(
            height: 250.0,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: services.length,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  // onTap: () => Navigator.push(
                  //   context,
                  //   // MaterialPageRoute(
                  //   //   builder: (_) => DestinationScreen(
                  //   //     destination: destination,
                  //   //   ),
                  //   // ),
                  // ),
                  child: Container(
                    margin: EdgeInsets.all(10.0),
                    width: 210.0,
                    child: Stack(
                      alignment: Alignment.topCenter,
                      children: <Widget>[
                        Positioned(
                          top: 50.0,
                          child: Container(
                            height: 90.0,
                            width: 160.0,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(10.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Center(
                                    child: Text(
                                      services[index].name,
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 15.0,
                                        fontWeight: FontWeight.w600,
                                        letterSpacing: 1,
                                      ),
                                    ),
                                  ),
                                  // Text(
                                  //   destination.description,
                                  //   style: TextStyle(
                                  //     color: Colors.grey,
                                  //   ),
                                  // ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Container(
                          child: Stack(
                            children: <Widget>[
                              Hero(
                                tag: 'destination.imageUrl',
                                child: CircleAvatar(
                                  radius: 50,
                                  backgroundImage: AssetImage(
                                      'assets/images/recovery-vehicle.png'),
                                ),
                              ),
                              // Positioned(
                              //   left: 10.0,
                              //   bottom: 10.0,
                              //   child: Column(
                              //     crossAxisAlignment: CrossAxisAlignment.start,
                              //     children: <Widget>[
                              //       // Text(
                              //       //   'destination.city',
                              //       //   style: TextStyle(
                              //       //     color: Colors.black,
                              //       //     fontSize: 18.0,
                              //       //     fontWeight: FontWeight.w600,
                              //       //     letterSpacing: 1.2,
                              //       //   ),
                              //       // ),
                              //       // Row(
                              //       //   children: <Widget>[
                              //       //     Icon(
                              //       //       Icons.location_on_outlined,
                              //       //       size: 10.0,
                              //       //       color: Colors.black,
                              //       //     ),
                              //       //     SizedBox(width: 5.0),
                              //       //     Text(
                              //       //       'destination.country',
                              //       //       style: TextStyle(
                              //       //         color: Colors.black,
                              //       //       ),
                              //       //     ),
                              //       //   ],
                              //       // ),
                              //     ],
                              //   ),
                              // ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

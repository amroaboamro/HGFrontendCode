import 'package:flutter/material.dart';
import 'package:head_gasket/Classes/service.dart';


class ServiceCarousel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                'Emergency',
                style: TextStyle(
                  fontSize: 22.0,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                ),
              ),
              GestureDetector(
                onTap: () => print('See All'),
                child: Text(
                  'See All',
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.0,
                  ),
                ),
              ),
            ],
          ),
        ),
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
                        top: 80.0,
                        child: Container(
                          height: 90.0,
                          width: 140.0,
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
                                Text(
                                  services[index].name,
                                  style: TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 1,
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
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              offset: Offset(0.0, 2.0),
                              blurRadius: 6.0,
                            ),
                          ],
                        ),
                        child: Stack(
                          children: <Widget>[
                            Hero(
                              tag: 'destination.imageUrl',
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20.0),
                                child: Image(
                                  height: 120.0,
                                  width: 120.0,
                                  image: AssetImage(services[index].imgUrl),
                                  fit: BoxFit.cover,
                                ),
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
    );
  }
}
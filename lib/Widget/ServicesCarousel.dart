import 'package:flutter/material.dart';
import '../user/ServiceScreen.dart';

class ServiceCarousel extends StatefulWidget {
  final List services;

  final String name;

  ServiceCarousel({required this.services, required this.name});

  @override
  _ServiceCarouselState createState() => _ServiceCarouselState();
}

class _ServiceCarouselState extends State<ServiceCarousel> {
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
                widget.name,
                style: TextStyle(
                  fontSize: 22.0,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                ),
              ),
            ],
          ),
        ),
        Container(
          height: 220.0,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: widget.services.length,
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ServiceScreen(
                      service: widget.services[index],
                    ),
                  ),
                ),
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 18),
                  child: Stack(
                    alignment: Alignment.topCenter,
                    children: <Widget>[
                      Positioned(
                        top: 80.0,
                        child: Container(
                          height: 90.0,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  widget.services[index].name,
                                  style: TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 1,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  widget.name,
                                  style: TextStyle(
                                    color: Colors.grey,
                                  ),
                                ),
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
                                  image:
                                      AssetImage(widget.services[index].imgUrl),
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

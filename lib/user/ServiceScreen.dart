import 'package:flutter/material.dart';
import 'package:head_gasket/Widget/background.dart';
import '../Classes/service.dart';
import '../Classes/Worker.dart';

class ServiceScreen extends StatefulWidget {
  final Service service;

  ServiceScreen({required this.service});

  @override
  _ServiceScreenState createState() => _ServiceScreenState();
}

class _ServiceScreenState extends State<ServiceScreen> {
  Text _buildRatingStars(int rating) {
    String stars = '';
    for (int i = 0; i < rating; i++) {
      stars += '⭐ ';
    }
    stars.trim();
    return Text(stars);
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: Column(
        children: <Widget>[
          Stack(
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).size.height*0.4,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      offset: Offset(0.0, 2.0),
                      blurRadius: 6.0,
                    ),
                  ],
                ),
                child: Hero(
                  tag: widget.service.imgUrl,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(30.0),
                    child: Image(
                      width: screenSize.width,
                      image: AssetImage(widget.service.imgUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 40.0),
                child: Row(


                  mainAxisAlignment: MainAxisAlignment.spaceBetween,

                  children: <Widget>[
                    IconButton(
                      icon: Icon(Icons.arrow_back),
                      iconSize: 30.0,
                      color: Colors.white,

                      onPressed: () => Navigator.pop(context),
                    ),
                    Row(
                      children: <Widget>[
                        IconButton(
                          icon: Icon(Icons.search),
                          iconSize: 30.0,
                          color: Colors.white,

                          onPressed: () {},
                        ),

                      ],
                    ),
                  ],
                ),
              ),
              Positioned(
                left: 20.0,
                bottom: 20.0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      widget.service.name,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 35.0,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.2,
                      ),
                    ),
                    Row(
                      children: <Widget>[
                        Icon(
                          Icons.location_on,
                          size: 15.0,
                          color: Colors.white70,
                        ),
                        SizedBox(width: 5.0),
                        Text(
                          'Nablus',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 20.0,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

            ],
          ),
          // Expanded(
          //   child: ListView.builder(
          //     padding: EdgeInsets.only(top: 10.0, bottom: 15.0),
          //     itemCount: widget.service.workers.length,
          //     itemBuilder: (BuildContext context, int index) {
          //      Worker worker = widget.service.workers[index];
          //       return Stack(
          //         children: <Widget>[
          //           Container(
          //             margin: EdgeInsets.fromLTRB(40.0, 5.0, 20.0, 5.0),
          //             height: 170.0,
          //             width: double.infinity,
          //             decoration: BoxDecoration(
          //               color: Colors.white,
          //               borderRadius: BorderRadius.circular(20.0),
          //             ),
          //             child: Padding(
          //               padding: EdgeInsets.fromLTRB(100.0, 20.0, 20.0, 20.0),
          //               child: Column(
          //                 mainAxisAlignment: MainAxisAlignment.center,
          //                 crossAxisAlignment: CrossAxisAlignment.start,
          //                 children: <Widget>[
          //                   Row(
          //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //                     crossAxisAlignment: CrossAxisAlignment.start,
          //                     children: <Widget>[
          //                       Container(
          //                         width: 120.0,
          //                         child: Text(
          //                           worker.name,
          //                           style: TextStyle(
          //                             fontSize: 18.0,
          //                             fontWeight: FontWeight.w600,
          //                           ),
          //                           overflow: TextOverflow.ellipsis,
          //                           maxLines: 2,
          //                         ),
          //                       ),
          //                       // Column(
          //                       //   children: <Widget>[
          //                       //     Text(
          //                       //       '\$${activity.price}',
          //                       //       style: TextStyle(
          //                       //         fontSize: 22.0,
          //                       //         fontWeight: FontWeight.w600,
          //                       //       ),
          //                       //     ),
          //                       //     Text(
          //                       //       'per pax',
          //                       //       style: TextStyle(
          //                       //         color: Colors.grey,
          //                       //       ),
          //                       //     ),
          //                       //   ],
          //                       // ),
          //                     ],
          //                   ),
          //                   Text(
          //                     worker.major,
          //                     style: TextStyle(
          //                       color: Colors.grey,
          //                     ),
          //                   ),
          //                   _buildRatingStars(worker.rating),
          //                   SizedBox(height: 10.0),
          //                   // Row(
          //                   //   children: <Widget>[
          //                   //     Container(
          //                   //       padding: EdgeInsets.all(5.0),
          //                   //       width: 70.0,
          //                   //       decoration: BoxDecoration(
          //                   //         color: Theme.of(context).accentColor,
          //                   //         borderRadius: BorderRadius.circular(10.0),
          //                   //       ),
          //                   //       alignment: Alignment.center,
          //                   //       child: Text(
          //                   //         activity.startTimes[0],
          //                   //       ),
          //                   //     ),
          //                   //     SizedBox(width: 10.0),
          //                   //     Container(
          //                   //       padding: EdgeInsets.all(5.0),
          //                   //       width: 70.0,
          //                   //       decoration: BoxDecoration(
          //                   //         color: Theme.of(context).accentColor,
          //                   //         borderRadius: BorderRadius.circular(10.0),
          //                   //       ),
          //                   //       alignment: Alignment.center,
          //                   //       child: Text(
          //                   //         activity.startTimes[1],
          //                   //       ),
          //                   //     ),
          //                   //   ],
          //                   // )
          //                 ],
          //               ),
          //             ),
          //           ),
          //           Positioned(
          //             left: 20.0,
          //             top: 15.0,
          //             bottom: 15.0,
          //             child: ClipRRect(
          //               borderRadius: BorderRadius.circular(20.0),
          //               child: Image(
          //                 width: 110.0,
          //                 image: AssetImage(
          //                   worker.imageUrl,
          //                 ),
          //                 fit: BoxFit.cover,
          //               ),
          //             ),
          //           ),
          //         ],
          //       );
          //     },
          //   ),
          // ),
        ],
      ),
    );
  }
}
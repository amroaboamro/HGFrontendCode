import 'package:flutter/material.dart';
import 'package:head_gasket/user/order.dart';
import 'package:smooth_star_rating_null_safety/smooth_star_rating_null_safety.dart';
import '../Classes/Worker.dart';
// import 'hireWorkerPage.dart';

class WorkerProfilePage extends StatelessWidget {
  final Worker worker;

  const WorkerProfilePage({Key? key, required this.worker}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200.0,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                children: [
                  Positioned.fill(
                    child: Image.asset(
                      worker.imageUrl,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned.fill(
                    child: Container(
                      color: Colors.black.withOpacity(0.4),
                    ),
                  ),
                  Positioned(
                    bottom: 16.0,
                    left: 16.0,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          worker.name,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8.0),

                        Text(
                          worker.major,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18.0,
                          ),
                        ),
                        SizedBox(height: 8.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                SmoothStarRating(
                                  rating: worker.rating ?? 0.0,
                                  size: 24,
                                  filledIconData: Icons.star,
                                  halfFilledIconData: Icons.star_half,
                                  defaultIconData: Icons.star_border,
                                  starCount: 5,
                                  allowHalfRating: false,
                                  color: Colors.yellow,
                                  borderColor: Colors.grey,
                                ),
                                SizedBox(width: 8.0),
                                Text(
                                  '${worker.rating}',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            SizedBox(width: 100,),

                            Row(
                              children: [
                                Icon(
                                  Icons.location_on,
                                  size: 24,
                                  color: Colors.white,


                                ),
                                SizedBox(width: 8),
                                Text(
                                  '${worker.city}',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,


                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    SizedBox(height: 15.0),
                    Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          size: 24,
                          color: Colors.grey,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'About ${worker.name}:',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 15.0),
                    Text(
                      worker.bio,
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),

                    SizedBox(height: 20.0),
                    Text(
                      'Contact:',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8.0),
                    Row(
                      children: [
                        Icon(Icons.email),
                        SizedBox(width: 8),
                        Text(
                          worker.email,
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8.0),
                    Row(
                      children: [
                        Icon(Icons.phone),
                        SizedBox(width: 8),
                        Text(
                          worker.phone,
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20.0),

                    Text(
                      'Location:',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8.0),
                    Row(
                      children: [
                        Icon(Icons.location_on),
                        SizedBox(width: 8),
                        Text(
                          worker.city+','+worker.street,
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 50.0),
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => OrderPage(serviceType: worker.major,workerEmail: worker.email,)));
                        },
                        style: ElevatedButton.styleFrom(
                          // primary: Colors.black, backgroundColor: Colors.white,
                          elevation: 2,
                          padding: EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: BorderSide(
                              color: Colors.black,
                              width: 2,
                            ),
                          ),
                        ),
                        child: Text(
                          'Hire ${worker.firstName}',
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                    ),


                  ],
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }
}

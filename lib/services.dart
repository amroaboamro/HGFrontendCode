import 'package:flutter/material.dart';
import 'package:head_gasket/Widget/background.dart';

import 'Widget/ServicesCarousel.dart';
class Services extends StatelessWidget {
  const Services({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [IconButton(
            onPressed: (){},
            icon:Icon( Icons.search,
            color: Colors.black,),


        )],
        backgroundColor:   Colors.blueGrey.shade50,


      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(height: 20,),

             ServiceCarousel(),




            ServiceCarousel(),



            ServiceCarousel(),

        

          ]

        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:head_gasket/Widget/background.dart';
import 'package:head_gasket/Classes/service.dart';

import 'Widget/ServicesCarousel.dart';
class Services extends StatelessWidget {
  const Services({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text('Services'),
        ),
        actions: [Padding(
          padding: const EdgeInsets.all(8.0),
          child: IconButton(
              onPressed: (){},
              icon:Icon( Icons.search,
              color: Colors.white,),


          ),
        )],
        backgroundColor:  mainColor,


      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(height: 20,),

             ServiceCarousel(services: EServices,name: 'Emergency',),

            ServiceCarousel(services: MServices,name: 'Maintenance'),



        

          ]

        ),
      ),
    );
  }
}

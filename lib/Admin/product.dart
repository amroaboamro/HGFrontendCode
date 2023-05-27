import 'package:flutter/material.dart';
import 'package:head_gasket/Admin/store.dart';
import 'package:head_gasket/Widget/background.dart';

import 'AddPoduct.dart';

class ProductPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: mainColor,
          title: Text('Garagy Store'),
          bottom: TabBar(
            tabs: [
              Tab(
                text: 'Store',
              ),
              Tab(
                text: 'Products',
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
          StorePage() ,
            AddProductPage()
          ],
        ),
      ),
    );
  }
}



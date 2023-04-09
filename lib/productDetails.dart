import 'package:flutter/material.dart';
import 'package:head_gasket/Widget/background.dart';

class CookieDetail extends StatefulWidget {
  CookieDetail();

  @override
  State<CookieDetail> createState() => _CookieDetailState();
}

class _CookieDetailState extends State<CookieDetail> {
  var assetPath, cookieprice, cookiename, productDescription, price, count;
  @override
  void initState() {
    assetPath = 'assets/images/motor.jpg';
    cookiename = 'Car';
    cookieprice = 10;
    price = 10;
    count = 1;
    productDescription =
        'Cold, creamy ice cream sandwiched between delicious deluxe cookies. Pick your favorite deluxe cookies and ice cream flavor.';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Color(0xFF545D68)),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text('Pickup',
            style: TextStyle(
                fontFamily: 'Varela',
                fontSize: 20.0,
                color: Color(0xFF545D68))),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.notifications_none, color: Color(0xFF545D68)),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView(children: [
        SizedBox(height: 15.0),
        Padding(
          padding: EdgeInsets.only(left: 20.0),
          child: Text('Product',
              style: TextStyle(
                  fontFamily: 'Varela',
                  fontSize: 42.0,
                  fontWeight: FontWeight.bold,
                  color: mainColor)),
        ),
        SizedBox(height: 15.0),
        Hero(
            tag: assetPath,
            child: Image.asset(assetPath,
                height: 150.0, width: 100.0, fit: BoxFit.contain)),
        SizedBox(height: 20.0),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(
            Icons.attach_money_rounded,
            color: mainColor,
          ),
          Text(cookieprice.toString(),
              style: TextStyle(
                  fontFamily: 'Varela',
                  fontSize: 22.0,
                  fontWeight: FontWeight.bold,
                  color: mainColor)),
        ]),
        SizedBox(height: 10.0),
        Center(
          child: Text(cookiename,
              style: TextStyle(
                  color: Color(0xFF575E67),
                  fontFamily: 'Varela',
                  fontSize: 24.0)),
        ),
        SizedBox(height: 20.0),
        Center(
          child: Container(
            width: MediaQuery.of(context).size.width - 50.0,
            child: Text(productDescription,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontFamily: 'Varela',
                    fontSize: 16.0,
                    color: Color(0xFFB4B8B9))),
          ),
        ),
        SizedBox(height: 20.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FloatingActionButton(
              mini: true,
              backgroundColor: mainColor,
              onPressed: () {
                setState(() {
                  if (count > 0) {
                    cookieprice -= price;
                    count--;
                  }
                });
              },
              child: Icon(
                Icons.remove,
                color: Colors.white,
              ),
            ),
            SizedBox(
              width: 40,
            ),
            Text(count.toString(),
                style: TextStyle(
                    fontFamily: 'Varela',
                    fontSize: 22.0,
                    fontWeight: FontWeight.bold,
                    color: mainColor)),
            SizedBox(
              width: 40,
            ),
            FloatingActionButton(
              mini: true,
              backgroundColor: mainColor,
              onPressed: () {
                setState(() {
                  if (count > 0) {
                    cookieprice += price;
                    count++;
                  }
                });
              },
              child: Icon(
                Icons.add,
                color: Colors.white,
              ),
            ),
          ],
        ),
        SizedBox(height: 20.0),
        Center(
            child: Container(
                width: MediaQuery.of(context).size.width * 0.5,
                height: 50.0,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25.0),
                    color: mainColor),
                child: Center(
                    child: Text(
                  'Add to cart',
                  style: TextStyle(
                      fontFamily: 'Varela',
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ))))
      ]),
    );
  }
}

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:head_gasket/Admin/EditProduct.dart';
import 'package:head_gasket/global.dart';
import 'package:http/http.dart' as http;
import 'package:head_gasket/Widget/background.dart';

import '../Classes/Product.dart';

class CarDetailsPage extends StatefulWidget {
  final Product product;

  CarDetailsPage({required this.product});

  @override
  _CarDetailsPageState createState() => _CarDetailsPageState();
}

class _CarDetailsPageState extends State<CarDetailsPage> {
  Future<void> deleteProduct(BuildContext context) async {

    final response = await http.delete(
        Uri.parse(global.ip + '/removeProduct/${widget.product.id}'), // Replace with your API endpoint
        headers: {
          'Content-Type': 'application/json',
        }
    );
    if (response.statusCode == 200) {
      Fluttertoast.showToast(msg: 'Product deleted successfully'
          ,
          backgroundColor: Colors.blueGrey);
      Navigator.of(context).pop();
    } else {
      Fluttertoast.showToast(msg: 'Failed to delete product',
          backgroundColor: Colors.red);
    }
  }




  @override
  Widget build(BuildContext context) {
    final totalPrice = widget.product.price ;

    return Scaffold(
      backgroundColor: Colors.grey[200],

      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                Positioned.fill(
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(40),
                      bottomRight: Radius.circular(40),
                    ),
                    child: widget.product.imageUrl != ""
                        ? Image.memory(
                      base64Decode(widget.product.imageUrl),
                      fit: BoxFit.cover,
                    )
                        :  Image.asset(
                      widget.product.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          Icon(Icons.error),
                    ),
                  ),
                ),
                Positioned(
                  top: 16,
                  left: 16,
                  child: IconButton(
                    icon: Icon(
                      Icons.arrow_back_ios,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(40),
                topRight: Radius.circular(40),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,

                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.product.name,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 24.0,
                        ),
                      ),
                      Row(
                        children: [
                          ElevatedButton(
                            onPressed: () {

                              _showDeleteConfirmationDialog();
                            },
                            style: ElevatedButton.styleFrom(
                              primary: Colors.red,
                              padding: EdgeInsets.symmetric(vertical: 16.0,horizontal: 16.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16.0),
                              ),
                            ),
                            child: Text(
                              'Delete ',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15.0,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          ElevatedButton(
                            onPressed: () {

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                     EditProductPage(product: widget.product),
                                ),
                              );                          },
                            style: ElevatedButton.styleFrom(
                              primary: mainColor,
                              padding: EdgeInsets.symmetric(vertical: 16.0,horizontal: 16.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16.0),
                              ),
                            ),
                            child: Text(
                              'Edit ',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15.0,
                              ),
                            ),
                          ),

                        ],
                      ),

                    ],
                  ),
                ),
                SizedBox(height: 8.0),
                Text(
                  'In Stock: ${widget.product.quantity}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 8.0),
                Text(
                  'Price: \$${totalPrice.toString()}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                    color: mainColor,
                  ),
                ),

                SizedBox(height: 16.0),
                Text(
                  'Description:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                  ),
                ),
                SizedBox(height: 8.0),
                Text(
                  widget.product.description,
                  style: TextStyle(fontSize: 16.0),
                ),
                SizedBox(height: 16.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                  ],
                ),
                SizedBox(height: 16.0),
              ],
            ),
          ),
        ],
      ),
    );
  }
  void _showDeleteConfirmationDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Confirm Delete'),
          content: Text('Are you sure you want to delete this product?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                 deleteProduct(context);
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }



}

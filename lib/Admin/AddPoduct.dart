import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:head_gasket/global.dart';
import 'package:http/http.dart' as http;

class AddProductPage extends StatefulWidget {
  @override
  _AddProductPageState createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();

  String _selectedBrand = 'BMW';
  String _selecteType = 'Body';
  List<String> _brands = [];
  List<String> _types = [
    'Body',
    'Mechanical',
    'Electrical',
    'accessories',
    'Oils & Fluids',
  ]; // Locally defined types

  @override
  void initState() {
    super.initState();
    fetchCarBrands().then((brands) {
      print(brands);
      setState(() {
        _brands = brands;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                DropdownButtonFormField<String>(
                  value: _selectedBrand,
                  onChanged: (newValue) {
                    setState(() {
                      _selectedBrand = newValue!;
                    });
                  },
                  items: _brands.map((brand) {
                    return DropdownMenuItem<String>(
                      value: brand,
                      child: Text(brand),
                    );
                  }).toList(),
                  decoration: InputDecoration(
                    labelText: 'Brand',
                    hintText: 'Select a brand',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select a brand';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(labelText: 'Name'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter the name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.0),
                DropdownButtonFormField<String>(
                  value: _types[0],
                  onChanged: (newValue) {
                    _selecteType = newValue!;
                  },
                  items: _types.map((type) {
                    return DropdownMenuItem<String>(
                      value: type,
                      child: Text(type),
                    );
                  }).toList(),
                  decoration: InputDecoration(
                    labelText: 'Type',
                    hintText: 'Select a type',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select a type';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  controller: _priceController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: 'Price'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter the price';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  controller: _quantityController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: 'Quantity'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter the quantity';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      addProduct();
                    }
                  },
                  child: Text('Add Product'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<List<String>> fetchCarBrands() async {
    final response = await http.get(Uri.parse(global.ip + '/carMakers'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return List<String>.from(data);
    } else {
      throw Exception('Failed to fetch car brands');
    }
  }

  Future<void> addProduct() async {
    final String brand = _selectedBrand;
    final String name = _nameController.text;
    final String price = _priceController.text;
    final String quantity = _quantityController.text;

    final Map<String, dynamic> productData = {
      'brand': brand,
      'color': _selecteType,
      'name': name,
      'price': price,
      'quantity': quantity,
    };

    final response = await http.post(Uri.parse(''), body: productData);

    if (response.statusCode == 200) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Success'),
            content: Text('Product added successfully'),
            actions: [
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        },
      );

      _nameController.clear();
      _priceController.clear();
      _quantityController.clear();
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Failed to add the product'),
            actions: [
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        },
      );
    }
  }
}

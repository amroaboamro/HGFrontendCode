import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:head_gasket/Widget/background.dart';
import 'package:head_gasket/global.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'dart:async';
import 'package:path/path.dart' as Path;

import 'dart:io';

class AddProductPage extends StatefulWidget {
  @override
  _AddProductPageState createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  Uint8List webImage = Uint8List(8);
  String productImage = "";
  late File imagepicker;

  Future uploadImage(File imageFile, String id) async {
    var stream = new http.ByteStream(imageFile.openRead());
    stream.cast();
    var length = await imageFile.length();

    var uri = Uri.parse(global.ip + '/addProductImage/' + id);
    var request = new http.MultipartRequest("POST", uri);

    var multipartFile = new http.MultipartFile('upload', stream, length,
        filename: Path.basename(imageFile.path));

    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      // 'token': global.token
    };
    // request.headers["token"] = global.token;
    request.headers["Content-Type"] = 'application/json; charset=UTF-8';

    request.headers.addAll(headers);

    request.files.add(multipartFile);
    var response = await request.send();

    if (response.statusCode == 200) {
      print("Image Uploaded");
    } else {
      print("Upload Failed");
    }

    response.stream.transform(utf8.decoder).listen((value) {});
  }

  Future getImageFromGallery() async {
    XFile? image = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        imagepicker = File(image.path);
        getFileImageString(imagepicker);
      });
    } else {
      print("No file selected");
    }
  }

  String _selectedBrand = 'Skoda Octavia';
  String _selecteType = 'Body';
  List<String> _brands = [];
  List<String> _types = [
    'Body',
    'Mechanical',
    'Electrical',
    'Accessories',
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
                Container(
                  padding: EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.blueGrey.shade50,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      productImage == ""
                          ? Image.asset(
                              'assets/images/logo.png',
                              height: 200,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            )
                          : Image.memory(base64Decode(productImage)),
                      Positioned(
                        top: 0,
                        right: 0,
                        child: IconButton(
                          icon: Icon(
                            Icons.edit,
                            color: mainColor,
                          ),
                          onPressed: () {
                            getImageFromGallery();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16.0),
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
                    labelText: 'Model',
                    hintText: 'Select a Model',
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
    final response = await http.get(Uri.parse(global.ip + '/carModels'));
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
      'type': _selecteType,
      'name': name,
      'price': price,
      'quantity': quantity,
    };

    final response = await http.post(Uri.parse(global.ip + '/addProduct'),
        body: productData);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      uploadImage(imagepicker, data['id']);
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

  Future<String> getFileImageString(File file) async {
    Uint8List fileData = await file.readAsBytes();
    String base64Image = base64Encode(fileData);
    print(base64Image);
    setState(() {
      productImage = base64Image;
    });
    return "data:image/png;base64,$base64Image";
  }
}

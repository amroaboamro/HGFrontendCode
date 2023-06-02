import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:head_gasket/global.dart';
import 'package:http/http.dart' as http;

import '../Widget/background.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as Path;

class ServiceForm extends StatefulWidget {
  @override
  _ServiceFormState createState() => _ServiceFormState();
}

class _ServiceFormState extends State<ServiceForm> {
  final _formKey = GlobalKey<FormState>();
  List<String> _services = [];

  String? _serviceName;
  String? _carBrand;
  String _aboutWorker = '';
  List<String> carBrands = [];


  Future<List<String>> fetchCarBrands() async {
    final response = await http.get(Uri.parse(global.ip + '/carMakers'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return List<String>.from(data);
    } else {
      throw Exception('Failed to fetch car brands');
    }
  }
  File? _selectedImage;
  Future _getImageFromGallery() async {


    XFile? image = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (image != null) {

      setState(() {
        _selectedImage = File(image.path);

      });
    } else {
      print("No file selected");
    }

  }
  Future uploadImage(File imageFile,String id) async {

    var stream = new http.ByteStream(imageFile.openRead());
    stream.cast();
    var length = await imageFile.length();

    var uri = Uri.parse(global.ip +'/addCertificate/'+id);
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

  Future<List<String>> fetchServices() async {
    final response = await http.get(Uri.parse(global.ip + "/servicesNames"));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return List<String>.from(data);
    } else {
      throw Exception('Failed to fetch services');
    }
  }

  Future<void> _submitForm() async {
    try {
      final url = Uri.parse(global.ip + '/joinRequest');
      final response = await http.post(url, body: {
        'major': _serviceName,
        'carBrand': _carBrand,
        'bio': _aboutWorker,
        'phone': global.userData['phone'],
        'email':global.userData['email'],
        'firstName':global.userData['firstName'],
        'lastName':global.userData['lastName'],
      });
     print(response.body);
if(response.statusCode==200){

  final responseData = json.decode(response.body);
  uploadImage(_selectedImage!, responseData['id']);

  Fluttertoast.showToast(
    msg: 'your request will be reviewed soon',
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 1,
    backgroundColor: mainColor,
    textColor: Colors.white,
    fontSize: 16.0,
  );
  Navigator.of(context).pop();


}
    } catch (error) {
      Fluttertoast.showToast(
        msg: 'Failed to create service provider account',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  void initState() {
    super.initState();
    fetchServices().then((services) {
      setState(() {
        _services = services;
      });
    });
    fetchCarBrands().then((brands) {
      setState(() {
        carBrands = brands;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    TextStyle fieldLabelStyle = TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.bold,
      color: Colors.black,
    );

    TextStyle fieldDescriptionStyle = TextStyle(
      fontSize: 14,
      color: Colors.grey,
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: mainColor,
        title: Text('Join as a Service Provider'),
      ),
      body: Background(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: 10),
                  Text(
                    'As a service provider in our car maintenance app, your role is crucial in ensuring top-notch automotive services for our users. As a service provider, you\'ll be responsible for delivering expert car maintenance and repair services to our customers. This includes performing routine maintenance tasks such as oil changes, tire rotations, and filter replacements, as well as diagnosing and fixing complex mechanical and electrical issues. Your expertise and attention to detail will help our users keep their vehicles running smoothly and ensure their safety on the road. Join our platform as a service provider today and become an essential part of our car maintenance community!',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  SizedBox(height: 16),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Service Name',
                        style: fieldLabelStyle,
                      ),
                      DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          labelText: 'Service Name',
                        ),
                        value: _serviceName,
                        items: _services.map((service) {
                          return DropdownMenuItem<String>(
                            value: service,
                            child: Text(service),
                          );
                        }).toList(),
                        validator: (value) {
                          if (value == null) {
                            return 'Please select a service name';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          setState(() {
                            _serviceName = value!;
                          });
                        },
                      ),
                      Text(
                        'Select a service name',
                        style: fieldDescriptionStyle,
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Car Brand',
                        style: fieldLabelStyle,
                      ),
                      DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          labelText: 'Car Brand',
                        ),
                        value: _carBrand,
                        items: carBrands.map((carBrand) {
                          return DropdownMenuItem<String>(
                            value: carBrand,
                            child: Text(carBrand),
                          );
                        }).toList(),
                        validator: (value) {
                          if (value == null) {
                            return 'Please select a car brand';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          setState(() {
                            _carBrand = value!;
                          });
                        },
                      ),
                      Text(
                        'Select a car brand',
                        style: fieldDescriptionStyle,
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(height: 16.0),
                      _selectedImage != null
                          ? Center(child: Image.file(_selectedImage!))
                          : SizedBox.shrink(),
                      SizedBox(height: 16.0),
                      Text(
                        'Add Certificates',
                        style: fieldLabelStyle,
                      ),
                      ElevatedButton.icon(
                        onPressed: () {
                          _getImageFromGallery();

                        },
                        icon: Icon(
                         Icons.note_add,
                          color: Colors.white,
                        ),
                        label: Text(
                          'Add ',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          primary: Colors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: 20.0,
                            vertical: 10.0,
                          ),
                        ),
                      ),

                    ],
                  ),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'About You',
                        style: fieldLabelStyle,
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'About You',
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter some information about yourself';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          _aboutWorker = value;
                        },
                      ),
                      Text(
                        'Enter some information about yourself',
                        style: fieldDescriptionStyle,
                      ),
                    ],
                  ),
                  SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        if (_serviceName!.isEmpty ||
                            _carBrand!.isEmpty ||
                            _aboutWorker.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Please fill in all the fields'),
                            ),
                          );
                        } else {
                          _submitForm();
                        }
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 50.0,
                        vertical: 15.0,
                      ),
                      child: Text(
                        'Join',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: mainColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

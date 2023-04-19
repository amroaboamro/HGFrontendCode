import 'dart:io';
import 'dart:typed_data';
import '../global.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:head_gasket/Widget/background.dart';
import 'dart:convert';
//import 'dart:ffi';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io' as file;
import 'dart:async';
import 'package:path/path.dart' as Path;
import 'dart:io' as file;

import 'package:http/http.dart' as http;
import 'dart:convert';

class EditProfilePage extends StatefulWidget {
  final Map<String, dynamic> userData;

  EditProfilePage({required this.userData});

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  Future<void> updateData(Map<String, dynamic> data) async {
    var url = '';
    var headers = {'Content-Type': 'application/json'};
    var body = json.encode(data);

    try {
      var response =
          await http.post(Uri.parse(url), headers: headers, body: body);

      if (response.statusCode == 200) {
        print('Data posted successfully');
        Navigator.pop(context);
        Fluttertoast.showToast(
          msg: "Saved",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      } else {
        Fluttertoast.showToast(
          msg: "Failed to Save data",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );

        print('Failed to post data');
        print(response.statusCode);
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'Error saving data: $e',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      print('Error posting data: $e');
    }
  }

  List<String> _dropdownItems = [];

  String imageTest = "";
  late File imagepicker;
  Future Upload(File imageFile) async {
    var stream = new http.ByteStream(imageFile.openRead());
    stream.cast();
    var length = await imageFile.length();

    var uri = Uri.parse('');

    var request = new http.MultipartRequest("POST", uri);
    var multipartFile = new http.MultipartFile('upload', stream, length,
        filename: Path.basename(imageFile.path));
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      'token': global.token
    };
    request.headers["token"] = global.token;
    request.headers["Content-Type"] = 'application/json; charset=UTF-8';

    request.headers.addAll(headers);

    request.files.add(multipartFile);
    var response = await request.send();
    response.stream.transform(utf8.decoder).listen((value) {});
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => EditProfilePage(userData: widget.userData)),
    );
  }

  Future getImageFromGallery() async {
    XFile? image = await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      imagepicker = File(image!.path);

      getFileImageString(imagepicker);
      Upload(imagepicker);
    });
  }

  Future<List<String>> fetchDropdownItems() async {
    // final response = await http.get(Uri.parse('https://example.com/api/dropdown-items'));
    //
    // if (response.statusCode == 200) {
    //   final data = json.decode(response.body) as List<dynamic>;
    //   return List<String>.from(data);
    // } else {
    //   throw Exception('Failed to fetch dropdown items');
    // }
    return Future.delayed(Duration(seconds: 2), () {
      return [
        'Hyundai accent',
        'Hyundai elantra',
        'Seat leon ',
        'BMW 320i',
        'BMW m4',
        'Skoda octavia',
        'Skoda Combi',
        'Skoda superb',
        'volkswagen golf',
        'volkswagen polo',
        'volkswagen tiguan',
        'Mercedes G-class',
        'Mercedes Benz E350',
        'Mercedes E350',
        'Kia sportage',
        'kia rio',
      ];
    });
  }

  final _formKey = GlobalKey<FormState>();
  String? _firstName;
  String? _secondName;
  String? _email;
  String? _location;
  String? _phoneNumber;
  bool _isFetchCalled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mainColor,
        title: Text('Edit Profile'),
        actions: [
          IconButton(
            icon: Icon(Icons.done),
            onPressed: () {
              if (_formKey.currentState?.validate() ?? false) {
                _formKey.currentState?.save();
                if (_firstName != null) {
                  widget.userData['firstName'] = _firstName;
                }
                if (_secondName != null) {
                  widget.userData['secondName'] = _secondName;
                }
                if (_email != null) {
                  widget.userData['email'] = _email;
                }
                if (_location != null) {
                  widget.userData['location'] = _location;
                }

                if (_phoneNumber != null) {
                  widget.userData['phoneNumber'] = _phoneNumber;
                }
                updateData({
                  'firstName': _firstName,
                  'secondName': _secondName,
                  'email': _email,
                  'location': _location,
                  'phoneNumber': _phoneNumber
                });
                print(widget.userData);
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      backgroundImage: imageTest != ""
                          ? MemoryImage(base64Decode(imageTest))
                          : AssetImage('assets/images/profile.png')
                              as ImageProvider,
                      radius: 100,
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.edit,
                        size: 35.0,
                      ),
                      onPressed: () {
                        getImageFromGallery();
                      },
                    ),
                  ],
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  decoration: InputDecoration(hintText: 'First Name'),
                  initialValue: widget.userData['firstName'],
                  validator: (value) {
                    if (value?.isEmpty ?? false) {
                      return 'Please enter your first name';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _firstName = value;
                  },
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  decoration: InputDecoration(hintText: 'Second Name'),
                  initialValue: widget.userData['secondName'],
                  validator: (value) {
                    if (value?.isEmpty ?? false) {
                      return 'Please enter your second name';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _secondName = value;
                  },
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  decoration: InputDecoration(hintText: 'Email'),
                  initialValue: widget.userData['email'],
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value?.isEmpty ?? false) {
                      return 'Please enter your email';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _email = value;
                  },
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  decoration: InputDecoration(hintText: 'Location'),
                  initialValue: widget.userData['location'],
                  validator: (value) {
                    if (value?.isEmpty ?? false) {
                      return 'Please enter your location';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _location = value;
                  },
                ),
                SizedBox(height: 16.0),
                FutureBuilder<List<String>>(
                  future: _isFetchCalled ? null : fetchDropdownItems(),
                  builder: (context, snapshot) {
                    if (!_isFetchCalled) {
                      _isFetchCalled = true;
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      _dropdownItems = snapshot.data!;
                      return Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.symmetric(
                          horizontal: MediaQuery.of(context).size.width * 0.1,
                          vertical: 10,
                        ),
                        child: InputDecorator(
                          decoration: InputDecoration(
                            labelText: 'Car Model:',
                            prefixIcon: Icon(Icons.car_rental_rounded),
                            border: OutlineInputBorder(),
                          ),
                          child: DropdownButton<String>(
                            value: widget.userData['carModel'],
                            onChanged: (value) {
                              setState(() {
                                widget.userData['carModel'] = value;
                              });
                            },
                            items: _dropdownItems.map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                        ),
                      );
                    }
                  },
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  decoration: InputDecoration(hintText: 'Phone'),
                  initialValue: widget.userData['phoneNumber'],
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value?.isEmpty ?? false) {
                      return 'Please enter your phone number';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _phoneNumber = value;
                  },
                ),
                SizedBox(height: 100.0),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<String> getFileImageString(File file) async {
    Uint8List fileData = await file.readAsBytes();
    String base64Image = base64Encode(fileData);
    setState(() {
      imageTest = base64Image;
    });
    return "data:image/png;base64,$base64Image";
  }
}

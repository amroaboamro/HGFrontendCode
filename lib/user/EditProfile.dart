import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';

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
  Future<void> postData(Map<String, dynamic> data) async {
    var url = global.ip + '/userUpdate/' + global.userEmail;
    var headers = {'Content-Type': 'application/json'};
    var body = json.encode(data);

    try {
      var response =
          await http.patch(Uri.parse(url), headers: headers, body: body);
      if (response.statusCode == 200) {
        if (_firstName != null) {
          widget.userData['firstName'] = _firstName;
        }
        if (_lastName != null) {
          widget.userData['lastName'] = _lastName;
        }

        if (_carModel != null) {
          widget.userData['carModel'] = _carModel;
        }

        if (_phone != null) {
          widget.userData['phone'] = _phone;
        }
        print('Data updated successfully');
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

  Future<Map<String, dynamic>> fetchImage() async {
    final response = await http.get(Uri.parse(global.ip + "/getImage/"+global.userEmail));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      return data;
    } else {
      throw Exception('Failed to fetch image');
    }
  }

  List<String> _dropdownItems = [];

  Uint8List webImage = Uint8List(8);
  String imageTest = "";
  late File imagepicker = File('zz');

  Future Upload(File imageFile) async {
    var stream = new http.ByteStream(imageFile.openRead());
    stream.cast();
    var length = await imageFile.length();

    var uri = Uri.parse(global.ip + '/addImage/'+global.userEmail);
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
    //mobile
    if (!kIsWeb) {
      XFile? image = await ImagePicker().pickImage(source: ImageSource.gallery);

      if (image != null) {
       // var selected = File(image.path);

        setState(() {
          imagepicker = File(image.path);
          getFileImageString(imagepicker);

          Upload(imagepicker);
        });
      } else {
        print("No file selected");
      }
      // setState(() {
      //   imagepicker = File(image!.path);
      //   print('hhhttthhhh99999999999999999');
      //   print(imagepicker);

      //   getFileImageString(imagepicker);

      //   // Upload(imagepicker);
      // });
    }
    // WEB
    else if (kIsWeb) {
      XFile? image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image != null) {
        print(image);
        var f = await image.readAsBytes();
        setState(() {
          webImage = f;
          imagepicker = File(image.path);
        });
      } else {
        print("No file selected");
      }
    }
  }

  Future<List<String>> fetchDropdownItems() async {
    final response = await http.get(Uri.parse(global.ip + '/carModels'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body) as List<dynamic>;
      return List<String>.from(data);
    } else {
      throw Exception('Failed to fetch dropdown items');
    }
    // return Future.delayed(Duration(seconds: 2), () {
    //   return [
    //     'Hyundai accent',
    //     'Hyundai elantra',
    //     'Seat leon ',
    //     'BMW 320i',
    //     'BMW m4',
    //     'Skoda octavia',
    //     'Skoda Combi',
    //     'Skoda superb',
    //     'volkswagen golf',
    //     'volkswagen polo',
    //     'volkswagen tiguan',
    //     'Mercedes G-class',
    //     'Mercedes Benz E350',
    //     'Mercedes E350',
    //     'Kia sportage',
    //     'kia rio',
    //   ];
    // });
  }

  final _formKey = GlobalKey<FormState>();
  String? _firstName;
  String? _lastName;
  String? _carModel;
  String? _phone;
  bool _isFetchCalled = false;
  @override
  void initState() {
    super.initState();
    _carModel = widget.userData['carModel'];
    fetchImage().then((value){
    setState(() {
      imageTest=value['image'];

    });
    });
  }

  @override
  Widget build(BuildContext context) {
    print(imageTest);

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

                postData({
                  'firstName': _firstName,
                  'lastName': _lastName,
                  'carModel': _carModel,
                  'phone': _phone
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
                      backgroundImage: imagepicker.path == 'zz'
                          ? AssetImage('assets/images/profile.png')
                          : (kIsWeb)
                              ? MemoryImage(webImage.buffer.asUint8List())
                              : MemoryImage(base64Decode(imageTest))
                                  as ImageProvider,
                      radius: 100,
                    ),
                    // imagepicker.path == 'zz' //it means no image selected
                    //     ? Image.asset('assets/images/profile.png')
                    //     : (kIsWeb)
                    //         ? Image.memory(webImage.buffer.asUint8List())
                    //         : Image.file(imagepicker),
                    // CircleAvatar(
                    //   backgroundImage: imageTest != ""
                    //       ? MemoryImage(base64Decode(imageTest))
                    //       : AssetImage('assets/images/profile.png')
                    //           as ImageProvider,
                    //   radius: 100,
                    // ),
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
                  decoration: InputDecoration(hintText: 'last Name'),
                  initialValue: widget.userData['lastName'],
                  validator: (value) {
                    if (value?.isEmpty ?? false) {
                      return 'Please enter your last name';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _lastName = value;
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
                            value: _carModel,
                            onChanged: (value) {
                              setState(() {
                                _carModel = value;
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
                  initialValue: widget.userData['phone'],
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value?.isEmpty ?? false) {
                      return 'Please enter your phone number';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _phone = value;
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
    print(base64Image);
    setState(() {
      imageTest = base64Image;
    });
    return "data:image/png;base64,$base64Image";
  }
}

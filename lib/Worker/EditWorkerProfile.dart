import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';

import '../global.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:head_gasket/Widget/background.dart';
import 'dart:convert';

import 'package:image_picker/image_picker.dart';
import 'dart:io' as file;
import 'dart:async';
import 'package:path/path.dart' as Path;

import 'package:http/http.dart' as http;

class EditWorkerProfile extends StatefulWidget {
  final Map<String, dynamic> userData;

  EditWorkerProfile({required this.userData});

  @override
  _EditWorkerProfileState createState() => _EditWorkerProfileState();
}

class _EditWorkerProfileState extends State<EditWorkerProfile> {
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
        if (_carBrand != null) {
          widget.userData['carBrand'] = _carBrand;
        }
        if (_serviceName != null) {
          widget.userData['major'] = _serviceName;
        }

        if (_phone != null) {
          widget.userData['phone'] = _phone;
        }
        if (_aboutMe != null) {
          widget.userData['bio'] = _aboutMe;
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
    final response =
        await http.get(Uri.parse(global.ip + "/getImage/" + global.userEmail));
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

    var uri = Uri.parse(global.ip + '/addImage/' + global.userEmail);
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
        var selected = File(image.path);

        setState(() {
          imagepicker = selected;
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

  Future<List<String>> fetchServices() async {
    final response = await http.get(Uri.parse(global.ip + "/servicesNames"));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return List<String>.from(data);
    } else {
      throw Exception('Failed to fetch services');
    }
  }

  Future<List<String>> fetchDropdownItems() async {
    final response = await http.get(Uri.parse(global.ip + '/carModels'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return List<String>.from(data);
    } else {
      throw Exception('Failed to fetch dropdown items');
    }
  }

  List<String> _carBrands = [];
  Future<List<String>> fetchCarBrands() async {
    final response = await http.get(Uri.parse(global.ip + '/carMakers'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print(response.body);
      return List<String>.from(data);
    } else {
      throw Exception('Failed to fetch car brands');
    }
  }

  final _formKey = GlobalKey<FormState>();
  List<String> _services = [];

  String? _serviceName;
  String? _firstName;
  String? _lastName;
  String? _carModel;
  String? _carBrand;

  String? _phone;
  String? _aboutMe;

  @override
  void initState() {
    super.initState();
    print(_carBrand);
    fetchServices().then((services) {
      setState(() {
        _services = services;
      });
    });
    _carModel = widget.userData['carModel'];
    _carBrand = widget.userData['carBrand'];
    fetchImage().then((value) {
      setState(() {
        imageTest = value['image'];
      });
    });
    fetchCarBrands().then((brands) {
      setState(() {
        _carBrands = brands;
      });
    });
    fetchDropdownItems().then((value) {
      setState(() {
        _dropdownItems = value;
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
                  'phone': _phone,
                  'carBrand': _carBrand,
                  'major': _serviceName,
                  'bio': _aboutMe,
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
                      backgroundImage: global.Imagetest != ""
                          ? MemoryImage(base64Decode(global.Imagetest))
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
                TextFormField(
                  decoration: InputDecoration(hintText: 'About Me'),
                  initialValue: widget.userData['bio'],
                  validator: (value) {
                    if (value?.isEmpty ?? false) {
                      return 'Please enter your bio';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _aboutMe = value;
                  },
                ),
                SizedBox(height: 16.0),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: 'Major/Service Name',
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
                SizedBox(height: 16.0),
                Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.symmetric(
                          horizontal: MediaQuery.of(context).size.width * 0.1,
                          vertical: 10,
                        ),
                        child: InputDecorator(
                          decoration: InputDecoration(
                            labelText: 'My car:',
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
                      ),

                Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.1,
                    vertical: 10,
                  ),
                  child: DropdownButtonFormField(
                    value: _carBrand,
                    decoration: InputDecoration(
                      labelText: 'Car Brand:',
                      prefixIcon: Icon(Icons.car_rental_rounded),
                      border: OutlineInputBorder(),
                    ),
                    items: _carBrands.map((carBrand) {
                      return DropdownMenuItem(
                        value: carBrand,
                        child: Text(carBrand),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _carBrand = value as String?;
                      });
                    },
                  ),
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
    setState(() {
      imageTest = base64Image;
    });
    return "data:image/png;base64,$base64Image";
  }
}

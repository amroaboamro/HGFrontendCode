import 'package:flutter/material.dart';
import 'package:head_gasket/global.dart';
import 'Chat/MethodsChat.dart';
import 'Home.dart';
import 'login.dart';
import 'package:head_gasket/Widget/background.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:convert';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  String? _selectedCarType;
  var firstName, lastName, email, password, phone, carModel;
  List<String> _dropdownItems = [];
  bool _isLoading = false;
  String _errorMessage = '';

  bool _validateFields() {
    if (firstName == null || firstName!.isEmpty) {
      Fluttertoast.showToast(
        msg: 'Please enter your first name',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      return false;
    }

    if (lastName == null || lastName!.isEmpty) {
      Fluttertoast.showToast(
        msg: 'Please enter your second name',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      return false;
    }

    if (email == null || email!.isEmpty) {
      Fluttertoast.showToast(
        msg: 'Please enter your email',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      return false;
    }

    if (password == null || password!.isEmpty||password.length<8) {
      Fluttertoast.showToast(
        msg: 'Please enter at least 8 digits  password',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      return false;
    }

    if (phone == null || phone!.isEmpty) {
      Fluttertoast.showToast(
        msg: 'Please enter your phone number',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      return false;
    }

    if (carModel == null || carModel!.isEmpty) {
      Fluttertoast.showToast(
        msg: 'Please select your car model',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      return false;
    }

    return true;
  }

  Future _signUp() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final response = await http.post(
        Uri.parse(global.ip + '/signup'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'firstName': firstName,
          'lastName': lastName,
          'email': email,
          'password': password,
          'phone': phone,
          'carModel': carModel,
        }),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('success,your account has been created'),
          ),
        );

        Navigator.push(
            context, MaterialPageRoute(builder: (context) => LoginScreen()));
        return 'done';
      } else if (response.statusCode == 401) {
        setState(() {
          _errorMessage = 'Invalid Information';
        });
        return null;
      } else {
        return null;
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'An error occurred while signing up';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
    if (_errorMessage != '') {
      Fluttertoast.showToast(
        msg: _errorMessage,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }


  bool _isFetchCalled = false;

  Future<List<String>> fetchDropdownItems() async {
    final response = await http.get(Uri.parse(global.ip + '/carModels'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return List<String>.from(data);
      //return data;
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

  @override
  void initState() {
    super.initState();
fetchDropdownItems().then((value) {
  setState(() {
    _dropdownItems=value;

  });
});
    //  About = GetAbout();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Background(
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.symmetric(horizontal: size.width * 0.1),
                  child: Text(
                    "SIGN UP",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: mainColor,
                      fontSize: 35,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.symmetric(
                      horizontal: size.width * 0.1, vertical: 10),
                  child: TextField(
                    onChanged: (value) {
                      firstName = value;
                    },
                    decoration: InputDecoration(
                      labelText: "First Name",
                      prefixIcon: Icon(Icons.account_circle_outlined),
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.symmetric(
                      horizontal: size.width * 0.1, vertical: 10),
                  child: TextField(
                    onChanged: (value) {
                      lastName = value;
                    },
                    decoration: InputDecoration(
                      labelText: "Last Name",
                      prefixIcon: Icon(Icons.account_circle_outlined),
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.symmetric(
                      horizontal: size.width * 0.1, vertical: 10),
                  child: TextField(
                    onChanged: (value) {
                      email = value;
                    },
                    decoration: InputDecoration(
                      labelText: "Email",
                      prefixIcon: Icon(Icons.email_outlined),
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.symmetric(
                      horizontal: size.width * 0.1, vertical: 10),
                  child: TextField(
                    onChanged: (value) {
                      password = value;
                    },
                    decoration: InputDecoration(
                      labelText: "Password",
                      prefixIcon: Icon(Icons.vpn_key_outlined),
                    ),
                    obscureText: true,
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.symmetric(
                      horizontal: size.width * 0.1, vertical: 10),
                  child: TextField(
                    onChanged: (value) {
                      phone = value;
                    },
                    decoration: InputDecoration(
                      labelText: "Phone",
                      prefixIcon: Icon(Icons.phone),
                    ),
                  ),
                ),
                Container(
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
                            value: carModel,
                            onChanged: (value) {
                              setState(() {
                                carModel = value;
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
                  margin: EdgeInsets.fromLTRB(0, 40, 0, 10),
                  child: ElevatedButton(
                    onPressed: () {
                      if (_validateFields() && !_isLoading) {
                        _signUp().then((value) => {
                              if (value != null)
                                {
                                  createAccount(firstName + " " + lastName,
                                      email, '0597633980##Mm')
                                }
                              else
                                {print('error')}
                            });
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(80.0)),
                      padding: const EdgeInsets.all(0),
                      textStyle: TextStyle(fontWeight: FontWeight.bold),
                      elevation: 0,
                      minimumSize: Size(size.width * 0.5, 50.0),
                      animationDuration: Duration(milliseconds: 300),
                      side: BorderSide(color: Colors.white, width: 2),
                    ),
                    child: _isLoading
                        ? CircularProgressIndicator()
                        : Text(
                            'Sign Up',
                            textAlign: TextAlign.center,
                          ),
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                  child: GestureDetector(
                    onTap: () => {},
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "Already Have an Account? ",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.black,
                          ),
                        ),
                        Container(
                          child: GestureDetector(
                            child: Text(
                              "Sign in",
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: mainColor,
                              ),
                            ),
                            onTap: () => {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => LoginScreen()))
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

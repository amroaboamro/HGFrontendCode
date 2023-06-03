import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:head_gasket/ForgetPassword.dart';
import 'package:head_gasket/Home.dart';
import 'package:head_gasket/Widget/background.dart';
import 'package:head_gasket/global.dart';
import 'package:head_gasket/sign_up.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';

import 'Admin/AdminHome.dart';
//import 'Chat/MethodsChat.dart';
import 'Worker/Home.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isLoading = false;
  String _errorMessage = '';
  String _email = '';
  String _password = '';

  Future _signIn() async {
    if (_email.isEmpty || _password.isEmpty) {
      setState(() {
        _errorMessage = 'Email and password are required fields';
      });
      Fluttertoast.showToast(
        msg: _errorMessage,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final response = await http.post(
        Uri.parse(global.ip + '/signin'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'email': _email,
          'password': _password,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print(data);
        global.token = data['token'];
        if (data['role'] == 'Basic')
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => Home(userId: _email)));
        else if (data['role'] == 'worker')
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => WorkerHome(userId: _email)));
        else    Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>AdminHome()));
       // logIn(_email, '0597633980##Mm');
      } else if (response.statusCode == 401) {
        setState(() {
          _errorMessage = 'Invalid email or password';
        });
      } else {
        throw Exception('Unexpected status code: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'An error occurred while signing in';
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

  @override
  void initState() {
    super.initState();


  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Background(
        child: Form(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.symmetric(horizontal: 40),
                child: Text(
                  "SIGN IN",
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
                child: TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.account_circle_outlined),
                  ),
                  onChanged: (value) {
                    _email = value; //kamal@gmail.com
                  },
                ),
              ),
              Container(
                alignment: Alignment.center,
                margin: EdgeInsets.symmetric(
                    horizontal: size.width * 0.1, vertical: 10),
                child: TextFormField(
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    prefixIcon: Icon(Icons.vpn_key_outlined),
                  ),
                  onChanged: (value) {
                    _password = value; //123
                  },
                ),
              ),
              Container(
                alignment: Alignment.centerRight,
                margin: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                child: GestureDetector(
                  child: Text(
                    "Forgot your pasword?",
                    style: TextStyle(
                      fontSize: 12,
                      color: mainColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onTap: () => {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ForgetPassword())),
                  },
                ),
              ),
              Container(
                alignment: Alignment.center,
                margin: EdgeInsets.fromLTRB(0, 40, 0, 10),
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _signIn,
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
                      : Text('Sign In'),
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
                        "Don't Have an Account? ",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.black,
                        ),
                      ),
                      Container(
                        child: GestureDetector(
                          child: Text(
                            "Sign up",
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
                                    builder: (context) => SignUpScreen()))
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
    );
  }
}

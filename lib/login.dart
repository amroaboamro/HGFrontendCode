import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:head_gasket/ForgetPassword.dart';
import 'package:head_gasket/Home.dart';
import 'package:head_gasket/Widget/background.dart';
import 'package:head_gasket/sign_up.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isLoading = false;
  String _errorMessage = '';
  String _email = '';
  String _password = '';

  Future<void> _signIn() async {
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
        Uri.parse('http://127.0.0.1:3000/signin'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': _email,
          'password': _password,
        }),
      );

      if (response.statusCode == 200) {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => Home(userId: _email)));
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
                    _email = value;
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
                    _password = value;
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

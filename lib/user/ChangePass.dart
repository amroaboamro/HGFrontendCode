import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:convert';

import 'package:http/http.dart' as http;


class ChangePasswordPage extends StatefulWidget {
  @override
  _ChangePasswordPageState createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? _currentPassword;
  String ?_newPassword;
  String? _confirmPassword;

  String? _validatePasswords(String? newPassword, String? confirmPassword) {
    if (newPassword == null || newPassword.isEmpty) {
      return 'Please enter a new password';
    }
    if (confirmPassword == null || confirmPassword.isEmpty) {
      return 'Please confirm your new password';
    }
    if (newPassword != confirmPassword) {
      return 'Passwords do not match';
    }
    return null;
  }

  Future<void> changePassword(
      String currentPassword, String newPassword, String confirmPassword) async {
    final url = Uri.parse('');
    final headers = {'Content-Type': 'application/json'};
    final body = json.encode({
      'current_password': currentPassword,
      'new_password': newPassword,
      'confirm_password': confirmPassword,
    });

    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      return;
    } else if (response.statusCode == 400) {
      final error = json.decode(response.body)['error'];
      throw Exception('Failed to change password: $error');
    } else {
      throw Exception('Failed to change password. Status code: ${response.statusCode}');
    }
  }


  void _changePassword() async {
    if (_formKey.currentState?.validate()??false) {
      _formKey.currentState?.save();
      final error = _validatePasswords(_newPassword, _confirmPassword);
      if (error == null) {
        try {
          await changePassword(_currentPassword!, _newPassword!, _confirmPassword!);
          Fluttertoast.showToast(msg: 'Password changed successfully');
          Navigator.pop(context);
        } catch (e) {
          Fluttertoast.showToast(
            msg: e.toString(),
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0,
          );

        }

        Navigator.pop(context);
      }
      else {
        Fluttertoast.showToast(
          msg: error,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );


      }

    }
  }

  bool _isValidPassword(String value) {
    if (value == '' || value.isEmpty) {
      Fluttertoast.showToast(
        msg: 'Please enter your new password',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      return false;
    }
    if (value.length < 6) {
      Fluttertoast.showToast(
        msg: 'Password should be at least 6 characters long',
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

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        title: Text('Change Password'),
    content: SingleChildScrollView(
    child:  Container(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextFormField(
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Current Password',
                ),
                onSaved: (value) => _currentPassword = value,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your current password';
                  }
                  // Add your own validation logic here if needed
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'New Password',
                ),
                onSaved: (value) => {_newPassword = value,
                print( _newPassword!+"  from save")
                },
                validator: (value) {

                  return _isValidPassword(value!) ? null : 'Please enter a new password';
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Confirm Password',
                ),
                onSaved: (value) => _confirmPassword = value,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please confirm your new password';
                  }
                  return null;
                },
              ),
              SizedBox(height: 32.0),
              ElevatedButton(
                onPressed: _changePassword,
                child: Text('Change Password'),
              ),
            ],
          ),
        ),
      ),
    ),
    );
  }
}

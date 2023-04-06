import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'login.dart';
import 'package:head_gasket/Widget/background.dart';

final dio = Dio();
addUser(name,email, password, phone,carModel) async {
  return await dio.post('',
      data: {"name": name, "email":email,"password": password, "phone": phone,"carModel":carModel},
      options: Options(contentType: Headers.formUrlEncodedContentType));
}



class SignUpScreen extends StatefulWidget{
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  String? _selectedCarType;

  List<String> _dropdownItems = [
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

  @override
  var name,email, password, phone, carModel;
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Background(
       child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.symmetric(horizontal: size.width*0.1),
              child: Text(
                "SIGN UP",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color:mainColor,
                  fontSize: 35,

                ),
                textAlign: TextAlign.left,

              ),
            ),
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.symmetric(horizontal: size.width*0.1, vertical: 10),
              child: TextField(
                onChanged: (value){
                  name=value;
                },
                decoration: InputDecoration(
                    labelText: "Name",
                  prefixIcon:  Icon(Icons.account_circle_outlined),
                ),

              ),
            ),
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.symmetric(horizontal: size.width*0.1, vertical: 10),
              child: TextField(
                onChanged: (value){
                  email=value;
                },
                decoration: InputDecoration(
                    labelText: "Email",
                  prefixIcon: Icon(Icons.email_outlined),
                ),

              ),
            ),
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.symmetric(horizontal: size.width*0.1, vertical: 10),
              child: TextField(
                onChanged: (value){
                  password=value;
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
              margin: EdgeInsets.symmetric(horizontal: size.width*0.1, vertical: 10),

              child: TextField(
                onChanged: (value){
                  phone=value;
                },
                decoration: InputDecoration(
                  labelText: "Phone",
                  prefixIcon: Icon(Icons.phone),


                ),

              ),
            ),
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.symmetric(horizontal: size.width*0.1, vertical: 10),
              child:   InputDecorator(
                decoration: InputDecoration(
                  labelText: 'Car Model:',
                  prefixIcon: Icon(Icons.car_rental_rounded),
                  border: OutlineInputBorder(),

                ),
                child:DropdownButton<String>(
                value: _selectedCarType,
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
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(80.0)),
                  padding: const EdgeInsets.all(0),
                  textStyle: TextStyle(fontWeight: FontWeight.bold),

                  elevation: 0,
                  minimumSize: Size(size.width * 0.5, 50.0),

                  animationDuration: Duration(milliseconds: 300),
                  side: BorderSide(color: Colors.white, width: 2),
                ),
                child: Text(
                  "Sign up",
                  textAlign: TextAlign.center,
                ),
              ),
            ),

            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
              child: GestureDetector(
                onTap: () => {

                },

                child: Row(
                  mainAxisAlignment:MainAxisAlignment.center ,
                  children:<Widget> [
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
                        onTap: ()=>{
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginScreen()))
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


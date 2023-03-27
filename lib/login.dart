import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:head_gasket/ForgetPassword.dart';
import 'package:head_gasket/Widget/background.dart';
import 'package:head_gasket/sign_up.dart';
  class LoginScreen extends StatelessWidget{

    @override
    Widget build(BuildContext context){
      Size size =MediaQuery.of(context).size;
      return Scaffold(
        body: Background(
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
                  decoration: InputDecoration(
                    labelText: "Username",
                    prefixIcon:  Icon(Icons.account_circle_outlined),

                  ),

                ),

              ),
              Container(
                alignment: Alignment.center,
                margin: EdgeInsets.symmetric(horizontal: size.width*0.1, vertical: 10),
                child: TextField(


                  decoration: InputDecoration(
                      labelText: "Password",
                    prefixIcon:  Icon(Icons.vpn_key_outlined),


                  ),
                    obscureText: true,

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
                        color:mainColor,
                      fontWeight: FontWeight.bold,
                    ),

                  ),
                  onTap: ()=>{
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>ForgetPassword()))
                  },
                ),
              ),



              Container(
                alignment: Alignment.center,
                margin: EdgeInsets.fromLTRB(0, 40, 0, 10),
                child: RaisedButton(
                  onPressed: () {},
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(80.0)),
                  textColor: Colors.white,
                  padding: const EdgeInsets.all(0),
                  child: Container(
                    alignment: Alignment.center,
                    height: 50.0,
                    width: size.width * 0.5,
                    decoration: new BoxDecoration(
                        borderRadius: BorderRadius.circular(80.0),
                        gradient: new LinearGradient(
                            colors: gradientColors,
                        )
                    ),
                    padding: const EdgeInsets.all(0),
                    child: Text(
                      "Sign in",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.bold
                      ),
                    ),
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
                          onTap: ()=>{
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>SignUpScreen()))
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
      );
    }
  }
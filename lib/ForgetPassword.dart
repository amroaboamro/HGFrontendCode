import 'package:flutter/material.dart';
import 'package:head_gasket/Widget/background.dart';


class ForgetPassword extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ForgetPasswordState();
  }
}

class ForgetPasswordState extends State<ForgetPassword> {
  TextEditingController Email = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Background(
        child: SingleChildScrollView(
          child: Stack(children: [

            Center(
              child: Column(
                children: [

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Text(
                      "RESET PASSWORD",
                      style: TextStyle(
                          color: mainColor,
                          fontSize: 30,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1.5),
                    ),
                  ),
                  

                  SizedBox(
                     height: 50.0,
                   ),
                  Container(
                    padding: EdgeInsets.all(10),
                    child: Form(
                      child: Column(
                        children: [
                          Container(
                            child: TextFormField(
                              cursorColor: mainColor,
                              controller: Email,
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                      color: mainColor,
                                    )),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                      color: mainColor,
                                    )),
                                hintText: 'Email',
                                labelStyle: TextStyle(
                                  color: Colors.grey,
                                ),
                                prefixIcon: Icon(
                                  Icons.email,
                                  color: mainColor,
                                ),
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 50.0,
                          ),
                          Container(
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
                              colors: gradientColors
                          )
                      ),
                      padding: const EdgeInsets.all(0),
                      child: Text(
                        "SEND EMAIL",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                  ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ]),
        ),
      ),
    );
  }
}

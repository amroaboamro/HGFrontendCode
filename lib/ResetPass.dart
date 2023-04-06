import 'package:flutter/material.dart';
import 'package:head_gasket/Widget/background.dart';


class ResetPass extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ResetPassState();
  }
}

class ResetPassState extends State<ResetPass> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('Reset Password'),
      ),
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
                                hintText: 'New password',
                                labelStyle: TextStyle(
                                  color: Colors.grey,

                                ),
                                prefixIcon: Icon(
                                  Icons.vpn_key_rounded,
                                  color: mainColor,
                                ),
                                border: OutlineInputBorder(),
                              ),
                              obscureText: true,
                            ),
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          Container(
                            child: TextFormField(
                              cursorColor: mainColor,

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
                                hintText: ' Confirm New Password',
                                labelStyle: TextStyle(
                                  color: Colors.grey,
                                ),
                                prefixIcon: Icon(
                                  Icons.vpn_key_rounded,
                                  color: mainColor,
                                ),
                                border: OutlineInputBorder(),
                              ),
                              obscureText: true,
                            ),
                          ),
                          SizedBox(
                            height: 50.0,
                          ),
                          Container(
                            child:  ElevatedButton(
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
                                "Confirm",
                                textAlign: TextAlign.center,
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

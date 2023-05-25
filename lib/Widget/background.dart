import 'package:flutter/material.dart';
import 'bezierContainer.dart';
import 'dart:math';
final Color mainColor =Color(0XCC318383);
final gradientColors =  [
mainColor,
Colors.blueGrey,
// Color.fromARGB(107, 115, 220, 170)
];
class Background extends StatelessWidget{
  final Widget child;

  const Background({
    Key? key,
    required this.child,

}): super(key: key);


  @override
  Widget build(BuildContext context){
    Size size =MediaQuery.of(context).size;
    return Container(
      width: double.infinity,
      height: size.height,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[

          Positioned(
            top: -size.height * .15,
            right: -MediaQuery.of(context).size.width * .4,
            child: BezierContainer(
              angle: -pi/3.6,
            ),


          ),
          Positioned(
            bottom: -size.height * .15,
            left: -MediaQuery.of(context).size.width * .4,
            child: BezierContainer(
              angle: pi/1.5,
            ),

          ),

             Positioned(
               top: -55,
               right: -60,

               child: Image.asset(

                   "assets/images/logo.png",

                   width: size.width * 0.8),
             ),

child
        ],
      ),
    );

  }
}
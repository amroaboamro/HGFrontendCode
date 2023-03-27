

import 'package:flutter/material.dart';

import 'customClipper.dart';
import 'package:head_gasket/Widget/background.dart';

class BezierContainer extends StatelessWidget {
  final double angle;
  const BezierContainer(
      {
        Key ?key,
  required this.angle,
      }

      ) : super(key: key);

  @override
  Widget build(BuildContext context) {


    return Container(
        child: Transform.rotate(
          angle: angle,
          child: ClipPath(
            clipper: ClipPainter(),
            child: Container(
              height: MediaQuery.of(context).size.height *.5,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(

                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: gradientColors
                  )

              ),
            ),
          ),
        )
    );
  }
}
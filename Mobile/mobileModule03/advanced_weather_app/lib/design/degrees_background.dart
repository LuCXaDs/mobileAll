import 'package:flutter/material.dart';

class DegreesBackground {
  LinearGradient getGradientForDegrees(double degrees) {
    Color startColor;
    Color endColor;

    // if (degrees < 5) {
    //   startColor = Color(0xFF00353F);
    //   endColor = Color(0xFF08C5D1);
    // } else if (degrees < 15) {
    //   startColor = Color(0xff08C5D1);
    //   endColor = Color(0xffFFBF66);
    // } else if (degrees < 25) {
    //   startColor = Color(0xffFFBF66);
    //   endColor = Color(0xffD46F4D);
    // } else {
    //   startColor = Color(0xffD46F4D);
    //   endColor = Color(0xff430C05);
    // }

    startColor = Color.fromARGB(255, 6, 2, 36);
    endColor = Color.fromARGB(255, 13, 8, 59);

    return LinearGradient(
      colors: [startColor, endColor],
      begin: Alignment.topCenter,
      end: Alignment.centerLeft,
    );
  }
}

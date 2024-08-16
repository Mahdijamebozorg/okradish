import 'package:flutter/material.dart';

class AppColors {
  AppColors._();
  static const Color primaryColor = Color.fromARGB(255, 221, 242, 71);
  static const Color orange = Color.fromARGB(255,255,159,71);
  static const Color darkGreen = Color.fromARGB(255,38,73,64);
  static const Color green = Color.fromARGB(255,11,50,41);
  static const Color bg = Color.fromARGB(255,255,244,234);
  static const Color grey = Color.fromARGB(255,51,51,51);
  static const Color greyBack = Color.fromARGB(255,245,245,245);
  static const Color trunks = Color.fromARGB(255,140,145,151);
  static const Color error = Colors.red;
  static const Color btmNavColor = Colors.white;
  static const Color transparent = Colors.transparent;
  static const Color white = Colors.white;
  static const Color black = Colors.black;

  static const LinearGradient lineChartGrad = LinearGradient(colors: [darkGreen,transparent], begin: Alignment.topLeft, end: Alignment.bottomRight);
}
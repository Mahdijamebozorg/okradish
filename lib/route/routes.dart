import 'package:flutter/material.dart';
import 'package:okradish/route/screens.dart';
import 'package:okradish/screens/home_screen.dart';
import 'package:okradish/screens/login/login_screen.dart';
// import 'package:get/get.dart';

Map<String, Widget Function(BuildContext)> routes = {
  Screens.home: (context) => HomeScreen(),
  // Screens.spalsh: (context) => SpashScreen(),
  Screens.login: (context) => LoginScreen(),
};

// class Pages {
//   Pages._();
//   static List<GetPage<dynamic>> pages = [
//     GetPage(
//       name: Screens.home,
//       page: () => HomeScreen(),
//     ),
//   ];
// }

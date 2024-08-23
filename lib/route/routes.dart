import 'package:flutter/material.dart';
import 'package:OKRADISH/route/screens.dart';
import 'package:OKRADISH/screens/home_screen.dart';
import 'package:OKRADISH/screens/login/login_screen.dart';
import 'package:OKRADISH/screens/splash.dart';
// import 'package:get/get.dart';

Map<String, Widget Function(BuildContext)> routes = {
  Screens.home: (context) => const HomeScreen(),
  // Screens.spalsh: (context) => SpashScreen(),
  Screens.login: (context) => LoginScreen(),
  Screens.spalsh: (context) => const SplashScreen(),
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

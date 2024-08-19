import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:okradish/controllers/auth_controller.dart';
import 'package:okradish/controllers/data_controller.dart';
import 'package:okradish/gen/assets.gen.dart';
import 'package:okradish/model/daily.dart';
import 'package:okradish/model/food.dart';
import 'package:okradish/model/meal.dart';
import 'package:okradish/model/quantity.dart';
import 'package:okradish/model/user.dart';
import 'package:okradish/route/screens.dart';
import 'package:okradish/services/connetivity.dart';

Future rootDeps() async {
  await Hive.initFlutter();
  Hive.registerAdapter(UserProfileAdapter());
  Hive.registerAdapter(FoodAdapter());
  Hive.registerAdapter(FoodQuantityAdapter());
  Hive.registerAdapter(MealAdapter());
  Hive.registerAdapter(DailyEntryAdapter());

  // Listens to enternet connetion state
  Get.put(Connection());
  // Manages Userdata and login
  Get.put(AuthController());
  // Manages App data
  final dc = await DataController.instance();
  Get.put(dc);
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    rootDeps().then((_) => Get.toNamed(Screens.home));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              Assets.png.splash.path,
              fit: BoxFit.fill,
            ),
          ),
        ],
      ),
    );
  }
}

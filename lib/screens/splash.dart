import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:okradish/constants/api_keys.dart';
import 'package:okradish/controllers/auth_controller.dart';
import 'package:okradish/controllers/data_controller.dart';
import 'package:okradish/gen/assets.gen.dart';
import 'package:okradish/model/daily.dart';
import 'package:okradish/model/food.dart';
import 'package:okradish/model/meal.dart';
import 'package:okradish/model/quantity.dart';
import 'package:okradish/model/user.dart';
import 'package:okradish/route/screens.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

Future rootDeps() async {
  await Hive.initFlutter();
  Hive.registerAdapter(UserDataAdapter());
  Hive.registerAdapter(FoodAdapter());
  Hive.registerAdapter(FoodQuantityAdapter());
  Hive.registerAdapter(MealAdapter());
  Hive.registerAdapter(DailyEntryAdapter());

  await Parse().initialize(ApiKeys.applicationId, ApiKeys.parseServerUrl,
      clientKey: ApiKeys.clientKey, autoSendSessionId: true);

  // Manages Userdata and login
  final auth = Get.put(AuthController());
  await auth.tokenLogin();
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
    rootDeps().then((value) {
      if (Get.find<AuthController>().isAuth.value) {
        Get.offAndToNamed(Screens.home);
      } else {
        Get.offAndToNamed(Screens.login);
      }
    });
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

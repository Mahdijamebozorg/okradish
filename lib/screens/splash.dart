import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:OKRADISH/constants/api_keys.dart';
import 'package:OKRADISH/controllers/auth_controller.dart';
import 'package:OKRADISH/services/data_service.dart';
import 'package:OKRADISH/gen/assets.gen.dart';
import 'package:OKRADISH/model/daily.dart';
import 'package:OKRADISH/model/food.dart';
import 'package:OKRADISH/model/meal.dart';
import 'package:OKRADISH/model/quantity.dart';
import 'package:OKRADISH/model/user.dart';
import 'package:OKRADISH/route/screens.dart';
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
  final dc = await DataSevice.instance();
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

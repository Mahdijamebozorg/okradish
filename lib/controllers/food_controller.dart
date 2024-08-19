import 'package:get/get.dart';

class FoodController extends GetxController {
  var foods = <FoodController>[].obs;
  // Load foods from Hive or an API
  Future loadFoods() async {}
}
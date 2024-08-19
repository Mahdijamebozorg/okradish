import 'package:get/get.dart';
import 'package:okradish/model/meal.dart';
import 'package:okradish/model/quantity.dart';

class MealController extends GetxController {
  final Meal _meal;
  MealController.value(this._meal);
  MealController.create() : _meal = Meal.dummy();

  // ---------------------------------------------------------------
  // Local DateBase Management

  // void saveMealOnLocal() async {
  //   var box = Hive.box<Meal>('meal');
  //   await box.add(_meal);
  // }

  // Meal? loadMealFromLocal(String id) {
  //   var box = Hive.box<Meal>('meal');
  //   final boxData = boxs.toList();
  //   return boxData.firstWhere((meal) => meal.id == id);
  // }

  // ---------------------------------------------------------------
  // Cloud DateBase Management

  // ---------------------------------------------------------------
  // Cloud DateBase Management

  List<FoodQuantity> get foodItems {
    return _meal.foodItems;
  }

  String get id {
    return _meal.id;
  }

  DateTime get date {
    return _meal.date;
  }

  Meal get meal {
    return _meal;
  }

  set foodItems(List<FoodQuantity> fs) {
    _meal.foodItems = fs;
  }

  void add(FoodQuantity f) {
    _meal.foodItems.add(f);
    update(['meal']);
  }

  void addFood(food) {
    _meal.foodItems.add(food);
    update(['meal']);
  }

  void removeFood(String id) {
    _meal.foodItems.removeWhere((element) => element.food.id == id);
    update(['meal']);
  }

  void removeFoodAt(int index) {
    _meal.foodItems.removeAt(index);
    update(['meal']);
  }

  void findFood(String id) {
    _meal.foodItems.firstWhere((element) => element.food.id == id);
    update(['meal']);
  }

  double totalCarbo() {
    double cals = 0;
    for (var foodItem in _meal.foodItems) {
      cals += foodItem.carbo;
    }
    return cals;
  }

  double totalCarboCalory() {
    double cals = 0;
    for (var foodItem in _meal.foodItems) {
      cals += foodItem.carboCalory;
    }
    return cals;
  }

  double totalProtein() {
    double cals = 0;
    for (var foodItem in _meal.foodItems) {
      cals += foodItem.protein;
    }
    return cals;
  }

  double totalProteinCalory() {
    double cals = 0;
    for (var foodItem in _meal.foodItems) {
      cals += foodItem.proteinCalory;
    }
    return cals;
  }

  double totalFat() {
    double cals = 0;
    for (var foodItem in _meal.foodItems) {
      cals += foodItem.fat;
    }
    return cals;
  }

  double totalFatCalory() {
    double cals = 0;
    for (var foodItem in _meal.foodItems) {
      cals += foodItem.fatCalory;
    }
    return cals;
  }

  double totalFiber() {
    double cals = 0;
    for (var foodItem in _meal.foodItems) {
      cals += foodItem.fiber;
    }
    return cals;
  }

  double totalFiberCalory() {
    double cals = 0;
    for (var foodItem in _meal.foodItems) {
      cals += foodItem.fiberCalory;
    }
    return cals;
  }

  double totalCalories() {
    double cals = 0;
    for (var foodItem in _meal.foodItems) {
      cals += foodItem.calories;
    }
    return cals;
  }

  double totalWeight() {
    double weights = 0;
    for (var foodItem in _meal.foodItems) {
      weights += foodItem.weight;
    }
    return weights;
  }
}

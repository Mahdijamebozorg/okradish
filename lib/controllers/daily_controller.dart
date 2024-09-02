import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:OKRADISH/controllers/meal_controller.dart';
import 'package:OKRADISH/model/daily.dart';
import 'package:OKRADISH/model/meal.dart';

class DailyController extends GetxController {
  final DailyEntry _daily;
  DailyController.value(this._daily);
  DailyController.create() : _daily = DailyEntry.today();

  // ---------------------------------------------------------------
  // Local DateBase Management

  void saveMealOnLocal() async {
    var box = Hive.box<DailyEntry>('meal');
    await box.add(_daily);
  }

  // DailyEntry? loadMealFromLocal(String id) {
  //   var box = Hive.box<DailyEntry>('meal');
  //   final values = box.values.where((ent) => ent.id == id).toList();
  //   if (values.isEmpty) {
  //     return null;
  //   } else {
  //     return values[0];
  //   }
  // }

  // ---------------------------------------------------------------
  // Cloud DateBase Management

  // ---------------------------------------------------------------
  // Data

  void sortMeals() {
    this._daily.meals.sort((a, b) => a.date.compareTo(b.date));
    update(['daily']);
  }

  void add(Meal meal) {
    _daily.meals.add(meal);
    update(['daily']);
  }

  void set(List<Meal> meals) {
    _daily.meals = meals;
    update(['daily']);
  }

  void removeAt(int index) {
    _daily.meals.removeAt(index);
    update(['daily']);
  }

  void remove(Meal meal) {
    _daily.meals.remove(meal);
    update(['daily']);
  }

  void operator []=(int index, Meal meal) {
    _daily.meals[index] = meal;
    update(['daily']);
  }

  MealController mealCtrl(int index) {
    return MealController.value(meals[index]);
  }

  Meal operator [](int index) {
    return meals[index];
  }

  set meals(List<Meal> meal) {
    _daily.meals = meal;
    update(['daily']);
  }

  set meal(List<Meal> meals) {
    _daily.meals = meals;
    update(['daily']);
  }

  String get id {
    return _daily.id;
  }

  DateTime get date {
    return _daily.date;
  }

  List<Meal> get meals {
    return _daily.meals;
  }

  int get length {
    return meals.length;
  }

  List<Meal> where(bool Function(Meal) f) {
    return _daily.meals.where(f).toList();
  }

  // ----------------------------------------------------------
  // Methods to calculate nutrients

  double totalCarbo() {
    double cals = 0;
    for (var mealItem in _daily.meals) {
      final mealCtrl = MealController.value(mealItem);
      cals += mealCtrl.totalCarbo();
    }
    return cals;
  }

  double totalCarboCalory() {
    double cals = 0;
    for (var mealItem in _daily.meals) {
      final mealCtrl = MealController.value(mealItem);
      cals += mealCtrl.totalCarboCalory();
    }
    return cals;
  }

  // Method to calculate total protein for the meal
  double totalProtein() {
    double cals = 0;
    for (var mealItem in _daily.meals) {
      final mealCtrl = MealController.value(mealItem);
      cals += mealCtrl.totalProtein();
    }
    return cals;
  }

  double totalProteinCalory() {
    double cals = 0;
    for (var mealItem in _daily.meals) {
      final mealCtrl = MealController.value(mealItem);
      cals += mealCtrl.totalProteinCalory();
    }
    return cals;
  }

  // Method to calculate total fat for the meal
  double totalFat() {
    double cals = 0;
    for (var mealItem in _daily.meals) {
      final mealCtrl = MealController.value(mealItem);
      cals += mealCtrl.totalFat();
    }
    return cals;
  }

  double totalFatCalory() {
    double cals = 0;
    for (var mealItem in _daily.meals) {
      final mealCtrl = MealController.value(mealItem);
      cals += mealCtrl.totalFatCalory();
    }
    return cals;
  }

  // Method to calculate total fiber for the meal
  double totalFiber() {
    double cals = 0;
    for (var mealItem in _daily.meals) {
      final mealCtrl = MealController.value(mealItem);
      cals += mealCtrl.totalFiber();
    }
    return cals;
  }

  double totalFiberCalory() {
    double cals = 0;
    for (var mealItem in _daily.meals) {
      final mealCtrl = MealController.value(mealItem);
      cals += mealCtrl.totalFiberCalory();
    }
    return cals;
  }

  // Method to calculate total calories for the meal
  double totalCalories() {
    double cals = 0;
    for (var mealItem in _daily.meals) {
      final mealCtrl = MealController.value(mealItem);
      cals += mealCtrl.totalCalories();
    }
    return cals;
  }

  // Method to calculate total weight for the meal
  double totalWeight() {
    double weights = 0;
    for (var mealItem in _daily.meals) {
      final mealCtrl = MealController.value(mealItem);
      weights += mealCtrl.totalWeight();
    }
    return weights;
  }
}

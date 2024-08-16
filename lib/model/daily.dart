import 'package:okradish/model/meal.dart';

class DailyEntry {
  final String id;
  DateTime date;
  List<Meal> meals;
  DailyEntry({
    required this.id,
    required this.meals,
    required this.date,
  });

  factory DailyEntry.dummy() {
    return DailyEntry(id: "id", meals: [], date: DateTime.now());
  }

  // Method to calculate total carbo for the meal
  double get totalCarbo {
    double cals = 0;
    for (var mealItem in meals) {
      cals += mealItem.totalCarbo;
    }
    return cals;
  }

  double get totalCarboCalory {
    double cals = 0;
    for (var mealItem in meals) {
      cals += mealItem.totalCarboCalory;
    }
    return cals;
  }

  // Method to calculate total protein for the meal
  double get totalProtein {
    double cals = 0;
    for (var mealItem in meals) {
      cals += mealItem.totalProtein;
    }
    return cals;
  }

  double get totalProteinCalory {
    double cals = 0;
    for (var mealItem in meals) {
      cals += mealItem.totalProteinCalory;
    }
    return cals;
  }

  // Method to calculate total fat for the meal
  double get totalFat {
    double cals = 0;
    for (var mealItem in meals) {
      cals += mealItem.totalFat;
    }
    return cals;
  }

  double get totalFatCalory {
    double cals = 0;
    for (var mealItem in meals) {
      cals += mealItem.totalFatCalory;
    }
    return cals;
  }

  // Method to calculate total fiber for the meal
  double get totalFiber {
    double cals = 0;
    for (var mealItem in meals) {
      cals += mealItem.totalFiber;
    }
    return cals;
  }

  double get totalFiberCalory {
    double cals = 0;
    for (var mealItem in meals) {
      cals += mealItem.totalFiberCalory;
    }
    return cals;
  }

  // Method to calculate total calories for the meal
  double get totalCalories {
    double cals = 0;
    for (var mealItem in meals) {
      cals += mealItem.totalCalories;
    }
    return cals;
  }

  // Method to calculate total weight for the meal
  double get totalWeight {
    double weights = 0;
    for (var mealItem in meals) {
      weights += mealItem.totalWeight;
    }
    return weights;
  }
}

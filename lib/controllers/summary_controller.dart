import 'package:get/get.dart';
import 'package:okradish/constants/nutrient.dart';
import 'package:okradish/model/daily.dart';

class SummaryController extends GetxController {
  RxList<DailyEntry> entries;
  SummaryController.value(List<DailyEntry> ent) : entries = ent.obs;
  SummaryController.create() : entries = RxList();

  @override
  void onInit() {
    // load intries
    Future.delayed(const Duration(seconds: 3)).then(
      (value) {
        update(['summary']);
      },
    );
    super.onInit();
  }

  // Method to calculate total carbo for the meal
  double get totalCarbo {
    double cals = 0;
    for (var entry in entries) {
      cals += entry.totalCarbo;
    }
    return cals;
  }

  double get totalCarboCalory {
    return totalCarbo * Nutrients.carboCalory;
  }

  // Method to calculate total protein for the meal
  double get totalProtein {
    double cals = 0;
    for (var entry in entries) {
      cals += entry.totalProtein;
    }
    return cals;
  }

  double get totalProteinCalory {
    return totalProtein * Nutrients.proteinCalory;
  }

  // Method to calculate total fat for the meal
  double get totalFat {
    double cals = 0;
    for (var entry in entries) {
      cals += entry.totalFat;
    }
    return cals;
  }

  double get totalFatCalory {
    return totalFat * Nutrients.fatCalory;
  }

  // Method to calculate total fiber for the meal
  double get totalFiber {
    double cals = 0;
    for (var entry in entries) {
      cals += entry.totalFiber;
    }
    return cals;
  }

  double get totalFiberCalory {
    return totalFiber * Nutrients.fiberCalory;
  }

  // Method to calculate total calories for the meal
  double get totalCalories {
    double cals = 0;
    for (var entry in entries) {
      cals += entry.totalCalories;
    }
    return cals;
  }

  // Method to calculate total weight for the meal
  double get totalWeight {
    double weights = 0;
    for (var entry in entries) {
      weights += entry.totalWeight;
    }
    return weights;
  }
}

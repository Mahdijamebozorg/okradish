import 'package:okradish/constants/nutrient.dart';
import 'package:okradish/model/food.dart';

class FoodQuantity {
  final String id;
  Food food;
  double weight;
  FoodQuantity({
    required this.id,
    required this.food,
    required this.weight,
  });

  double get carbo {
    return food.carboPerGram * weight;
  }

  double get protein {
    return food.proteinPerGram * weight;
  }

  double get fiber {
    return food.fibersPerGram * weight;
  }

  double get fat {
    return food.fatPerGram * weight;
  }

  double get carboCalory {
    return carbo * Nutrients.carboCalory;
  }

  double get proteinCalory {
    return protein * Nutrients.proteinCalory;
  }

  double get fiberCalory {
    return fiber * Nutrients.fiberCalory;
  }

  double get fatCalory {
    return fat * Nutrients.fatCalory;
  }

  double get calories {
    return (carbo * Nutrients.carboCalory) +
        (fat * Nutrients.fatCalory) +
        (fiber * Nutrients.fiberCalory) +
        (protein * Nutrients.proteinCalory);
  }
}

class Meal {
  final String id;
  List<FoodQuantity> foodItems;
  DateTime date;
  Meal({required this.id, required this.foodItems, required this.date});

  factory Meal.dummy() {
    return Meal(
      id: "id",
      foodItems: [],
      date: DateTime.now(),
    );
  }

  double get totalCarbo {
    double cals = 0;
    for (var foodItem in foodItems) {
      cals += foodItem.carbo;
    }
    return cals;
  }

  double get totalCarboCalory {
    double cals = 0;
    for (var foodItem in foodItems) {
      cals += foodItem.carboCalory;
    }
    return cals;
  }

  double get totalProtein {
    double cals = 0;
    for (var foodItem in foodItems) {
      cals += foodItem.protein;
    }
    return cals;
  }

  double get totalProteinCalory {
    double cals = 0;
    for (var foodItem in foodItems) {
      cals += foodItem.proteinCalory;
    }
    return cals;
  }

  double get totalFat {
    double cals = 0;
    for (var foodItem in foodItems) {
      cals += foodItem.fat;
    }
    return cals;
  }

  double get totalFatCalory {
    double cals = 0;
    for (var foodItem in foodItems) {
      cals += foodItem.fatCalory;
    }
    return cals;
  }

  double get totalFiber {
    double cals = 0;
    for (var foodItem in foodItems) {
      cals += foodItem.fiber;
    }
    return cals;
  }

  double get totalFiberCalory {
    double cals = 0;
    for (var foodItem in foodItems) {
      cals += foodItem.fiberCalory;
    }
    return cals;
  }

  double get totalCalories {
    double cals = 0;
    for (var foodItem in foodItems) {
      cals += foodItem.calories;
    }
    return cals;
  }

  double get totalWeight {
    double weights = 0;
    for (var foodItem in foodItems) {
      weights += foodItem.weight;
    }
    return weights;
  }
}

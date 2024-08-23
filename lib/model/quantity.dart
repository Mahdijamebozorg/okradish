import 'package:hive/hive.dart';
import 'package:OKRADISH/constants/nutrient.dart';
import 'food.dart';

part 'quantity.g.dart';

@HiveType(typeId: 2)
class FoodQuantity {
  @HiveField(0)
  final String id;
  @HiveField(1)
  Food food;
  @HiveField(2)
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
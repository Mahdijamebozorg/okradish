// ignore_for_file: prefer_const_constructors

import 'dart:math';

import 'package:okradish/model/daily.dart';
import 'package:okradish/model/food.dart';
import 'package:okradish/model/meal.dart';

class DummyData {
  DummyData._();
  static List<Food> dummyFoods = [
    Food(
      id: 'f1',
      name: 'قرمه سبزی',
      carboPerGram: 0.10,
      fatPerGram: 0.4,
      fibersPerGram: 0.05,
      proteinPerGram: 0.2,
    ),
    Food(
      id: 'f2',
      name: 'باقالی پلو',
      carboPerGram: 0.15,
      fatPerGram: 0.3,
      fibersPerGram: 0.06,
      proteinPerGram: 0.25,
    ),
    Food(
      id: 'f3',
      name: 'زرشک پلو',
      carboPerGram: 0.12,
      fatPerGram: 0.05,
      fibersPerGram: 0.4,
      proteinPerGram: 0.22,
    ),
    Food(
      id: 'f4',
      name: 'کباب',
      carboPerGram: 0.05,
      fatPerGram: 0.25,
      fibersPerGram: 0.1,
      proteinPerGram: 0.03,
    ),
    Food(
      id: 'f5',
      name: 'آش رشته',
      carboPerGram: 0.18,
      fatPerGram: 0.2,
      fibersPerGram: 0.07,
      proteinPerGram: 0.15,
    ),
    Food(
      id: 'f6',
      name: 'دلمه',
      carboPerGram: 0.14,
      fatPerGram: 0.35,
      fibersPerGram: 0.045,
      proteinPerGram: 0.28,
    ),
    Food(
      id: 'f7',
      name: 'پلو با مرغ',
      carboPerGram: 0.17,
      fatPerGram: 0.04,
      fibersPerGram: 0.3,
      proteinPerGram: 0.27,
    ),
    Food(
      id: 'f8',
      name: 'ماهی قزل آلا',
      carboPerGram: 0.02,
      fatPerGram: 0.15,
      fibersPerGram: 0.1,
      proteinPerGram: 0.035,
    ),
    Food(
      id: 'f9',
      name: 'سالاد شیرازی',
      carboPerGram: 0.08,
      fatPerGram: 0.05,
      fibersPerGram: 0.09,
      proteinPerGram: 0.1,
    ),
    Food(
      id: 'f10',
      name: 'سیب زمینی سرخ کرده',
      carboPerGram: 0.25,
      fatPerGram: 0.06,
      fibersPerGram: 0.2,
      proteinPerGram: 0.05,
    ),
    Food(
      id: 'f11',
      name: 'خورشت قیمه',
      carboPerGram: 0.13,
      fatPerGram: 0.45,
      fibersPerGram: 0.04,
      proteinPerGram: 0.2,
    ),
  ];

  static final dummyDay = DailyEntry(
      id: "id",
      meals: List.generate(10, (index) {
        dummyFoods.shuffle();
        final foods =
            dummyFoods.getRange(0, 1 + Random().nextInt(dummyFoods.length - 2));
        return Meal(
          id: "id",
          date: DateTime.now().copyWith(hour: Random().nextInt(23)),
          foodItems: foods
              .map(
                (e) => FoodQuantity(
                  id: index.toString(),
                  food: e,
                  weight: Random(0).nextInt(100) + 1,
                ),
              )
              .toList(),
        );
      }),
      date: DateTime.now());

  static final dummyWeek = List.generate(
    7,
    (index) => DailyEntry(
      id: index.toString(),
      date: DateTime.now().copyWith(day: Random().nextInt(7)),
      meals: List.generate(Random().nextInt(20), (index) {
        dummyFoods.shuffle();
        final foods =
            dummyFoods.getRange(0, 1 + Random().nextInt(dummyFoods.length - 2));
        return Meal(
          date: DateTime.now(),
          id: index.toString(),
          foodItems: foods
              .map(
                (e) => FoodQuantity(
                  id: index.toString(),
                  food: e,
                  weight: Random(1).nextInt(100) + 1,
                ),
              )
              .toList(),
        );
      }),
    ),
  );

  static final dummyMonth = List.generate(
    30,
    (index) => DailyEntry(
      id: index.toString(),
      date: DateTime.now().copyWith(day: Random().nextInt(30)),
      meals: List.generate(Random().nextInt(20), (index) {
        dummyFoods.shuffle();
        final foods =
            dummyFoods.getRange(0, 1 + Random().nextInt(dummyFoods.length - 2));
        return Meal(
          date: DateTime.now(),
          id: index.toString(),
          foodItems: foods
              .map(
                (e) => FoodQuantity(
                  id: index.toString(),
                  food: e,
                  weight: Random(2).nextInt(100) + 1,
                ),
              )
              .toList(),
        );
      }),
    ),
  );
}

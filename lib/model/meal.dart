import 'package:hive/hive.dart';
import 'package:okradish/model/quantity.dart';
import 'package:okradish/utils/random.dart';

part 'meal.g.dart';

@HiveType(typeId: 3)
class Meal extends HiveObject {
  @HiveField(0)
  final String id;
  @HiveField(1)
  List<FoodQuantity> foodItems;
  @HiveField(2)
  DateTime date;
  Meal({required this.id, required this.foodItems, required this.date});

  factory Meal.dummy() {
    return Meal(
      id: RandomUtills().randomId(),
      foodItems: [],
      date: DateTime.now(),
    );
  }
}

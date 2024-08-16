import 'package:get/get.dart';
import 'package:okradish/model/meal.dart';

class MealController extends GetxController {
  final Rx<Meal> _meal;
  MealController.value(Meal m) : _meal = Rx(m);
  MealController.create() : _meal = Rx(Meal.dummy());

  Meal get get {
    return _meal.value;
  }

  set set(Meal meal) {
    _meal.value = meal;
    update(['meal']);
  }

  void addFood(food) {
    _meal.update((m) => m!.foodItems.add(food));
    update(['meal']);
  }

  void removeFood(food) {
    _meal.update((m) =>
        m!.foodItems.removeWhere((element) => element.food.id == food.id));
    update(['meal']);
  }
}

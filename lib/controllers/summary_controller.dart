import 'package:OKRADISH/dummy_data.dart';
import 'package:get/get.dart';
import 'package:OKRADISH/constants/nutrient.dart';
import 'package:OKRADISH/controllers/daily_controller.dart';
import 'package:OKRADISH/services/data_service.dart';
import 'package:OKRADISH/model/daily.dart';
import 'package:OKRADISH/model/meal.dart';
import 'package:OKRADISH/utils/date.dart';
import 'package:OKRADISH/utils/random.dart';

class SummaryController extends GetxController {
  List<DailyEntry> _entries;
  SummaryController.value(this._entries);
  SummaryController.create() : _entries = [];

  @override
  void onInit() {
    Get.find<DataSevice>().thisWeek.listen(
      (ents) {
        _entries = ents;
        update(['summary']);
      },
    );
    super.onInit();
  }

  // ---------------------------------------------------------------
  // Local DateBase Management

  void saveOnLocal(DailyEntry daily) async {
    return await Get.find<DataSevice>().saveOnLocal(daily);
  }

  Future<DailyEntry?> loadFromLocal(DateTime date) async {
    return await Get.find<DataSevice>().loadFromLocal(date);
  }

  Future<List<DailyEntry>> getByDate(List<DateTime> dates) async {
    var ents = <DailyEntry>[];
    for (var date in dates) {
      var ent = await loadFromLocal(date);
      ent ??= DailyEntry(id: RandomUtills().randomId(), meals: [], date: date);
      ents.add(ent);
    }

    if (ents.isEmpty) return [];

    final days = dates.map((d) => d.day).toList();
    days.sort();
    ents.sort((ent1, ent2) => ent1.date.compareTo(ent2.date));

    if (days.length == 7) {
      DateUtills.forEachDayInWeek((DateTime date) {
        if (ents.where((ent) => ent.date.day == date.day).toList().isEmpty) {
          ents.add(
            DailyEntry(
              id: RandomUtills().randomId(),
              meals: [],
              date: date,
            ),
          );
        }
      }, dates[0]);
    }

    // if month
    else if (days.length == 29 || days.length == 30 || days.length == 31) {
      DateUtills.forEachDayInMonth((DateTime date) {
        if (ents.where((ent) => ent.date.day == date.day).toList().isEmpty) {
          ents.add(
            DailyEntry(
              id: RandomUtills().randomId(),
              meals: [],
              date: date,
            ),
          );
        }
      }, dates[0], days.length);
    }
    ents.sort((ent1, ent2) => ent1.date.compareTo(ent2.date));
    return ents;
  }

  // ---------------------------------------------------------------
  // Cloud DateBase Management

  // ---------------------------------------------------------------
  //
  void addDailyEntry(DailyEntry entry) {
    _entries.add(entry);
    update(['summary']);
  }

  List<DailyEntry> get entries {
    return _entries;
  }

  set entries(List<DailyEntry> ents) {
    _entries = ents;
    update(['summary']);
  }

  Future<void> updateMeal(Meal meal) async {
    final entIndex = entries.indexWhere((ent) => ent.meals.contains(meal));
    final mealIndex =
        _entries[entIndex].meals.indexWhere((ml) => ml.id == meal.id);

    if (meal.foodItems.isEmpty) {
      _entries[entIndex].meals.removeAt(mealIndex);
    } else {
      _entries[entIndex] = entries[entIndex]..meals[mealIndex] = meal;
    }
    await Get.find<DataSevice>().saveOnLocal(_entries[entIndex]);
    update(['summary']);
  }

  List<Meal> get meals {
    List<Meal> mls = [];
    for (var ent in entries) {
      for (var ml in ent.meals) {
        mls.add(ml);
      }
    }
    return mls;
  }

  // ---------------------------------------------------------------
  // Method to calculate total carbo for the meal
  double totalCarbo() {
    double cals = 0;
    for (var ent in _entries) {
      final daily = DailyController.value(ent);
      cals += daily.totalCarbo();
    }
    return cals;
  }

  double totalCarboCalory() {
    return totalCarbo() * Nutrients.carboCalory;
  }

  // Method to calculate total protein for the meal
  double totalProtein() {
    double cals = 0;
    for (var ent in _entries) {
      final daily = DailyController.value(ent);
      cals += daily.totalProtein();
    }
    return cals;
  }

  double totalProteinCalory() {
    return totalProtein() * Nutrients.proteinCalory;
  }

  // Method to calculate total fat for the meal
  double totalFat() {
    double cals = 0;
    for (var ent in _entries) {
      final daily = DailyController.value(ent);
      cals += daily.totalFat();
    }
    return cals;
  }

  double totalFatCalory() {
    return totalFat() * Nutrients.fatCalory;
  }

  // Method to calculate total fiber for the meal
  double totalFiber() {
    double cals = 0;
    for (var ent in _entries) {
      final daily = DailyController.value(ent);
      cals += daily.totalFiber();
    }
    return cals;
  }

  double totalFiberCalory() {
    return totalFiber() * Nutrients.fiberCalory;
  }

  // Method to calculate total calories for the meal
  double totalCalories() {
    double cals = 0;
    for (var ent in _entries) {
      final daily = DailyController.value(ent);
      cals += daily.totalCalories();
    }
    return cals;
  }

  // Method to calculate total weight for the meal
  double totalWeight() {
    double weights = 0;
    for (var ent in _entries) {
      final daily = DailyController.value(ent);
      weights += daily.totalWeight();
    }
    return weights;
  }
}

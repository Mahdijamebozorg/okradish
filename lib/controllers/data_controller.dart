import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:okradish/constants/storage_keys.dart';
import 'package:okradish/controllers/daily_controller.dart';
import 'package:okradish/model/daily.dart';
import 'package:okradish/model/meal.dart';
import 'package:okradish/utils/date.dart';
import 'package:okradish/utils/random.dart';

class DataController extends GetxController {
  final RxList<DailyEntry> thisWeek;

  DataController._(List<DailyEntry> week) : thisWeek = week.obs;

  static DataController? _instance;

  static Future<DataController> _createInstance() async {
    final today = DateTime.now();
    final List<DailyEntry> week = [];
    DateUtills.weekDays(today).forEach(
      (date) async {
        // read from local
        var box = Hive.box<DailyEntry>(StorageKeys.entries);
        DailyEntry? ent;
        try {
          ent = box.values.firstWhere(
            (ent) =>
                ent.date.day == date.day &&
                ent.date.month == date.month &&
                ent.date.year == date.year,
          );
          log(
              name: "DATA",
              'date ${date.toString()} found with ${ent.meals.length} items');
        } catch (e) {
          log(name: "DATA", "date ${date.toString()} not found");
        }
        // if does not found
        ent ??=
            DailyEntry(id: RandomUtills().randomId(), meals: [], date: date);
        week.add(ent);
      },
    );
    return DataController._(week);
  }

  static Future<DataController> instance() async {
    await Hive.openBox<DailyEntry>(StorageKeys.entries);
    _instance ??= await _createInstance();
    return _instance!;
  }

  int get todayIndex {
    return thisWeek.indexWhere((ent) => ent.date.day == DateTime.now().day);
  }

  // ---------------------------------------------------------------
  // Local DateBase Management

  Future<DailyEntry?> loadFromLocal(DateTime date) async {
    log(name: "DATA", "loading ${date.toString()} from device");
    var box = Hive.box<DailyEntry>(StorageKeys.entries);
    DailyEntry? ent;
    try {
      ent = box.values.firstWhere(
        (ent) =>
            ent.date.day == date.day &&
            ent.date.month == date.month &&
            ent.date.year == date.year,
      );
    } catch (e) {
      log(name: "DATA", 'not found');
      return null;
    }
    log(name: "DATA", 'found with ${ent.meals.length} items');
    return ent;
  }

  Future<void> saveOnLocal(DailyEntry daily) async {
    // TODO: save with id to load quickly
    log(name: "DATA", "saving ${daily.date.toString()} to device");
    var box = Hive.box<DailyEntry>(StorageKeys.entries);
    await box.put(daily.id, daily);
  }

  Future<void> addMeal(Meal meal) async {
    // Load daily
    thisWeek[todayIndex] = thisWeek[todayIndex]..meals.add(meal);
    await saveOnLocal(thisWeek[todayIndex]);
    update(['data']);
  }

  Future<List<DailyEntry>> loadRange(DateTime start, DateTime end) async {
    final len = DateTimeRange(start: start, end: end).duration.inDays;
    var ents = <DailyEntry>[];
    for (var i = 0; i < len; i++) {
      final value = await loadFromLocal(start.add(const Duration(days: 1)));
      if (value != null) {
        ents.add(value);
      }
    }
    return ents;
  }

  // ---------------------------------------------------------------
  // Cloud DateBase Management

  // ---------------------------------------------------------------
  //

  List<DailyController> get entriesCtrl {
    return thisWeek.map((element) => DailyController.value(element)).toList();
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:okradish/component/button_style.dart';
import 'package:okradish/component/text_style.dart';
import 'package:okradish/constants/colors.dart';
import 'package:okradish/constants/sizes.dart';
import 'package:okradish/constants/strings.dart';
import 'package:okradish/dummy_data.dart';
import 'package:okradish/model/food.dart';
import 'package:okradish/widgets/app_card.dart';
import 'package:okradish/widgets/appbar.dart';

class ChooseFood extends StatelessWidget {
  ChooseFood({super.key});

  final Rx<Food?> selecetedFood = Rx(null);
  final RxList<List<Food>> foods = [
    DummyData.dummyFoods,
    DummyData.dummyFoods,
    DummyData.dummyFoods,
    DummyData.dummyFoods,
  ].obs;

  static const _bottomMargin = 52.0;
  final searchCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    searchCtrl.addListener(
      () {
        for (var i = 0; i < foods.length; i++) {
          foods[i] = DummyData.dummyFoods;
          foods[i] = foods[i]
              .where((food) => food.name.contains(searchCtrl.text))
              .toList();
        }
      },
    );
    final size = MediaQuery.sizeOf(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.white,
      appBar: const MyAppBar(title: Strings.chooseFood),
      body: SizedBox.expand(
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Tabbars
            Positioned(
              top: Sizes.medium,
              left: Sizes.medium,
              right: Sizes.medium,
              bottom: 2 * Sizes.smallBtnH +
                  _bottomMargin +
                  Sizes.tiny +
                  Sizes.medium,
              child: AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Search
                    Hero(
                      tag: 'search',
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Icon(Icons.search, size: 14),
                          const SizedBox(width: Sizes.tiny),
                          Expanded(
                            child: TextField(
                              controller: searchCtrl,
                              style: AppTextStyles.search,
                              decoration: const InputDecoration(
                                hintText: Strings.search,
                                hintStyle: AppTextStyles.search,
                                border: InputBorder.none,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),

                    const SizedBox(height: Sizes.tiny),

                    // Tabbars
                    Expanded(
                      child: Obx(
                        () => MyTabBar(
                          // TODO: Revice from database
                          foodList: [
                            foods[0],
                            foods[1],
                            foods[2],
                            foods[3],
                          ],
                          setFood: (Food? food) {
                            selecetedFood.value = food;
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Buttons
            Positioned(
                bottom: _bottomMargin,
                child: Column(
                  children: [
                    SizedBox(
                      height: Sizes.smallBtnH,
                      width: size.width * 0.9,
                      child: ElevatedButton(
                        style: AppButtonStyles.blackBtnStyle,
                        onPressed: () {
                          if (selecetedFood.value != null) {
                            Navigator.pop(context, selecetedFood.value);
                          }
                        },
                        child: const Text(
                          Strings.chooseFood,
                          style: AppTextStyles.blackBtn,
                        ),
                      ),
                    ),
                    const SizedBox(height: Sizes.tiny),
                    SizedBox(
                      height: Sizes.smallBtnH,
                      width: size.width * 0.9,
                      child: ElevatedButton(
                        style: AppButtonStyles.borderBtnStyle,
                        onPressed: () {
                          Navigator.pop(context, selecetedFood.value);
                        },
                        child: const Text(
                          Strings.cancel,
                          style: AppTextStyles.borderBtn,
                        ),
                      ),
                    ),
                  ],
                ))
          ],
        ),
      ),
    );
  }
}

class MyTabBar extends StatelessWidget {
  final List<List<Food>> foodList;
  final void Function(Food?) setFood;
  MyTabBar({
    required this.foodList,
    required this.setFood,
    super.key,
  });

  final RxMap<int, int> tabsState = {
    0: -1,
    1: -1,
    2: -1,
    3: -1,
  }.obs;

  void selectFood(int tab, int index) {
    for (var key in tabsState.keys) {
      if (key == tab) {
        tabsState[key] = index;
      } else {
        tabsState[key] = -1;
      }
    }
    setFood(foodList[tab][index]);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      initialIndex: 0,
      child: Column(
        children: [
          const TabBar(
            labelPadding: EdgeInsets.all(Sizes.tiny),
            tabs: [
              Text(Strings.mainMeal, style: AppTextStyles.bodyMeduim),
              Text(Strings.snack, style: AppTextStyles.bodyMeduim),
              Text(Strings.drink, style: AppTextStyles.bodyMeduim),
              Text(Strings.other, style: AppTextStyles.bodyMeduim),
            ],
          ),
          Expanded(
            child: Obx(
              () => TabBarView(
                children: [
                  FoodList(
                    key: const Key("t0"),
                    selectedIndex: tabsState[0]!,
                    foodList: foodList[0],
                    setIndex: (int index) {
                      selectFood(0, index);
                    },
                  ),
                  FoodList(
                    key: const Key("t1"),
                    selectedIndex: tabsState[1]!,
                    foodList: foodList[1],
                    setIndex: (int index) {
                      selectFood(1, index);
                    },
                  ),
                  FoodList(
                    key: const Key("t2"),
                    selectedIndex: tabsState[2]!,
                    foodList: foodList[2],
                    setIndex: (int index) {
                      selectFood(2, index);
                    },
                  ),
                  FoodList(
                    key: const Key("t3"),
                    selectedIndex: tabsState[3]!,
                    foodList: foodList[3],
                    setIndex: (int index) {
                      selectFood(3, index);
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class FoodList extends StatelessWidget {
  final List<Food> foodList;
  final void Function(int) setIndex;
  final int selectedIndex;
  const FoodList({
    required this.selectedIndex,
    required this.foodList,
    required this.setIndex,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
        color: AppColors.greyBack,
      ),
      padding: const EdgeInsets.all(Sizes.medium),
      child: ListView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount: foodList.length,
        itemExtent: Sizes.smallBtnH + Sizes.tiny,
        itemBuilder: (context, index) {
          // Decoration
          return Container(
            key: Key(foodList[index].id),
            margin: const EdgeInsets.symmetric(vertical: Sizes.tiny / 2),
            width: double.maxFinite,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(8.0)),
              color: selectedIndex == index
                  ? AppColors.orange
                  : AppColors.transparent,
            ),
            // Action
            child: TextButton(
              style: AppButtonStyles.textButton,
              onPressed: () {
                setIndex(index);
              },
              child: Text(
                foodList[index].name,
                style: AppTextStyles.bodyMeduim,
              ),
            ),
          );
        },
      ),
    );
  }
}

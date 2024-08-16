import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:okradish/constants/sizes.dart';
import 'package:okradish/gen/assets.gen.dart';
import 'package:okradish/screens/add/add_screen.dart';
import 'package:okradish/screens/profile_screen.dart';
import 'package:okradish/screens/report/report_screen.dart';
import 'package:okradish/widgets/btm_nav.dart';

enum HomeScreenIndex { add, report, profile }

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final Rx<HomeScreenIndex> _index = HomeScreenIndex.add.obs;
  void changeIndex(HomeScreenIndex index) {
    FocusManager.instance.primaryFocus!.unfocus();
    _index.value = index;
  }

  final GlobalKey<NavigatorState> _homeKey = GlobalKey();
  final GlobalKey<NavigatorState> _basketKey = GlobalKey();
  final GlobalKey<NavigatorState> _profileKey = GlobalKey();
  final GlobalKey<FormState> _profileForm = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(
          alignment: Alignment.center,
          children: [
            // background
            Positioned.fill(
              child: Image.asset(
                Assets.png.beforeAdding.path,
                fit: BoxFit.fill,
              ),
            ),
            // body
            Positioned(
              top: MediaQuery.of(context).viewPadding.top,
              right: 0,
              left: 0,
              bottom: Sizes.large + Sizes.btmNavH + Sizes.medium,
              child: Obx(
                () => IndexedStack(
                  index: _index.value.index,
                  sizing: StackFit.expand,
                  children: [
                    Navigator(
                      key: _homeKey,
                      onGenerateRoute: (settings) => MaterialPageRoute(
                          builder: (context) => const AddScreen()),
                    ),
                    Navigator(
                      key: _basketKey,
                      onGenerateRoute: (settings) => MaterialPageRoute(
                          builder: (context) => ReportScreen()),
                    ),
                    Navigator(
                      key: _profileKey,
                      onGenerateRoute: (settings) => MaterialPageRoute(
                          builder: (context) => ProfileScreen(_profileForm)),
                    ),
                  ],
                ),
              ),
            ),
            // bottom navigation bar
            Positioned(
              bottom: Sizes.medium,
              child: AppBottomNav(changeIndex: changeIndex),
            )
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:okradish/constants/sizes.dart';
import 'package:okradish/controllers/summary_controller.dart';
import 'package:okradish/gen/assets.gen.dart';
import 'package:okradish/screens/add/add_screen.dart';
import 'package:okradish/screens/profile_screen.dart';
import 'package:okradish/screens/report/report_screen.dart';
import 'package:okradish/widgets/btm_nav.dart';

enum HomeScreenIndex { profile, add, report }

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key}) {
    Get.put(SummaryController());
  }

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  HomeScreenIndex index = HomeScreenIndex.add;
  late PageController pageController;

  @override
  void initState() {
    pageController = PageController(
      initialPage: 1,
      keepPage: true,
    );
    super.initState();
  }

  void changeIndex(HomeScreenIndex index) {
    FocusManager.instance.primaryFocus!.unfocus();
    index = index;
    pageController.animateToPage(index.index,
        duration: const Duration(milliseconds: 350), curve: Curves.easeOut);
    setState(() {});
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
              child: PageView(
                allowImplicitScrolling: true,
                physics: const BouncingScrollPhysics(),
                controller: pageController,
                onPageChanged: (index) {
                  setState(() => index = index);
                },
                children: [
                  Navigator(
                    key: _profileKey,
                    onGenerateRoute: (settings) => MaterialPageRoute(
                        builder: (context) => ProfileScreen(_profileForm)),
                  ),
                  Navigator(
                    key: _homeKey,
                    onGenerateRoute: (settings) => MaterialPageRoute(
                        builder: (context) => const AddScreen()),
                  ),
                  Navigator(
                    key: _basketKey,
                    onGenerateRoute: (settings) => MaterialPageRoute(
                        builder: (context) => const ReportScreen()),
                  ),
                ],
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

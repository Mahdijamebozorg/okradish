import 'package:flutter/material.dart';
import 'package:okradish/constants/sizes.dart';
import 'package:okradish/gen/assets.gen.dart';
import 'package:okradish/screens/add/add_screen.dart';
import 'package:okradish/screens/profile_screen.dart';
import 'package:okradish/screens/report/report_screen.dart';
import 'package:okradish/widgets/btm_nav.dart';

enum HomeScreenIndex { profile, add, report }

HomeScreenIndex homeIndex = HomeScreenIndex.add;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late PageController pageController;

  @override
  void initState() {
    pageController = PageController(
      initialPage: 1,
      keepPage: true,
    );
    pageController.addListener(() {
      switch (pageController.page!.round()) {
        case 0:
          homeIndex = HomeScreenIndex.profile;
          break;
        case 1:
          homeIndex = HomeScreenIndex.add;
          break;
        case 2:
          homeIndex = HomeScreenIndex.report;
          break;
        default:
      }
    });
    super.initState();
  }

  void changeIndex(HomeScreenIndex index) {
    FocusManager.instance.primaryFocus!.unfocus();
    pageController.animateToPage(index.index,
        duration: const Duration(milliseconds: 350), curve: Curves.easeOut);
    homeIndex = index;
    setState(() {});
  }

  final GlobalKey<NavigatorState> _profileKey = GlobalKey();
  final GlobalKey<NavigatorState> _homeKey = GlobalKey();
  final GlobalKey<NavigatorState> _reportKey = GlobalKey();
  final GlobalKey<FormState> _profileForm = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: SafeArea(
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
                bottom: Sizes.large +
                    Sizes.btmNavH +
                    Sizes.medium +
                    MediaQuery.viewInsetsOf(context).bottom +
                    MediaQuery.of(context).systemGestureInsets.bottom,
                child: PageView(
                  allowImplicitScrolling: false,
                  physics: const BouncingScrollPhysics(),
                  controller: pageController,
                  onPageChanged: (homeIndex) {
                    setState(() => homeIndex = homeIndex);
                  },
                  children: [
                    Navigator(
                      key: _profileKey,
                      onGenerateRoute: (settings) => MaterialPageRoute(
                          builder: (context) => ProfileScreen(_profileForm)),
                    ),
                    Navigator(
                      key: _homeKey,
                      onGenerateRoute: (settings) =>
                          MaterialPageRoute(builder: (context) => AddScreen()),
                    ),
                    Navigator(
                      key: _reportKey,
                      onGenerateRoute: (settings) => MaterialPageRoute(
                          builder: (context) => const ReportScreen()),
                    ),
                  ],
                ),
              ),
              // bottom navigation bar
              Positioned(
                bottom: Sizes.medium +
                    MediaQuery.of(context).systemGestureInsets.bottom,
                child: AppBottomNav(changeIndex: changeIndex),
              )
            ],
          ),
        ),
      ),
    );
  }
}

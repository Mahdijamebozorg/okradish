import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:okradish/constants/colors.dart';
import 'package:okradish/constants/sizes.dart';
import 'package:okradish/gen/assets.gen.dart';
import 'package:okradish/screens/home_screen.dart';

class AppBottomNav extends StatelessWidget {
  final Function changeIndex;
  const AppBottomNav({required this.changeIndex, super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Card(
      elevation: 2,
      child: Container(
        width: size.width * 0.8,
        height: Sizes.btmNavH,
        padding: const EdgeInsets.symmetric(
          horizontal: Sizes.tiny,
          vertical: Sizes.tiny / 2,
        ),
        decoration: const BoxDecoration(
          color: AppColors.btmNavColor,
          borderRadius: BorderRadius.all(Radius.circular(12.0)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () => changeIndex(HomeScreenIndex.profile),
              child: Padding(
                padding: const EdgeInsets.all(Sizes.small),
                child: SvgPicture.asset(Assets.svg.user,
                    width: Sizes.icon, height: Sizes.icon),
              ),
            ),
            Container(
              width: 48,
              height: 56,
              padding: const EdgeInsets.only(bottom: Sizes.tiny),
              child: FloatingActionButton(
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(100)),
                ),
                elevation: 0,
                backgroundColor: AppColors.darkGreen,
                child: Image.asset(Assets.png.plus.path,
                    width: Sizes.icon, height: Sizes.icon),
                onPressed: () => changeIndex(HomeScreenIndex.add),
              ),
            ),
            GestureDetector(
              onTap: () => changeIndex(HomeScreenIndex.report),
              child: Padding(
                padding: const EdgeInsets.all(Sizes.small),
                child: SvgPicture.asset(Assets.svg.fileText,
                    width: Sizes.icon, height: Sizes.icon),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:OKRADISH/component/text_style.dart';
import 'package:OKRADISH/constants/Sizes.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  const MyAppBar({required this.title, super.key});

  @override
  Size get preferredSize => const Size(double.maxFinite, 70);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(Sizes.medium),
      child: Align(
        alignment: Alignment.centerRight,
        child: Text(title, style: AppTextStyles.pageTitle),
      ),
    );
  }
}

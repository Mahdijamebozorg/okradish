import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:okradish/component/text_style.dart';
import 'package:okradish/constants/Sizes.dart';
import 'package:okradish/constants/colors.dart';
import 'package:okradish/constants/strings.dart';

class AppTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String lable;
  final Widget icon;
  final Color color;
  final String? initalValue;
  final bool isPasword;
  final bool enabled;
  final int maxLength;
  final TextAlign textAlign;
  final TextDirection? textDirection;
  final TextInputType? inputType;
  final TextInputAction? inputAction;
  final List<TextInputFormatter> inputFormatters;
  final String? Function(String?)? validator;
  final void Function(String?)? onSaved;

  const AppTextField({
    super.key,
    required this.lable,
    required this.color,
    required this.maxLength,
    this.isPasword = false,
    this.enabled = true,
    this.icon = const SizedBox(),
    this.controller,
    this.onSaved,
    this.validator = _defaultValidator,
    this.initalValue,
    this.inputFormatters = const [],
    this.inputAction = TextInputAction.next,
    this.inputType = TextInputType.name,
    this.textDirection = TextDirection.ltr,
    this.textAlign = TextAlign.start,
  });

  static String? _defaultValidator(String? value) {
    if (value == null) {
      return ErrorTexts.emptyInput;
    } else if (value.isEmpty) {
      return ErrorTexts.emptyInput;
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Size size = MediaQuery.sizeOf(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          lable,
          style: AppTextStyles.loginTextField.copyWith(color: color),
        ),
        const SizedBox(height: Sizes.tiny),
        TextFormField(
          enabled: enabled,
          onSaved: onSaved,
          controller: controller,
          textDirection: textDirection,
          textAlign: textAlign,
          keyboardType: inputType,
          inputFormatters: inputFormatters,
          textInputAction: inputAction,
          initialValue: initalValue,
          maxLength: maxLength,
          cursorColor: color,
          obscureText: isPasword,
          cursorErrorColor: AppColors.error,
          style: AppTextStyles.loginTextField.copyWith(color: color),
          decoration: InputDecoration(
            errorStyle:
                AppTextStyles.bodySmall.copyWith(color: AppColors.error),
            iconColor: color,
            prefixIconColor: color,
            counterStyle: AppTextStyles.bodySmall.copyWith(color: color),
            border: OutlineInputBorder(
              borderRadius: const BorderRadius.all(Radius.circular(8.0)),
              borderSide: BorderSide(color: color),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: const BorderRadius.all(Radius.circular(8.0)),
              borderSide: BorderSide(color: color),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: const BorderRadius.all(Radius.circular(8.0)),
              borderSide: BorderSide(color: color),
            ),
            errorBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(8.0)),
              borderSide: BorderSide(color: AppColors.error),
            ),
            focusedErrorBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(8.0)),
              borderSide: BorderSide(color: AppColors.error),
            ),
            prefixIcon: icon,
          ),
          validator: validator,
        ),
      ],
    );
  }
}

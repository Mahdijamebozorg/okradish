import 'package:flutter/material.dart';
import 'package:OKRADISH/constants/strings.dart';
import 'package:get/get.dart';

class AppValidator {
  AppValidator._();

  static String? Function(String?)? textValidator(TextInputType inputType) {
    switch (inputType) {
      case TextInputType.phone:
        return (String? value) {
          if (value == null || value.isEmpty) {
            return null;
          } else if ((value.length != 13 && value.length != 11) ||
              value[0] != '0') {
            return ErrorTexts.invalidPhone;
          } else {
            return null;
          }
        };
      case TextInputType.name:
        return (String? value) {
          if (value == null || value.isEmpty) {
            return ErrorTexts.emptyInput;
          } else {
            return null;
          }
        };
      case TextInputType.visiblePassword:
        return (String? value) {
          if (value == null || value.isEmpty) {
            return ErrorTexts.emptyInput;
          } else if (value.length < 8) {
            return ErrorTexts.shortPwd;
          } else {
            return null;
          }
        };
      case TextInputType.emailAddress:
        return (String? value) {
          if (value == null || value.isEmpty) {
            return ErrorTexts.emptyInput;
          } else if (!value.isEmail) {
            return ErrorTexts.invalidEmail;
          } else {
            return null;
          }
        };
      default:
        return (String? value) {
          if (value == null || value.isEmpty) {
            return ErrorTexts.emptyInput;
          } else {
            return null;
          }
        };
    }
  }
}

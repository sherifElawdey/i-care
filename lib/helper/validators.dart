import 'package:icare/helper/paths/strings.dart';
import 'package:flutter/material.dart';

class Validators {
  Validators._();

  static final Validators instance = Validators._();

/*
  static String? validateEmail (String email) {
    if(email.isEmpty) return Strings.FIELD_EMPTY;
    if(!email.contains('@')&&!email.endsWith('.com')) return Strings.ENTER_VALID_EMAIL;
    return null;

  }
*/

  String? Function(String?)? validateMobileNumber(BuildContext context) {
    Pattern patternMobileNumber =
        r'^(?:[+0]9)?[0-9|٩|٠|١|٢|٣|٤|٥|٦|٧|٨]{10,15}$';
    return (value) {
      value = value?.trim();
      if (value!.isEmpty) {
        return Strings.fieldEmpty;
      } else if (value.contains("+") &&
          value.contains(RegExp(r'[0-9]|٩|٠|١|٢|٣|٤|٥|٦|٧|٨')) &&
          !value.contains(RegExp(r'[a-zA-Z]')) &&
          !value.contains(RegExp(r'[ء-ي]'))) {
        return Strings.enterValidNumber;
      } else if (!value.contains(RegExp(r'[a-zA-Z]')) &&
          value.contains(RegExp(r'[0-9]|٩|٠|١|٢|٣|٤|٥|٦|٧|٨')) &&
          !value.contains("+") &&
          !value.contains(RegExp(r'[ء-ي]'))) {
        if (!checkPattern(pattern: patternMobileNumber, value: value)) {
          return Strings.enterValidNumber;
        }
      }
      return null;
    };
  }

  String? Function(String?)? validateName(BuildContext context) {
    //english name: r'^[a-zA-Z,.\-]+$'
    //arabic name: r'^[\u0621-\u064A\040]+$'
    //english and arabic names
    String patternName = r"^[\u0621-\u064A\040\a-zA-Z,.\-]+$";
    return (value) {
      if (value!.isEmpty) {
        return Strings.fieldEmpty;
      } else if (value.toString().length < 2) {
        return Strings.enterValidName;
      } else if (!checkPattern(pattern: patternName, value: value)) {
        return Strings.enterValidName;
      } else {
        return null;
      }
    };
  }

  String? Function(String?)? validateEmail(BuildContext context) {
    String patternEmail = r"(^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$)";
    return (value) {
      if (value!.isEmpty) {
        return Strings.fieldEmpty;
      } else if (!checkPattern(pattern: patternEmail, value: value)) {
        return Strings.enterValidEmail;
      } else {
        return null;
      }
    };
  }

  String? Function(String?)? validateLoginPassword(BuildContext context) {
    return (value) {
      if (value!.isEmpty) {
        return Strings.fieldEmpty;
      } else {
        return null;
      }
    };
  }

  bool isNumeric(String str) {
    Pattern patternInteger = r'^-?[0-9]+$';
    return checkPattern(pattern: patternInteger, value: str);
  }

  bool checkPattern({pattern, value}) {
    RegExp regularCheck = RegExp(pattern);
    return regularCheck.hasMatch(value);
  }
}

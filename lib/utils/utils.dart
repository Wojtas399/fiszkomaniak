import 'package:flutter/material.dart';

class Utils {
  static void unfocusElements() {
    FocusManager.instance.primaryFocus?.unfocus();
  }

  static String twoDigits(int number) {
    return number.toString().padLeft(2, '0');
  }
}

import 'package:flutter/material.dart';

class Utils {
  static void unfocusElements() {
    FocusManager.instance.primaryFocus?.unfocus();
  }

  static String twoDigits(int number) {
    return number.toString().padLeft(2, '0');
  }

  static List<T> removeLastElement<T>(List<T> elements) {
    return elements.getRange(0, elements.length - 1).toList();
  }
}

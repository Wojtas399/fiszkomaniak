import 'package:flutter/material.dart';

class Utils {
  static void unfocusElements() {
    FocusManager.instance.primaryFocus?.unfocus();
  }
}

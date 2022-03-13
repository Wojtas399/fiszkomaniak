import 'package:flutter/material.dart';

class Utils {
  static void unfocusElements() {
    FocusManager.instance.primaryFocus?.unfocus();
  }

  static void setCursorAtTheEndOfValueInsideTextField(
    TextEditingController controller,
  ) {
    controller.selection = TextSelection.fromPosition(
      TextPosition(offset: controller.text.length),
    );
  }
}

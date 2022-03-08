import 'package:flutter/material.dart';

class TextFieldTheme {
  static InputDecoration basic({
    required BuildContext context,
    required String label,
    required IconData icon,
    String? placeholder,
    bool isPassword = false,
    bool isVisiblePassword = false,
    VoidCallback? onPressedPasswordIcon,
  }) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(
        color: Colors.black,
      ),
      hintText: placeholder,
      contentPadding: const EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 8,
      ),
      border: UnderlineInputBorder(
        borderSide: BorderSide(
          color: Colors.black.withOpacity(0.3),
        ),
      ),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(
          width: 2.0,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
      errorMaxLines: 2,
      prefixIconConstraints: const BoxConstraints(minWidth: 40),
      prefixIcon: Icon(icon),
      suffixIcon: isPassword
          ? IconButton(
              icon: Icon(
                isVisiblePassword == false
                    ? Icons.visibility
                    : Icons.visibility_off,
              ),
              onPressed: onPressedPasswordIcon,
            )
          : null,
    );
  }
}

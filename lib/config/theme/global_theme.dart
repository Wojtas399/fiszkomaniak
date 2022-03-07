import 'package:fiszkomaniak/config/theme/colors.dart';
import 'package:flutter/material.dart';

class GlobalTheme {
  static final ThemeData lightTheme = ThemeData(
    scaffoldBackgroundColor: AppColors.backgroundLight,
    colorScheme: const ColorScheme.light().copyWith(
      primary: AppColors.primary,
      secondary: AppColors.secondary,
    ),
    textSelectionTheme: _CommonStyles.textSelectionThemeData,
    elevatedButtonTheme: _CommonStyles.elevatedButtonThemeData,
  );

  static final ThemeData darkTheme = ThemeData(
    scaffoldBackgroundColor: AppColors.backgroundDark,
    colorScheme: const ColorScheme.dark().copyWith(
      primary: AppColors.primary,
      secondary: AppColors.secondary,
    ),
    textSelectionTheme: _CommonStyles.textSelectionThemeData,
    elevatedButtonTheme: _CommonStyles.elevatedButtonThemeData,
  );
}

class _CommonStyles {
  static final textSelectionThemeData =
      TextSelectionThemeData(selectionColor: AppColors.primary);

  static final elevatedButtonThemeData = ElevatedButtonThemeData(
    style: ButtonStyle(
      backgroundColor: MaterialStateProperty.all<Color>(AppColors.primary),
      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      ),
    ),
  );
}

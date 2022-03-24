import 'package:fiszkomaniak/config/theme/colors.dart';
import 'package:flutter/material.dart';

class GlobalTheme {
  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColors.backgroundLight,
    colorScheme: const ColorScheme.light().copyWith(
      primary: AppColors.primary,
      secondary: AppColors.secondary,
    ),
    textSelectionTheme: _CommonStyles.textSelectionThemeData,
    elevatedButtonTheme: _CommonStyles.elevatedButtonThemeData,
    textButtonTheme: _CommonStyles.textButtonThemeData,
    appBarTheme: _CommonStyles.appBarTheme,
    canvasColor: AppColors.secondary,
    bottomAppBarTheme: _CommonStyles.bottomAppBarTheme,
    floatingActionButtonTheme: _CommonStyles.floatingActionButtonThemeData,
  );

  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.backgroundDark,
    colorScheme: const ColorScheme.dark().copyWith(
      primary: AppColors.primary,
      secondary: AppColors.secondary,
    ),
    textSelectionTheme: _CommonStyles.textSelectionThemeData,
    elevatedButtonTheme: _CommonStyles.elevatedButtonThemeData,
    textButtonTheme: _CommonStyles.textButtonThemeData,
    appBarTheme: _CommonStyles.appBarTheme,
    canvasColor: AppColors.secondary,
    bottomAppBarTheme: _CommonStyles.bottomAppBarTheme,
    floatingActionButtonTheme: _CommonStyles.floatingActionButtonThemeData,
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

  static final textButtonThemeData = TextButtonThemeData(
    style: ButtonStyle(
      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      ),
    ),
  );

  static final appBarTheme = AppBarTheme(
    backgroundColor: AppColors.secondary,
    foregroundColor: Colors.black,
    titleTextStyle: const TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.w500,
      fontSize: 20,
      letterSpacing: 0.15,
    ),
  );

  static final bottomAppBarTheme = BottomAppBarTheme(
    color: AppColors.secondary,
    shape: const CircularNotchedRectangle(),
  );

  static final floatingActionButtonThemeData = FloatingActionButtonThemeData(
    backgroundColor: AppColors.primary,
    foregroundColor: Colors.white,
  );
}

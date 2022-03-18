import 'dart:async';
import 'package:fiszkomaniak/core/appearance_settings/appearance_settings_bloc.dart';
import 'package:fiszkomaniak/core/appearance_settings/appearance_settings_event.dart';
import 'package:fiszkomaniak/core/appearance_settings/appearance_settings_state.dart';
import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  late final AppearanceSettingsBloc _appearanceSettingsBloc;
  ThemeMode _themeMode = ThemeMode.light;
  StreamSubscription? _appearanceSettingsSubscription;

  ThemeProvider({
    required AppearanceSettingsBloc appearanceSettingsBloc,
  }) {
    _appearanceSettingsBloc = appearanceSettingsBloc;
  }

  ThemeMode get themeMode => _themeMode;

  bool get isDarkMode => themeMode == ThemeMode.dark;

  initialize() {
    Stream<AppearanceSettingsState> stream = _appearanceSettingsBloc.stream;
    _appearanceSettingsSubscription = stream.listen((state) {
      _themeMode = state.isDarkModeCompatibilityWithSystemOn
          ? ThemeMode.system
          : state.isDarkModeOn
              ? ThemeMode.dark
              : ThemeMode.light;
      notifyListeners();
    });
  }

  toggleTheme(bool isOnDarkMode) {
    _themeMode = isOnDarkMode ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
    _appearanceSettingsBloc.add(
      AppearanceSettingsEventUpdate(isDarkModeOn: isOnDarkMode),
    );
  }

  @override
  void dispose() {
    _appearanceSettingsSubscription?.cancel();
    super.dispose();
  }
}

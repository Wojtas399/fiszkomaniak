import 'package:fiszkomaniak/core/appearance_settings/appearance_settings_bloc.dart';
import 'package:fiszkomaniak/core/appearance_settings/appearance_settings_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../providers/theme_provider.dart';

class AppearanceSettingsBlocListener
    extends BlocListener<AppearanceSettingsBloc, AppearanceSettingsState> {
  AppearanceSettingsBlocListener({Key? key})
      : super(
          key: key,
          listener: (BuildContext context, AppearanceSettingsState state) {
            final ThemeProvider themeProvider = context.read<ThemeProvider>();
            if (state.isDarkModeCompatibilityWithSystemOn) {
              themeProvider.setSystemTheme();
            } else {
              themeProvider.toggleTheme(state.isDarkModeOn);
            }
          },
        );
}

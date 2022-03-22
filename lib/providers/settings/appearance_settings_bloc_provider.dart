import 'package:fiszkomaniak/core/appearance_settings/appearance_settings_bloc.dart';
import 'package:fiszkomaniak/core/appearance_settings/appearance_settings_event.dart';
import 'package:fiszkomaniak/core/appearance_settings/appearance_settings_state.dart';
import 'package:fiszkomaniak/interfaces/settings_interface.dart';
import 'package:fiszkomaniak/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppearanceSettingsBlocProvider extends StatelessWidget {
  final Widget child;

  const AppearanceSettingsBlocProvider({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AppearanceSettingsBloc(
        settingsInterface: context.read<SettingsInterface>(),
      )..add(AppearanceSettingsEventLoad()),
      child: BlocListener<AppearanceSettingsBloc, AppearanceSettingsState>(
        listener: (BuildContext context, AppearanceSettingsState state) {
          final ThemeProvider themeProvider = context.read<ThemeProvider>();
          if (state.isDarkModeCompatibilityWithSystemOn) {
            themeProvider.setSystemTheme();
          } else {
            themeProvider.toggleTheme(state.isDarkModeOn);
          }
        },
        child: child,
      ),
    );
  }
}

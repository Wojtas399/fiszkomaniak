import 'package:fiszkomaniak/core/appearance_settings/appearance_settings_bloc.dart';
import 'package:fiszkomaniak/core/appearance_settings/appearance_settings_event.dart';
import 'package:fiszkomaniak/interfaces/appearance_settings_storage_interface.dart';
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
        appearanceSettingsStorageInterface:
            context.read<AppearanceSettingsStorageInterface>(),
      )..add(AppearanceSettingsEventLoad()),
      child: child,
    );
  }
}

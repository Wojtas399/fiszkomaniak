import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/use_cases/settings/get_settings_use_case.dart';
import '../../domain/use_cases/settings/update_appearance_settings_use_case.dart';
import '../../domain/use_cases/settings/update_notifications_settings_use_case.dart';
import '../../interfaces/settings_interface.dart';
import 'bloc/settings_bloc.dart';
import 'components/settings_content.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const _SettingsBlocProvider(
      child: SettingsContent(),
    );
  }
}

class _SettingsBlocProvider extends StatelessWidget {
  final Widget child;

  const _SettingsBlocProvider({required this.child});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => SettingsBloc(
        getSettingsUseCase: GetSettingsUseCase(
          settingsInterface: context.read<SettingsInterface>(),
        ),
        updateAppearanceSettingsUseCase: UpdateAppearanceSettingsUseCase(
          settingsInterface: context.read<SettingsInterface>(),
        ),
        updateNotificationsSettingsUseCase: UpdateNotificationsSettingsUseCase(
          settingsInterface: context.read<SettingsInterface>(),
        ),
      )..add(SettingsEventInitialize()),
      child: child,
    );
  }
}

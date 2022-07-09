import 'package:fiszkomaniak/domain/use_cases/appearance_settings/get_appearance_settings_use_case.dart';
import 'package:fiszkomaniak/domain/use_cases/appearance_settings/update_appearance_settings_use_case.dart';
import 'package:fiszkomaniak/domain/use_cases/notifications_settings/get_notifications_settings_use_case.dart';
import 'package:fiszkomaniak/domain/use_cases/notifications_settings/update_notifications_settings_use_case.dart';
import 'package:fiszkomaniak/features/settings/bloc/settings_bloc.dart';
import 'package:fiszkomaniak/features/settings/components/settings_content.dart';
import 'package:fiszkomaniak/interfaces/appearance_settings_interface.dart';
import 'package:fiszkomaniak/interfaces/notifications_settings_interface.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
    final AppearanceSettingsInterface appearanceSettingsInterface =
        context.read<AppearanceSettingsInterface>();
    final NotificationsSettingsInterface notificationsSettingsInterface =
        context.read<NotificationsSettingsInterface>();
    return BlocProvider(
      create: (BuildContext context) => SettingsBloc(
        getAppearanceSettingsUseCase: GetAppearanceSettingsUseCase(
          appearanceSettingsInterface: appearanceSettingsInterface,
        ),
        getNotificationsSettingsUseCase: GetNotificationsSettingsUseCase(
          notificationsSettingsInterface: notificationsSettingsInterface,
        ),
        updateAppearanceSettingsUseCase: UpdateAppearanceSettingsUseCase(
          appearanceSettingsInterface: appearanceSettingsInterface,
        ),
        updateNotificationsSettingsUseCase: UpdateNotificationsSettingsUseCase(
          notificationsSettingsInterface: notificationsSettingsInterface,
        ),
      )..add(SettingsEventInitialize()),
      child: child,
    );
  }
}

import 'package:fiszkomaniak/components/app_bar_with_close_button.dart';
import 'package:fiszkomaniak/core/appearance_settings/appearance_settings_bloc.dart';
import 'package:fiszkomaniak/core/notifications_settings/notifications_settings_bloc.dart';
import 'package:fiszkomaniak/features/settings/bloc/settings_bloc.dart';
import 'package:fiszkomaniak/features/settings/components/settings_appearance_section.dart';
import 'package:fiszkomaniak/features/settings/components/settings_notifications_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarWithCloseButton(label: 'Ustawienia'),
      body: BlocProvider(
        create: (BuildContext context) => SettingsBloc(
          appearanceSettingsBloc: context.read<AppearanceSettingsBloc>(),
          notificationsSettingsBloc: context.read<NotificationsSettingsBloc>(),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: const [
              SettingsAppearanceSection(),
              SettingsNotificationsSection(),
            ],
          ),
        ),
      ),
    );
  }
}

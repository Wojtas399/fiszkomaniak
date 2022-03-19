import 'package:fiszkomaniak/core/notifications_settings/notifications_settings_bloc.dart';
import 'package:fiszkomaniak/core/notifications_settings/notifications_settings_event.dart';
import 'package:fiszkomaniak/injections/memory_storage_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NotificationsSettingsBlocProvider extends StatelessWidget {
  final Widget child;

  const NotificationsSettingsBlocProvider({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => NotificationsSettingsBloc(
        notificationsSettingsStorageInterface: MemoryStorageProvider
            .provideNotificationsSettingsStorageInterface(),
      )..add(NotificationsSettingsEventLoad()),
      child: child,
    );
  }
}

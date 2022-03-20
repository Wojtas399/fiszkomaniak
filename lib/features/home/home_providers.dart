import 'package:fiszkomaniak/providers/settings/appearance_settings_bloc_provider.dart';
import 'package:fiszkomaniak/providers/settings/notifications_settings_bloc_provider.dart';
import 'package:flutter/material.dart';

class HomeProviders extends StatelessWidget {
  final Widget child;

  const HomeProviders({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppearanceSettingsBlocProvider(
      child: NotificationsSettingsBlocProvider(
        child: child,
      ),
    );
  }
}

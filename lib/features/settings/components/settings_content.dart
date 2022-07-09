import 'package:fiszkomaniak/features/settings/components/settings_appearance_section.dart';
import 'package:fiszkomaniak/features/settings/components/settings_notifications_section.dart';
import 'package:flutter/material.dart';
import '../../../components/app_bar_with_close_button.dart';

class SettingsContent extends StatelessWidget {
  const SettingsContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(label: 'Ustawienia'),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: const [
            SettingsAppearanceSection(),
            SettingsNotificationsSection(),
          ],
        ),
      ),
    );
  }
}

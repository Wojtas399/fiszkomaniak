import 'package:flutter/material.dart';
import '../../../components/app_bars/app_bar_with_close_button.dart';
import 'settings_appearance_section.dart';
import 'settings_notifications_section.dart';

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

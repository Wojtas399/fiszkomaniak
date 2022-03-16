import 'package:fiszkomaniak/features/settings/components/settings_switch.dart';
import 'package:flutter/material.dart';
import '../../../components/item_with_icon.dart';

class SwitchOptionItem extends StatelessWidget {
  final String text;
  final IconData icon;
  final bool? isSwitched;
  final Function(bool isSwitched) onSwitchChanged;

  const SwitchOptionItem({
    Key? key,
    required this.text,
    required this.icon,
    required this.onSwitchChanged,
    this.isSwitched = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ItemWithIcon(
      icon: icon,
      text: text,
      trailing: SettingsSwitch(
        isSwitched: isSwitched,
        onSwitchChanged: onSwitchChanged,
      ),
    );
  }
}

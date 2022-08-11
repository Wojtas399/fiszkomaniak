import 'package:flutter/material.dart';
import '../../../components/item_with_icon.dart';
import '../../../components/switch_item.dart';

class SettingsSwitchItemWithDescription extends StatelessWidget {
  final String text;
  final IconData icon;
  final bool? isSwitched;
  final bool? disabled;
  final Function(bool isSwitched) onSwitchChanged;

  const SettingsSwitchItemWithDescription({
    super.key,
    required this.text,
    required this.icon,
    required this.onSwitchChanged,
    this.isSwitched,
    this.disabled,
  });

  @override
  Widget build(BuildContext context) {
    return ItemWithIcon(
      icon: icon,
      text: text,
      paddingRight: 0.0,
      trailing: SwitchItem(
        isSwitched: isSwitched,
        onSwitchChanged: onSwitchChanged,
        disabled: disabled,
      ),
    );
  }
}

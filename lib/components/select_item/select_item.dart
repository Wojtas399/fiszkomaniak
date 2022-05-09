import 'package:fiszkomaniak/components/select_item/options_of_select_item.dart';
import 'package:fiszkomaniak/config/slide_up_route_animation.dart';
import 'package:flutter/material.dart';

import '../item_with_icon.dart';

class SelectItem extends StatelessWidget {
  final IconData icon;
  final String? value;
  final String label;
  final String optionsListTitle;
  final Map<String, String> options;
  final Function(String key, String value) onOptionSelected;
  final String noOptionsMessage;

  const SelectItem({
    Key? key,
    required this.icon,
    required this.value,
    required this.label,
    required this.optionsListTitle,
    required this.options,
    required this.onOptionSelected,
    this.noOptionsMessage = 'Brak opcji do wyboru',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ItemWithIcon(
      icon: icon,
      label: label,
      text: value ?? '--',
      paddingRight: 8.0,
      paddingLeft: 8.0,
      onTap: () => _onTap(context),
    );
  }

  Future<void> _onTap(BuildContext context) async {
    final selectedOption = await Navigator.of(context).push(
      SlideUpRouteAnimation(
        page: OptionsOfSelectItem(
          options: options,
          title: optionsListTitle,
          noOptionsMessage: noOptionsMessage,
        ),
      ),
    );
    if (selectedOption != null) {
      String? key = selectedOption['key'];
      String? value = selectedOption['value'];
      if (key != null && value != null) {
        onOptionSelected(key, value);
      }
    }
  }
}

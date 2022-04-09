import 'package:fiszkomaniak/components/select_item/options_of_select_item.dart';
import 'package:fiszkomaniak/config/slide_left_route_animation.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

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
    return InkWell(
      onTap: () => _onTap(context),
      borderRadius: const BorderRadius.all(Radius.circular(4)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        child: Row(
          children: [
            Icon(icon),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: Theme.of(context).textTheme.caption,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value ?? '--',
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                ],
              ),
            ),
            const Icon(MdiIcons.arrowRight),
          ],
        ),
      ),
    );
  }

  Future<void> _onTap(BuildContext context) async {
    final selectedOption = await Navigator.of(context).push(
      SlideLeftRouteAnimation(
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

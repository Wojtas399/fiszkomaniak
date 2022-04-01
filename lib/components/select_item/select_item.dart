import 'package:fiszkomaniak/components/select_item/select_item_options.dart';
import 'package:fiszkomaniak/config/slide_left_route_animation.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:rxdart/rxdart.dart';

class SelectItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Map<String, String> options;
  final Function(String key, String value) onOptionSelected;
  final BehaviorSubject<String> value$ = BehaviorSubject<String>.seeded('');

  SelectItem({
    Key? key,
    required this.icon,
    required this.label,
    required this.value,
    required this.options,
    required this.onOptionSelected,
  }) : super(key: key) {
    value$.add(value);
  }

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
                  Text(label, style: Theme.of(context).textTheme.caption),
                  const SizedBox(height: 4),
                  StreamBuilder(
                    stream: value$,
                    builder: (_, AsyncSnapshot<String> snapshot) {
                      return Text(
                        snapshot.data ?? '',
                        style: Theme.of(context).textTheme.subtitle1,
                      );
                    },
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
        page: SelectItemOptions(options: options),
      ),
    );
    if (selectedOption != null) {
      String? key = selectedOption['key'];
      String? value = selectedOption['value'];
      if (key != null && value != null) {
        value$.add(value);
        onOptionSelected(key, value);
      }
    }
  }
}

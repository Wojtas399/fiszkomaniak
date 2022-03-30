import 'package:fiszkomaniak/components/select_item_options.dart';
import 'package:fiszkomaniak/config/slide_left_route_animation.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:rxdart/rxdart.dart';

class SelectItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final List<String> options;
  final Function(String value) onOptionSelected;
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
      onTap: () async {
        String? selectedOption = await Navigator.of(context).push(
          SlideLeftRouteAnimation(page: SelectItemOptions(options: options)),
        );
        if (selectedOption != null) {
          value$.add(selectedOption);
          onOptionSelected(selectedOption);
        }
      },
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
}

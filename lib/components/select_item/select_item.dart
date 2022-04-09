import 'package:fiszkomaniak/components/select_item/options_of_select_item.dart';
import 'package:fiszkomaniak/config/slide_left_route_animation.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class SelectItem extends StatefulWidget {
  final IconData icon;
  final String label;
  final String value;
  final String optionsListTitle;
  final Map<String, String> options;
  final Function(String key, String value) onOptionSelected;

  const SelectItem({
    Key? key,
    required this.icon,
    required this.label,
    required this.value,
    required this.optionsListTitle,
    required this.options,
    required this.onOptionSelected,
  }) : super(key: key);

  @override
  _SelectItemState createState() => _SelectItemState();
}

class _SelectItemState extends State<SelectItem> {
  late String value;

  @override
  void initState() {
    value = widget.value;
    super.initState();
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
            Icon(widget.icon),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.label,
                    style: Theme.of(context).textTheme.caption,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
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
          options: widget.options,
          title: widget.optionsListTitle,
        ),
      ),
    );
    if (selectedOption != null) {
      String? key = selectedOption['key'];
      String? value = selectedOption['value'];
      if (key != null && value != null) {
        setState(() {
          this.value = value;
        });
        widget.onOptionSelected(key, value);
      }
    }
  }
}

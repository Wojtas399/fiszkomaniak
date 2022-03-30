import 'package:fiszkomaniak/components/app_bar_with_close_button.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class SelectItemOptions extends StatelessWidget {
  final Map<String, String> options;

  const SelectItemOptions({Key? key, required this.options}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarWithCloseButton(
        label: 'Wybierz kurs',
        closeIcon: MdiIcons.arrowLeft,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: options.entries
                .map((option) => _OptionItem(
                      itemKey: option.key,
                      value: option.value,
                    ))
                .toList(),
          ),
        ),
      ),
    );
  }
}

class _OptionItem extends StatelessWidget {
  final String itemKey;
  final String value;

  const _OptionItem({
    Key? key,
    required this.itemKey,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: InkWell(
        borderRadius: const BorderRadius.all(Radius.circular(4)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            value,
            style: Theme.of(context).textTheme.subtitle1,
          ),
        ),
        onTap: () {
          Navigator.of(context).pop({
            'key': itemKey,
            'value': value,
          });
        },
      ),
    );
  }
}

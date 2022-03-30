import 'package:fiszkomaniak/components/app_bar_with_close_button.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class SelectItemOptions extends StatelessWidget {
  final List<String> options;

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
            children:
                options.map((option) => _OptionItem(text: option)).toList(),
          ),
        ),
      ),
    );
  }
}

class _OptionItem extends StatelessWidget {
  final String text;

  const _OptionItem({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: InkWell(
        borderRadius: const BorderRadius.all(Radius.circular(4)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            text,
            style: Theme.of(context).textTheme.subtitle1,
          ),
        ),
        onTap: () {
          Navigator.of(context).pop(text);
        },
      ),
    );
  }
}

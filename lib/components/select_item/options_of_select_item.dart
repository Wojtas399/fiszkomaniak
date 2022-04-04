import 'package:fiszkomaniak/components/app_bar_with_close_button.dart';
import 'package:fiszkomaniak/components/empty_content_info.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class OptionsOfSelectItem extends StatelessWidget {
  final Map<String, String> options;

  const OptionsOfSelectItem({
    Key? key,
    required this.options,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarWithCloseButton(
        label: 'Wybierz kurs',
        closeIcon: MdiIcons.arrowLeft,
      ),
      body: options.isEmpty
          ? const _NoOptionsInfo()
          : SingleChildScrollView(
              child: SafeArea(
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

class _NoOptionsInfo extends StatelessWidget {
  const _NoOptionsInfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: double.infinity,
      child: EmptyContentInfo(subtitle: 'Brak opcji do wyboru'),
    );
  }
}

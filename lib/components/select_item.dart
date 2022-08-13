import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../config/slide_up_route_animation.dart';
import 'app_bar_with_close_button.dart';
import 'empty_content_info.dart';
import 'item_with_icon.dart';

class SelectItem extends StatelessWidget {
  final IconData icon;
  final String? value;
  final String label;
  final String optionsListTitle;
  final Map<String, String> options;
  final Function(String key, String value) onOptionSelected;
  final String noOptionsMessage;

  const SelectItem({
    super.key,
    required this.icon,
    required this.value,
    required this.label,
    required this.optionsListTitle,
    required this.options,
    required this.onOptionSelected,
    this.noOptionsMessage = 'Brak opcji do wyboru',
  });

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
        page: _Options(
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

class _Options extends StatelessWidget {
  final String title;
  final Map<String, String> options;
  final String noOptionsMessage;

  const _Options({
    required this.title,
    required this.options,
    required this.noOptionsMessage,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        label: title,
        leadingIcon: MdiIcons.close,
      ),
      body: options.isEmpty
          ? _NoOptionsInfo(noOptionsMessage: noOptionsMessage)
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
    required this.itemKey,
    required this.value,
  });

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
  final String noOptionsMessage;

  const _NoOptionsInfo({required this.noOptionsMessage});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: EmptyContentInfo(subtitle: noOptionsMessage),
        ),
      ),
    );
  }
}

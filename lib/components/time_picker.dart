import 'package:flutter/material.dart';
import 'item_with_icon.dart';

class TimePicker extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final String? helpText;
  final TimeOfDay? initialTime;
  final double? paddingLeft;
  final double? paddingRight;
  final double? paddingTop;
  final double? paddingBottom;
  final Function(TimeOfDay time)? onSelect;

  const TimePicker({
    Key? key,
    required this.icon,
    required this.label,
    required this.value,
    this.helpText,
    this.initialTime,
    this.paddingLeft,
    this.paddingRight,
    this.paddingTop,
    this.paddingBottom,
    this.onSelect,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ItemWithIcon(
      icon: icon,
      label: label,
      text: value,
      paddingLeft: paddingLeft,
      paddingRight: paddingRight,
      paddingTop: paddingTop,
      paddingBottom: paddingBottom,
      onTap: onSelect != null
          ? () async {
              final TimeOfDay? time = await showTimePicker(
                context: context,
                initialTime: initialTime ?? TimeOfDay.now(),
                cancelText: 'ANULUJ',
                confirmText: 'WYBIERZ',
                helpText: helpText,
                builder: (BuildContext context, Widget? child) {
                  return MediaQuery(
                    data: MediaQuery.of(context).copyWith(
                      alwaysUse24HourFormat: true,
                    ),
                    child: child!,
                  );
                },
              );
              if (time != null) {
                onSelect!(time);
              }
            }
          : null,
    );
  }
}

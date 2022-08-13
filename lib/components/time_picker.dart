import 'package:flutter/material.dart';
import '../models/time_model.dart';
import 'item_with_icon.dart';

class TimePicker extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final String? helpText;
  final Time? initialTime;
  final double? paddingLeft;
  final double? paddingRight;
  final double? paddingTop;
  final double? paddingBottom;
  final Function(Time time)? onSelect;

  const TimePicker({
    super.key,
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
  });

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
              await _selectTime(context);
            }
          : null,
    );
  }

  TimeOfDay _getInitialTime() {
    final Time? initialTime = this.initialTime;
    if (initialTime != null) {
      return TimeOfDay(hour: initialTime.hour, minute: initialTime.minute);
    }
    return TimeOfDay.now();
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? time = await showTimePicker(
      context: context,
      initialTime: _getInitialTime(),
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
      onSelect!(Time(hour: time.hour, minute: time.minute));
    }
  }
}

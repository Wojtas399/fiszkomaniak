import 'package:flutter/material.dart';

String convertTimeToViewFormat(TimeOfDay? time) {
  if (time == null) {
    return '--';
  }
  final String hours = _convertNumberToTimeStr(time.hour);
  final String minutes = _convertNumberToTimeStr(time.minute);
  return '$hours:$minutes';
}

String convertDurationToViewFormat(Duration? duration) {
  if (duration == null) {
    return '--';
  }
  String convertedTime = '${duration.inMinutes.remainder(60)}min';
  if (duration.inHours > 0) {
    return '${duration.inHours}godz ' + convertedTime;
  }
  return convertedTime;
}

String _convertNumberToTimeStr(int number) {
  return number < 10 ? '0$number' : '$number';
}

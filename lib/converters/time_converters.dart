import 'package:flutter/material.dart';

String convertTimeToViewFormat(TimeOfDay? time) {
  if (time == null) {
    return '--';
  }
  final String hours = _convertNumberToTimeStr(time.hour);
  final String minutes = _convertNumberToTimeStr(time.minute);
  return '$hours:$minutes';
}

String convertTimeToDurationViewFormat(TimeOfDay? time) {
  if (time == null) {
    return '--';
  }
  String convertedTime = '${time.minute}min';
  if (time.hour > 0) {
    return '${time.hour}godz ' + convertedTime;
  }
  return convertedTime;
}

String _convertNumberToTimeStr(int number) {
  return number < 10 ? '0$number' : '$number';
}

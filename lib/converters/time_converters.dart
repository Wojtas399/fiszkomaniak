import 'package:fiszkomaniak/utils/utils.dart';
import 'package:flutter/material.dart';

String convertTimeToViewFormat(TimeOfDay? time) {
  if (time == null) {
    return '--';
  }
  final String hours = Utils.twoDigits(time.hour);
  final String minutes = Utils.twoDigits(time.minute);
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

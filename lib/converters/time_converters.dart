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
  final int hours = duration.inHours;
  final int minutes = duration.inMinutes.remainder(60);
  final String convertedMinutes = '${minutes}min';
  final String convertedHours = '${hours}godz';
  if (hours > 0 && minutes == 0) {
    return convertedHours;
  } else if (minutes > 0 && hours == 0) {
    return convertedMinutes;
  }
  return '$convertedHours $convertedMinutes';
}

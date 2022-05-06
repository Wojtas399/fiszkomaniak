import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/changed_document.dart';
import '../models/session_model.dart';

class FireConverters {
  static DbDocChangeType convertChangeType(
    DocumentChangeType fireChangeType,
  ) {
    switch (fireChangeType) {
      case DocumentChangeType.added:
        return DbDocChangeType.added;
      case DocumentChangeType.modified:
        return DbDocChangeType.updated;
      case DocumentChangeType.removed:
        return DbDocChangeType.removed;
    }
  }

  static String convertDateTimeToString(DateTime date) {
    final String month = convertNumberToDateTimeString(date.month);
    final String day = convertNumberToDateTimeString(date.day);
    return '${date.year}-$month-$day';
  }

  static DateTime convertStringToDateTime(String date) {
    final List<String> splitDate = date.split('-');
    final int year = int.parse(splitDate[0]);
    final int month = int.parse(splitDate[1]);
    final int day = int.parse(splitDate[2]);
    return DateTime(year, month, day);
  }

  static String? convertFlashcardsTypeToString(FlashcardsType? type) {
    if (type == null) {
      return null;
    }
    switch (type) {
      case FlashcardsType.all:
        return 'all';
      case FlashcardsType.remembered:
        return 'remembered';
      case FlashcardsType.notRemembered:
        return 'notRemembered';
    }
  }

  static FlashcardsType? convertStringToFlashcardsType(String? type) {
    switch (type) {
      case 'all':
        return FlashcardsType.all;
      case 'remembered':
        return FlashcardsType.remembered;
      case 'notRemembered':
        return FlashcardsType.notRemembered;
      default:
        return null;
    }
  }

  static String? convertTimeOfDayToString(TimeOfDay? time) {
    if (time == null) {
      return null;
    }
    final String hours =
        FireConverters.convertNumberToDateTimeString(time.hour);
    final String minutes =
        FireConverters.convertNumberToDateTimeString(time.minute);
    return '$hours:$minutes';
  }

  static TimeOfDay? convertStringToTimeOfDay(String? time) {
    if (time == null) {
      return null;
    }
    final List<String> splitTime = time.split(':');
    final int hours = int.parse(splitTime[0]);
    final int minutes = int.parse(splitTime[1]);
    return TimeOfDay(hour: hours, minute: minutes);
  }

  static String convertNumberToDateTimeString(int number) {
    return number < 10 ? '0$number' : '$number';
  }
}

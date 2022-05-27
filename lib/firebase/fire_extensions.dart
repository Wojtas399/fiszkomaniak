import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fiszkomaniak/models/date_model.dart';
import 'package:fiszkomaniak/models/time_model.dart';
import '../models/changed_document.dart';
import '../models/session_model.dart';
import '../utils/utils.dart';

extension FireDocumentChangeTypeExtensions on DocumentChangeType {
  DbDocChangeType toDbDocChangeType() {
    switch (this) {
      case DocumentChangeType.added:
        return DbDocChangeType.added;
      case DocumentChangeType.modified:
        return DbDocChangeType.updated;
      case DocumentChangeType.removed:
        return DbDocChangeType.removed;
    }
  }
}

extension FireFlashcardsTypeExtensions on FlashcardsType {
  String toDbString() {
    switch (this) {
      case FlashcardsType.all:
        return 'all';
      case FlashcardsType.remembered:
        return 'remembered';
      case FlashcardsType.notRemembered:
        return 'notRemembered';
    }
  }
}

extension FireDateExtensions on Date {
  String toDbString() {
    final String month = Utils.twoDigits(this.month);
    final String day = Utils.twoDigits(this.day);
    return '$year-$month-$day';
  }
}

extension FireTimeExtensions on Time {
  String toDbString() {
    final String hour = Utils.twoDigits(this.hour);
    final String minute = Utils.twoDigits(this.minute);
    return '$hour:$minute';
  }
}

extension FireDurationExtensions on Duration {
  String toDbString() {
    final String hours = Utils.twoDigits(inHours);
    final String minutes = Utils.twoDigits(inMinutes.remainder(60));
    return '$hours:$minutes';
  }
}

extension FireNotificationStatusExtensions on NotificationStatus {
  String toDbString() {
    switch (this) {
      case NotificationStatus.incoming:
        return 'incoming';
      case NotificationStatus.received:
        return 'received';
      case NotificationStatus.opened:
        return 'opened';
      case NotificationStatus.removed:
        return 'removed';
    }
  }
}

extension FireStringExtensions on String {
  FlashcardsType? toFlashcardsType() {
    switch (this) {
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

  Date toDate() {
    final List<String> splitDate = split('-');
    final int year = int.parse(splitDate[0]);
    final int month = int.parse(splitDate[1]);
    final int day = int.parse(splitDate[2]);
    return Date(year: year, month: month, day: day);
  }

  Time toTime() {
    final List<String> splitTime = split(':');
    final int hour = int.parse(splitTime[0]);
    final int minute = int.parse(splitTime[1]);
    return Time(hour: hour, minute: minute);
  }

  Duration toDuration() {
    final List<String> splitByDoubleDot = split(':');
    final int minutes = int.parse(splitByDoubleDot[1]);
    final int hours = int.parse(splitByDoubleDot[0]);
    return Duration(hours: hours, minutes: minutes);
  }

  NotificationStatus? toNotificationStatus() {
    switch (this) {
      case 'incoming':
        return NotificationStatus.incoming;
      case 'received':
        return NotificationStatus.received;
      case 'opened':
        return NotificationStatus.opened;
      case 'removed':
        return NotificationStatus.removed;
      default:
        return null;
    }
  }
}

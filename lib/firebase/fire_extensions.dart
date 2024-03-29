import 'package:firebase_auth/firebase_auth.dart';
import '../domain/entities/flashcard.dart';
import '../domain/entities/session.dart';
import '../exceptions/auth_exceptions.dart';
import '../models/date_model.dart';
import '../models/time_model.dart';
import '../utils/utils.dart';

extension FireAuthExceptionExtensions on FirebaseAuthException {
  AuthException toAuthException() {
    switch (code) {
      case 'user-not-found':
        return AuthException.userNotFound;
      case 'wrong-password':
        return AuthException.wrongPassword;
      case 'invalid-email':
        return AuthException.invalidEmail;
      case 'email-already-in-use':
        return AuthException.emailAlreadyInUse;
      default:
        return AuthException.unknown;
    }
  }
}

extension FireFlashcardStatusExtensions on FlashcardStatus {
  String toDbString() {
    switch (this) {
      case FlashcardStatus.remembered:
        return 'remembered';
      case FlashcardStatus.notRemembered:
        return 'notRemembered';
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

  FlashcardStatus? toFlashcardStatus() {
    switch (this) {
      case 'remembered':
        return FlashcardStatus.remembered;
      case 'notRemembered':
        return FlashcardStatus.notRemembered;
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
}

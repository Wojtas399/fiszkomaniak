import 'package:equatable/equatable.dart';

class Time extends Equatable {
  final int hour;
  final int minute;

  const Time({
    required this.hour,
    required this.minute,
  });

  @override
  List<Object> get props => [hour, minute];

  Time addMinutes(int minutes) {
    final int allMinutes = hour * 60 + minute + minutes;
    final int newHour = allMinutes ~/ 60;
    final int newMinute = allMinutes - (newHour * 60);
    return Time(
      hour: newHour,
      minute: newMinute,
    );
  }

  Time subtractMinutes(int minutes) {
    final int allMinutes = hour * 60 + minute - minutes;
    final int newHour = allMinutes ~/ 60;
    final int newMinute = allMinutes - (newHour * 60);
    return Time(
      hour: newHour,
      minute: newMinute,
    );
  }

  static Time now() {
    final now = DateTime.now();
    return Time(hour: now.hour, minute: now.minute);
  }
}

Time createTime({
  int? hour,
  int? minute,
}) {
  return Time(hour: hour ?? 0, minute: minute ?? 0);
}

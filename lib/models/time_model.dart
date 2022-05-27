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
    final int newMinute = minute + minutes;
    return Time(
      hour: (hour + (newMinute ~/ 60)) % 24,
      minute: (minute + minutes) % 60,
    );
  }

  Time subtractMinutes(int minutes) {
    final int newMinute = minute - minutes;
    return Time(
      hour: (hour - (newMinute ~/ 60)) % 24,
      minute: (minute - minutes) % 60,
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

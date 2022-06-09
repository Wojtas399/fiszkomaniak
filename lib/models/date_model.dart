import 'package:equatable/equatable.dart';

class Date extends Equatable {
  final int year;
  final int month;
  final int day;

  const Date({
    required this.year,
    required this.month,
    required this.day,
  });

  @override
  List<Object> get props => [
        year,
        month,
        day,
      ];

  int get weekday => DateTime(year, month, day).weekday;

  Date subtractDays(int days) {
    final newDate = DateTime(year, month, day).subtract(Duration(days: days));
    return Date(year: newDate.year, month: newDate.month, day: newDate.day);
  }

  Date addDays(int days) {
    final newDate = DateTime(year, month, day).add(Duration(days: days));
    return Date(year: newDate.year, month: newDate.month, day: newDate.day);
  }

  static Date now() {
    final now = DateTime.now();
    return Date(year: now.year, month: now.month, day: now.day);
  }
}

Date createDate({int? year, int? month, int? day}) {
  return Date(year: year ?? 2022, month: month ?? 1, day: day ?? 1);
}

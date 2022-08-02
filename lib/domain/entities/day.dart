import 'package:equatable/equatable.dart';
import '../../models/date_model.dart';

class Day extends Equatable {
  final Date date;
  final int amountOfRememberedFlashcards;

  const Day({
    required this.date,
    required this.amountOfRememberedFlashcards,
  });

  @override
  List<Object> get props => [date, amountOfRememberedFlashcards];
}

Day createDay({
  Date? date,
  int? amountOfRememberedFlashcards,
}) {
  return Day(
    date: date ?? const Date(year: 2022, month: 1, day: 1),
    amountOfRememberedFlashcards: amountOfRememberedFlashcards ?? 0,
  );
}

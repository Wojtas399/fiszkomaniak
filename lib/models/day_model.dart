import 'package:equatable/equatable.dart';
import 'package:fiszkomaniak/models/day_flashcard_model.dart';
import 'date_model.dart';

class Day extends Equatable {
  final Date date;
  final List<DayFlashcard> rememberedFlashcards;

  const Day({
    required this.date,
    required this.rememberedFlashcards,
  });

  @override
  List<Object> get props => [date, rememberedFlashcards];
}

Day createDay({
  Date? date,
  List<DayFlashcard>? rememberedFlashcards,
}) {
  return Day(
    date: date ?? const Date(year: 2022, month: 1, day: 1),
    rememberedFlashcards: rememberedFlashcards ?? [],
  );
}

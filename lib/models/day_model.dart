import 'package:equatable/equatable.dart';
import 'package:fiszkomaniak/models/day_flashcard_model.dart';

class Day extends Equatable {
  final DateTime date;
  final List<DayFlashcard> rememberedFlashcards;

  const Day({
    required this.date,
    required this.rememberedFlashcards,
  });

  @override
  List<Object> get props => [date, rememberedFlashcards];
}

Day createDay({
  DateTime? date,
  List<DayFlashcard>? rememberedFlashcards,
}) {
  return Day(
    date: date ?? DateTime(200),
    rememberedFlashcards: rememberedFlashcards ?? [],
  );
}

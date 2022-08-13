import 'package:equatable/equatable.dart';
import '../../models/date_model.dart';

class ChartDay extends Equatable {
  final Date date;
  final int rememberedFlashcardsAmount;

  const ChartDay({
    required this.date,
    this.rememberedFlashcardsAmount = 0,
  });

  ChartDay copyWithAmountOfRememberedFlashcards(int? value) {
    return ChartDay(
      date: date,
      rememberedFlashcardsAmount: value ?? rememberedFlashcardsAmount,
    );
  }

  @override
  List<Object> get props => [date, rememberedFlashcardsAmount];
}
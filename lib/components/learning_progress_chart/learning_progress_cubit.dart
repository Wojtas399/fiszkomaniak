import 'package:equatable/equatable.dart';
import 'package:fiszkomaniak/models/date_model.dart';
import 'package:fiszkomaniak/models/day_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../utils/date_utils.dart';

class LearningProgressCubit extends Cubit<List<ChartDay>> {
  List<Day>? _daysFromUser;
  late Date _firstDayOfDisplayedWeek;

  LearningProgressCubit({
    required Date initialDateOfWeek,
  }) : super([]) {
    _firstDayOfDisplayedWeek = initialDateOfWeek.subtractDays(
      initialDateOfWeek.weekday - 1,
    );
  }

  List<Date> get onlyDates => state.map((day) => day.date).toList();

  void updateDaysFromUser(List<Day>? days) {
    _daysFromUser = days;
    _setDays();
  }

  void switchToPreviousWeek() {
    _firstDayOfDisplayedWeek = _firstDayOfDisplayedWeek.subtractDays(7);
    _setDays();
  }

  void switchToNextWeek() {
    _firstDayOfDisplayedWeek = _firstDayOfDisplayedWeek.addDays(7);
    _setDays();
  }

  void _setDays() {
    final List<Day> daysFromUser = [...?_daysFromUser];
    final List<Date> datesFromWeek = DateUtils.getDaysFromWeek(
      _firstDayOfDisplayedWeek,
    );
    final List<ChartDay> chartDaysFromWeek = List<ChartDay>.generate(
      datesFromWeek.length,
      (index) => ChartDay(date: datesFromWeek[index]),
    );
    final List<Date> datesFromUser =
        daysFromUser.map((day) => day.date).toList();
    for (int i = 0; i < datesFromWeek.length; i++) {
      final Date date = datesFromWeek[i];
      if (datesFromUser.contains(date)) {
        final Day day = daysFromUser.firstWhere((day) => day.date == date);
        chartDaysFromWeek[i] =
            chartDaysFromWeek[i].copyWithAmountOfRememberedFlashcards(
          day.rememberedFlashcards.length,
        );
      }
    }
    emit(chartDaysFromWeek);
  }
}

class ChartDay extends Equatable {
  final Date date;
  final int amountOfRememberedFlashcards;

  const ChartDay({
    required this.date,
    this.amountOfRememberedFlashcards = 0,
  });

  ChartDay copyWithAmountOfRememberedFlashcards(int value) {
    return ChartDay(
      date: date,
      amountOfRememberedFlashcards: value,
    );
  }

  @override
  List<Object> get props => [
        date,
        amountOfRememberedFlashcards,
      ];
}

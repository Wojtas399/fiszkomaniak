import 'package:equatable/equatable.dart';
import 'package:fiszkomaniak/models/day_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../utils/date_utils.dart';

class LearningProgressCubit extends Cubit<List<ChartDay>> {
  List<Day>? _daysFromUser;
  late DateTime _firstDayOfDisplayedWeek;

  LearningProgressCubit({
    required DateTime initialDateOfWeek,
  }) : super([]) {
    _firstDayOfDisplayedWeek = initialDateOfWeek.subtract(
      Duration(days: initialDateOfWeek.weekday - 1),
    );
  }

  List<DateTime> get onlyDates => state.map((day) => day.date).toList();

  void updateDaysFromUser(List<Day>? days) {
    _daysFromUser = days;
    _setDays();
  }

  void switchToPreviousWeek() {
    _firstDayOfDisplayedWeek = _firstDayOfDisplayedWeek.subtract(
      const Duration(days: 7),
    );
    _setDays();
  }

  void switchToNextWeek() {
    _firstDayOfDisplayedWeek = _firstDayOfDisplayedWeek.add(
      const Duration(days: 7),
    );
    _setDays();
  }

  void _setDays() {
    final List<Day> daysFromUser = [...?_daysFromUser];
    final List<DateTime> datesFromWeek = DateUtils.getDaysFromWeek(
      _firstDayOfDisplayedWeek,
    );
    final List<ChartDay> chartDaysFromWeek = List<ChartDay>.generate(
      datesFromWeek.length,
      (index) => ChartDay(date: datesFromWeek[index]),
    );
    final List<DateTime> datesFromUser =
        daysFromUser.map((day) => day.date).toList();
    for (int i = 0; i < datesFromWeek.length; i++) {
      final DateTime date = datesFromWeek[i];
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
  final DateTime date;
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

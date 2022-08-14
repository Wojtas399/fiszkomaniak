import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/date_model.dart';
import '../../utils/date_utils.dart';
import 'learning_progress_chart_day.dart';

class LearningProgressCubit extends Cubit<List<ChartDay>> {
  List<ChartDay>? _allDays;
  late Date _firstDayOfDisplayedWeek;
  late DateUtils _dateUtils;

  LearningProgressCubit({
    required Date initialDateOfWeek,
    required DateUtils dateUtils,
  }) : super([]) {
    _firstDayOfDisplayedWeek = initialDateOfWeek.subtractDays(
      initialDateOfWeek.weekday - 1,
    );
    _dateUtils = dateUtils;
  }

  List<Date> get onlyDates => state.map((ChartDay day) => day.date).toList();

  void updateChartDays(List<ChartDay>? days) {
    _allDays = days;
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
    final List<Date> datesFromDisplayedWeek = _dateUtils.getDaysFromWeek(
      _firstDayOfDisplayedWeek,
    );
    List<ChartDay> daysFromDisplayedWeek = List<ChartDay>.generate(
      datesFromDisplayedWeek.length,
      (int index) => ChartDay(date: datesFromDisplayedWeek[index]),
    );
    daysFromDisplayedWeek = daysFromDisplayedWeek
        .map(
          (ChartDay day) => day.copyWithAmountOfRememberedFlashcards(
            _findAmountOfRememberedFlashcardsFromDayInAllDays(day.date),
          ),
        )
        .toList();
    emit(daysFromDisplayedWeek);
  }

  int? _findAmountOfRememberedFlashcardsFromDayInAllDays(Date date) {
    final List<ChartDay?> allDays = [...?_allDays];
    return allDays
        .firstWhere((ChartDay? day) => day?.date == date, orElse: () => null)
        ?.rememberedFlashcardsAmount;
  }
}

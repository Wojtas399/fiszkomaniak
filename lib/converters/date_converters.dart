import 'package:fiszkomaniak/utils/utils.dart';

String convertDateToViewFormat(DateTime? date) {
  if (date == null) {
    return '--';
  }
  final String day = Utils.twoDigits(date.day);
  final String month = Utils.twoDigits(date.month);
  return '$day.$month.${date.year}';
}

String convertDateToViewFormatWithDayAndMonthNames(DateTime? date) {
  if (date == null) {
    return '--';
  }
  final String dayName = _dayNames[date.weekday - 1];
  final String monthName = _monthNames[date.month - 1];
  return '$dayName, ${date.day} $monthName ${date.year}r.';
}

final List<String> _dayNames = [
  'Poniedziałek',
  'Wtorek',
  'Środa',
  'Czwartek',
  'Piątek',
  'Sobota',
  'Niedziela',
];

final List<String> _monthNames = [
  'Styczeń',
  'Luty',
  'Marzec',
  'Kwiecień',
  'Maj',
  'Czerwiec',
  'Lipiec',
  'Sierpień',
  'Wrzesień',
  'Październik',
  'Listopad',
  'Grudzień',
];

String convertDateToViewFormat(DateTime? date) {
  if (date == null) {
    return '--';
  }
  final String day = convertNumberToDateStr(date.day);
  final String month = convertNumberToDateStr(date.month);
  return '$day.$month.${date.year}';
}

String convertDateToViewFormatWithDayAndMonthNames(DateTime? date) {
  if (date == null) {
    return '--';
  }
  final String dayName = _dayNames[date.weekday];
  final String monthName = _monthNames[date.month - 1];
  return '$dayName, ${date.day} $monthName ${date.year}r.';
}

String convertNumberToDateStr(int number) {
  return number < 10 ? '0$number' : '$number';
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
String convertDateToViewFormat(DateTime? date) {
  if (date == null) {
    return '--';
  }
  final String day = _convertNumberToDateStr(date.day);
  final String month = _convertNumberToDateStr(date.month);
  return '$day.$month.${date.year}';
}

String _convertNumberToDateStr(int number) {
  return number < 10 ? '0$number' : '$number';
}

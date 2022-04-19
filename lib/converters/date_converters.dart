String convertDateToViewFormat(DateTime? date) {
  if (date == null) {
    return '--';
  }
  final String day = convertNumberToDateStr(date.day);
  final String month = convertNumberToDateStr(date.month);
  return '$day.$month.${date.year}';
}

String convertNumberToDateStr(int number) {
  return number < 10 ? '0$number' : '$number';
}

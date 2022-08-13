import '../models/date_model.dart';
import '../utils/utils.dart';

extension UIDateExtensions on Date? {
  String toUIFormat() {
    final Date? date = this;
    if (date == null) {
      return '--';
    }
    final String month = Utils.twoDigits(date.month);
    final String day = Utils.twoDigits(date.day);
    return '$day.$month.${date.year}';
  }

  String toUIFormatWithDayAndMonthNames() {
    final Date? date = this;
    if (date == null) {
      return '--';
    }
    final String dayName = _dayNames[date.weekday - 1];
    final String monthName = _monthNames[date.month - 1];
    return '$dayName, ${date.day} $monthName ${date.year}r.';
  }

  String toWeekDayShortName() {
    final Date? date = this;
    if (date == null) {
      return '--';
    }
    return _shortDayNames[date.weekday - 1];
  }
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

final List<String> _shortDayNames = [
  'Pon',
  'Wto',
  'Śro',
  'Czw',
  'Pią',
  'Sob',
  'Nie',
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

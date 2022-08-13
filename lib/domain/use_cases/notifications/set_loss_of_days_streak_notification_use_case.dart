import '../../../domain/entities/day.dart';
import '../../../interfaces/notifications_interface.dart';
import '../../../interfaces/user_interface.dart';
import '../../../models/date_model.dart';
import '../../../providers/date_provider.dart';

class SetLossOfDaysStreakNotificationUseCase {
  late final UserInterface _userInterface;
  late final NotificationsInterface _notificationsInterface;
  late final DateProvider _dateProvider;

  SetLossOfDaysStreakNotificationUseCase({
    required UserInterface userInterface,
    required NotificationsInterface notificationsInterface,
    required DateProvider dateProvider,
  }) {
    _userInterface = userInterface;
    _notificationsInterface = notificationsInterface;
    _dateProvider = dateProvider;
  }

  Future<void> execute() async {
    final int? daysStreak = await _userInterface.daysStreak$.first;
    if (daysStreak != null && daysStreak > 0) {
      final Date? date = await _getDate();
      if (date != null) {
        await _notificationsInterface.setLossOfDaysStreakNotification(
          date: date,
        );
      }
    }
  }

  Future<Date?> _getDate() async {
    final List<Day>? days = await _userInterface.days$.first;
    if (days != null && days.last.date == _dateProvider.getNow()) {
      return _dateProvider.getTomorrowDate();
    } else if (_dateProvider.isBeforeNineteenToday()) {
      return _dateProvider.getNow();
    }
    return null;
  }
}

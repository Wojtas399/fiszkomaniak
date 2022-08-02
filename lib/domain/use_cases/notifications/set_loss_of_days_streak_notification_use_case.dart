import '../../../interfaces/notifications_interface.dart';
import '../../../interfaces/user_interface.dart';
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
      await _notificationsInterface.setLossOfDaysStreakNotification(
        date: _dateProvider.isAfterNineteenToday()
            ? _dateProvider.getTomorrowDate()
            : _dateProvider.getNow(),
      );
    }
  }
}

import 'dart:async';
import '../../../domain/use_cases/notifications/set_loss_of_days_streak_notification_use_case.dart';
import '../../../domain/use_cases/user/get_days_streak_use_case.dart';

class UserListener {
  late final GetDaysStreakUseCase _getDaysStreakUseCase;
  late final SetLossOfDaysStreakNotificationUseCase
      _setLossOfDaysStreakNotificationUseCase;
  StreamSubscription<int?>? _daysStreakListener;
  int _currentDaysStreak = 0;

  UserListener({
    required GetDaysStreakUseCase getDaysStreakUseCase,
    required SetLossOfDaysStreakNotificationUseCase
        setLossOfDaysStreakNotificationUseCase,
  }) {
    _getDaysStreakUseCase = getDaysStreakUseCase;
    _setLossOfDaysStreakNotificationUseCase =
        setLossOfDaysStreakNotificationUseCase;
  }

  void initialize() {
    _setDaysStreakListener();
  }

  void dispose() {
    _daysStreakListener?.cancel();
    _daysStreakListener = null;
  }

  void _setDaysStreakListener() {
    _daysStreakListener ??= _getDaysStreakUseCase.execute().listen(
          _manageDaysStreak,
        );
  }

  Future<void> _manageDaysStreak(int? daysStreak) async {
    if (daysStreak != null && daysStreak > _currentDaysStreak) {
      await _setLossOfDaysStreakNotificationUseCase.execute();
      _currentDaysStreak = daysStreak;
    }
  }
}

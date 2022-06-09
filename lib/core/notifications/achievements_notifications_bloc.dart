import 'dart:async';
import 'package:fiszkomaniak/core/achievements/achievements_bloc.dart';
import 'package:fiszkomaniak/core/notifications_settings/notifications_settings_bloc.dart';
import 'package:fiszkomaniak/interfaces/achievements_notifications_interface.dart';
import 'package:fiszkomaniak/models/date_model.dart';
import 'package:fiszkomaniak/models/time_model.dart';
import 'package:fiszkomaniak/utils/time_utils.dart';
import 'package:rxdart/rxdart.dart';

class AchievementsNotificationsBloc {
  late final AchievementsNotificationsInterface
      _achievementsNotificationsInterface;
  late final AchievementsBloc _achievementsBloc;
  late final NotificationsSettingsBloc _notificationsSettingsBloc;
  StreamSubscription<AchievementsState>? _achievementsStateListener;
  final BehaviorSubject<String> errorStream = BehaviorSubject<String>();

  AchievementsNotificationsBloc({
    required AchievementsNotificationsInterface
        achievementsNotificationsInterface,
    required AchievementsBloc achievementsBloc,
    required NotificationsSettingsBloc notificationsSettingsBloc,
  }) {
    _achievementsNotificationsInterface = achievementsNotificationsInterface;
    _achievementsBloc = achievementsBloc;
    _notificationsSettingsBloc = notificationsSettingsBloc;
  }

  void initialize() {
    _setAchievementsStateListener();
  }

  void dispose() {
    _achievementsStateListener?.cancel();
    errorStream.close();
  }

  Future<void> setDaysStreakLoseNotification() async {
    if (_notificationsSettingsBloc.state.areDaysStreakLoseNotificationsOn &&
        _achievementsBloc.state.daysStreak > 0) {
      try {
        await _achievementsNotificationsInterface.setDaysStreakLoseNotification(
          date: TimeUtils.isPastTime(
            const Time(hour: 19, minute: 00),
            Date.now(),
          )
              ? Date.now().addDays(1)
              : Date.now(),
        );
      } catch (error) {
        errorStream.add(error.toString());
      }
    }
  }

  Future<void> cancelDaysStreakLoseNotification() async {
    try {
      await _achievementsNotificationsInterface
          .removeDaysStreakLoseNotification();
    } catch (error) {
      errorStream.add(error.toString());
    }
  }

  void _setAchievementsStateListener() {
    _achievementsStateListener ??= _achievementsBloc.stream.listen(
      (state) async {
        final AchievementsStatus status = state.status;
        if (status is AchievementsStatusDaysStreakUpdated) {
          await _updateDaysStreakLoseNotification();
        }
      },
    );
  }

  Future<void> _updateDaysStreakLoseNotification() async {
    if (_notificationsSettingsBloc.state.areDaysStreakLoseNotificationsOn) {
      try {
        await _achievementsNotificationsInterface.setDaysStreakLoseNotification(
          date: Date.now().addDays(1),
        );
      } catch (error) {
        errorStream.add(error.toString());
      }
    }
  }
}

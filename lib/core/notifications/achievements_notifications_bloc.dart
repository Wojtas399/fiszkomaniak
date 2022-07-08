import 'dart:async';
import 'package:fiszkomaniak/core/achievements/achievements_bloc.dart';
import 'package:fiszkomaniak/interfaces/achievements_notifications_interface.dart';
import 'package:fiszkomaniak/models/date_model.dart';
import 'package:fiszkomaniak/models/time_model.dart';
import 'package:fiszkomaniak/utils/time_utils.dart';
import 'package:rxdart/rxdart.dart';

class AchievementsNotificationsBloc {
  late final AchievementsNotificationsInterface
      _achievementsNotificationsInterface;
  late final AchievementsBloc _achievementsBloc;
  StreamSubscription<AchievementsState>? _achievementsStateListener;
  final BehaviorSubject<String> errorStream = BehaviorSubject<String>();

  AchievementsNotificationsBloc({
    required AchievementsNotificationsInterface
        achievementsNotificationsInterface,
    required AchievementsBloc achievementsBloc,
  }) {
    _achievementsNotificationsInterface = achievementsNotificationsInterface;
    _achievementsBloc = achievementsBloc;
  }

  void initialize() {
    _setAchievementsStateListener();
  }

  void dispose() {
    _achievementsStateListener?.cancel();
    errorStream.close();
  }

  Future<void> setDaysStreakLoseNotification() async {
    // if (_notificationsSettingsBloc.state.areLossOfDaysStreakNotificationsOn &&
    //     _achievementsBloc.state.daysStreak > 0) {
    //   try {
    //     await _achievementsNotificationsInterface.setDaysStreakLoseNotification(
    //       date: TimeUtils.isPastTime(
    //         const Time(hour: 19, minute: 00),
    //         Date.now(),
    //       )
    //           ? Date.now().addDays(1)
    //           : Date.now(),
    //     );
    //   } catch (error) {
    //     errorStream.add(error.toString());
    //   }
    // }
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
    // if (_notificationsSettingsBloc.state.areLossOfDaysStreakNotificationsOn) {
    //   try {
    //     await _achievementsNotificationsInterface.setDaysStreakLoseNotification(
    //       date: Date.now().addDays(1),
    //     );
    //   } catch (error) {
    //     errorStream.add(error.toString());
    //   }
    // }
  }
}

import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:fiszkomaniak/core/notifications/achievements_notifications_bloc.dart';
import 'package:fiszkomaniak/core/notifications/sessions_notifications_bloc.dart';
import 'package:fiszkomaniak/core/notifications_settings/notifications_settings_bloc.dart';
import 'package:fiszkomaniak/interfaces/notifications_interface.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/notification_model.dart';

part 'notifications_event.dart';

part 'notifications_state.dart';

part 'notifications_status.dart';

class NotificationsBloc extends Bloc<NotificationsEvent, NotificationsState> {
  late final NotificationsInterface _notificationsInterface;
  late final SessionsNotificationsBloc _sessionsNotificationsBloc;
  late final AchievementsNotificationsBloc _achievementsNotificationsBloc;
  late final NotificationsSettingsBloc _notificationsSettingsBloc;
  StreamSubscription<NotificationsSettingsState>?
      _notificationsSettingsStateListener;
  StreamSubscription<String>? _sessionsNotificationsErrorsListener;
  StreamSubscription<String>? _achievementsNotificationsErrorsListener;

  NotificationsBloc({
    required NotificationsInterface notificationsInterface,
    required SessionsNotificationsBloc sessionsNotificationsBloc,
    required AchievementsNotificationsBloc achievementsNotificationsBloc,
    required NotificationsSettingsBloc notificationsSettingsBloc,
  }) : super(const NotificationsState()) {
    _notificationsInterface = notificationsInterface;
    _sessionsNotificationsBloc = sessionsNotificationsBloc;
    _achievementsNotificationsBloc = achievementsNotificationsBloc;
    _notificationsSettingsBloc = notificationsSettingsBloc;
    on<NotificationsEventInitialize>(_initialize);
    on<NotificationsEventNotificationsSettingsStateChanged>(
      _notificationsSettingsStateChanged,
    );
    on<NotificationsEventNotificationSelected>(_notificationSelected);
    on<NotificationsEventErrorReceived>(_errorReceived);
  }

  @override
  Future<void> close() {
    _notificationsSettingsStateListener?.cancel();
    _sessionsNotificationsErrorsListener?.cancel();
    _achievementsNotificationsErrorsListener?.cancel();
    _sessionsNotificationsBloc.dispose();
    _achievementsNotificationsBloc.dispose();
    return super.close();
  }

  Future<void> _initialize(
    NotificationsEventInitialize event,
    Emitter<NotificationsState> emit,
  ) async {
    final NotificationsSettingsState notificationsSettingsState =
        _notificationsSettingsBloc.state;
    emit(state.copyWith(
      areScheduledNotificationsOn:
          notificationsSettingsState.areSessionsPlannedNotificationsOn,
      areDefaultNotificationsOn:
          notificationsSettingsState.areSessionsDefaultNotificationsOn,
      areDaysStreakLoseNotificationsOn:
          notificationsSettingsState.areDaysStreakLoseNotificationsOn,
    ));
    await _checkIfNotificationLaunchedApp();
    await _initializeLocalNotifications();
    _sessionsNotificationsBloc.initialize();
    _achievementsNotificationsBloc.initialize();
    _setNotificationsSettingsStateListener();
    _setSessionsNotificationsErrorsListener();
    _setAchievementNotificationsErrorsListener();
  }

  Future<void> _notificationsSettingsStateChanged(
    NotificationsEventNotificationsSettingsStateChanged event,
    Emitter<NotificationsState> emit,
  ) async {
    final NotificationsSettingsState settingsState =
        event.newNotificationsSettingsState;
    bool areScheduledNotificationsOn = state.areScheduledNotificationsOn;
    bool areDefaultNotificationsOn = state.areDefaultNotificationsOn;
    bool areDaysStreakLoseNotificationsOn =
        state.areDaysStreakLoseNotificationsOn;
    if (settingsState.areSessionsPlannedNotificationsOn !=
        areScheduledNotificationsOn) {
      if (settingsState.areSessionsPlannedNotificationsOn) {
        areScheduledNotificationsOn = true;
        await _turnOnSessionsScheduledNotifications();
      } else {
        areScheduledNotificationsOn = false;
        await _turnOffSessionsScheduledNotifications();
      }
    }
    if (settingsState.areSessionsDefaultNotificationsOn !=
        areDefaultNotificationsOn) {
      if (settingsState.areSessionsDefaultNotificationsOn) {
        areDefaultNotificationsOn = true;
        await _turnOnSessionsDefaultNotifications();
      } else {
        areDefaultNotificationsOn = false;
        await _turnOffSessionsDefaultNotifications();
      }
    }
    if (settingsState.areDaysStreakLoseNotificationsOn !=
        areDaysStreakLoseNotificationsOn) {
      if (settingsState.areDaysStreakLoseNotificationsOn) {
        areDaysStreakLoseNotificationsOn = true;
        await _turnOnDaysStreakLoseNotifications();
      } else {
        areDaysStreakLoseNotificationsOn = false;
        await _turnOffDaysStreakLoseNotification();
      }
    }
    emit(state.copyWith(
      areScheduledNotificationsOn: areScheduledNotificationsOn,
      areDefaultNotificationsOn: areDefaultNotificationsOn,
      areDaysStreakLoseNotificationsOn: areDaysStreakLoseNotificationsOn,
    ));
  }

  Future<void> _notificationSelected(
    NotificationsEventNotificationSelected event,
    Emitter<NotificationsState> emit,
  ) async {
    final Notification notification = event.notification;
    if (notification is SessionNotification) {
      emit(state.copyWith(
        status: NotificationsStatusSessionSelected(
          sessionId: notification.sessionId,
        ),
      ));
    } else if (notification is DaysStreakLoseNotification) {
      emit(state.copyWith(
        status: NotificationsStatusDaysStreakLoseSelected(),
      ));
    }
    emit(state.copyWith());
  }

  void _errorReceived(
    NotificationsEventErrorReceived event,
    Emitter<NotificationsState> emit,
  ) {
    emit(state.copyWith(
      status: NotificationsStatusError(message: event.message),
    ));
  }

  Future<void> _turnOnSessionsScheduledNotifications() async {
    await _sessionsNotificationsBloc.setScheduledNotifications();
  }

  Future<void> _turnOffSessionsScheduledNotifications() async {
    await _sessionsNotificationsBloc.cancelScheduledNotifications();
  }

  Future<void> _turnOnSessionsDefaultNotifications() async {
    await _sessionsNotificationsBloc.setDefaultNotificationsForAllSessions();
  }

  Future<void> _turnOffSessionsDefaultNotifications() async {
    await _sessionsNotificationsBloc.cancelDefaultNotificationsForAllSessions();
  }

  Future<void> _turnOnDaysStreakLoseNotifications() async {
    await _achievementsNotificationsBloc.setDaysStreakLoseNotification();
  }

  Future<void> _turnOffDaysStreakLoseNotification() async {
    await _achievementsNotificationsBloc.cancelDaysStreakLoseNotification();
  }

  Future<void> _checkIfNotificationLaunchedApp() async {
    try {
      final Notification? notification =
          await _notificationsInterface.didNotificationLaunchApp();
      if (notification != null) {
        add(NotificationsEventNotificationSelected(
          notification: notification,
        ));
      }
    } catch (error) {
      add(NotificationsEventErrorReceived(message: error.toString()));
    }
  }

  Future<void> _initializeLocalNotifications() async {
    try {
      await _notificationsInterface.initializeSettings(
        onNotificationSelected: (Notification notification) {
          add(NotificationsEventNotificationSelected(
            notification: notification,
          ));
        },
      );
    } catch (error) {
      add(NotificationsEventErrorReceived(message: error.toString()));
    }
  }

  void _setNotificationsSettingsStateListener() {
    _notificationsSettingsStateListener ??=
        _notificationsSettingsBloc.stream.listen(
      (state) => add(
        NotificationsEventNotificationsSettingsStateChanged(
          newNotificationsSettingsState: state,
        ),
      ),
    );
  }

  void _setSessionsNotificationsErrorsListener() {
    _sessionsNotificationsErrorsListener ??=
        _sessionsNotificationsBloc.errorStream.listen(
      (error) => add(NotificationsEventErrorReceived(message: error)),
    );
  }

  void _setAchievementNotificationsErrorsListener() {
    _achievementsNotificationsErrorsListener ??=
        _achievementsNotificationsBloc.errorStream.listen(
      (error) => add(NotificationsEventErrorReceived(message: error)),
    );
  }
}

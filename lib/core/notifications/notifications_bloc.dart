import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:fiszkomaniak/core/notifications/sessions_notifications/sessions_notifications_bloc.dart';
import 'package:fiszkomaniak/core/notifications_settings/notifications_settings_bloc.dart';
import 'package:fiszkomaniak/interfaces/notifications_interface.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/notification_model.dart';

part 'notifications_event.dart';

part 'notifications_state.dart';

class NotificationsBloc extends Bloc<NotificationsEvent, NotificationsState> {
  late final NotificationsInterface _notificationsInterface;
  late final SessionsNotificationsBloc _sessionsNotificationsBloc;
  late final NotificationsSettingsBloc _notificationsSettingsBloc;
  late bool _areScheduledNotificationsOn;
  late bool _areDefaultNotificationsOn;
  StreamSubscription<NotificationsSettingsState>?
      _notificationsSettingsStateListener;
  StreamSubscription<String>? _sessionsNotificationsErrorsListener;

  NotificationsBloc({
    required NotificationsInterface notificationsInterface,
    required SessionsNotificationsBloc sessionsNotificationsBloc,
    required NotificationsSettingsBloc notificationsSettingsBloc,
  }) : super(const NotificationsStateInitial()) {
    _notificationsInterface = notificationsInterface;
    _sessionsNotificationsBloc = sessionsNotificationsBloc;
    _notificationsSettingsBloc = notificationsSettingsBloc;
    on<NotificationsEventInitialize>(_initialize);
    on<NotificationsEventNotificationSelected>(_notificationSelected);
    on<NotificationsEventErrorReceived>(_errorReceived);
    on<NotificationsEventTurnOnSessionsScheduledNotifications>(
      _turnOnSessionsScheduledNotifications,
    );
    on<NotificationsEventTurnOffSessionsScheduledNotifications>(
      _turnOffSessionsScheduledNotifications,
    );
    on<NotificationsEventTurnOnSessionsDefaultNotifications>(
      _turnOnSessionsDefaultNotifications,
    );
    on<NotificationsEventTurnOffSessionsDefaultNotifications>(
      _turnOffSessionsDefaultNotifications,
    );
  }

  @override
  Future<void> close() {
    _notificationsSettingsStateListener?.cancel();
    _sessionsNotificationsErrorsListener?.cancel();
    _sessionsNotificationsBloc.dispose();
    return super.close();
  }

  Future<void> _initialize(
    NotificationsEventInitialize event,
    Emitter<NotificationsState> state,
  ) async {
    await _checkIfNotificationLaunchedApp();
    await _initializeLocalNotifications();
    _sessionsNotificationsBloc.initialize();
    _setNotificationsSettingsStateListener();
    _setSessionsNotificationsErrorsListener();
    _areScheduledNotificationsOn =
        _notificationsSettingsBloc.state.areSessionsPlannedNotificationsOn;
    _areDefaultNotificationsOn =
        _notificationsSettingsBloc.state.areSessionsDefaultNotificationsOn;
  }

  Future<void> _notificationSelected(
    NotificationsEventNotificationSelected event,
    Emitter<NotificationsState> emit,
  ) async {
    final Notification notification = event.notification;
    if (notification is SessionNotification) {
      emit(NotificationsStateSessionSelected(
        sessionId: notification.sessionId,
      ));
    } else if (notification is DaysStreakLoseNotification) {
      //TODO
    }
    emit(NotificationsStateLoaded());
  }

  void _errorReceived(
    NotificationsEventErrorReceived event,
    Emitter<NotificationsState> emit,
  ) {
    emit(NotificationsStateError(message: event.message));
  }

  Future<void> _turnOnSessionsScheduledNotifications(
    NotificationsEventTurnOnSessionsScheduledNotifications event,
    Emitter<NotificationsState> emit,
  ) async {
    await _sessionsNotificationsBloc.setScheduledNotifications();
  }

  Future<void> _turnOffSessionsScheduledNotifications(
    NotificationsEventTurnOffSessionsScheduledNotifications event,
    Emitter<NotificationsState> emit,
  ) async {
    await _sessionsNotificationsBloc.cancelScheduledNotifications();
  }

  Future<void> _turnOnSessionsDefaultNotifications(
    NotificationsEventTurnOnSessionsDefaultNotifications event,
    Emitter<NotificationsState> emit,
  ) async {
    await _sessionsNotificationsBloc.setDefaultNotificationsForAllSessions();
  }

  Future<void> _turnOffSessionsDefaultNotifications(
    NotificationsEventTurnOffSessionsDefaultNotifications event,
    Emitter<NotificationsState> emit,
  ) async {
    await _sessionsNotificationsBloc.cancelDefaultNotificationsForAllSessions();
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
        _notificationsSettingsBloc.stream.listen(_onChangedSettingsState);
  }

  void _setSessionsNotificationsErrorsListener() {
    _sessionsNotificationsErrorsListener ??=
        _sessionsNotificationsBloc.errorStream.listen(
      (error) => add(NotificationsEventErrorReceived(message: error)),
    );
  }

  void _onChangedSettingsState(NotificationsSettingsState state) {
    if (state.areSessionsPlannedNotificationsOn !=
        _areScheduledNotificationsOn) {
      if (state.areSessionsPlannedNotificationsOn) {
        _areScheduledNotificationsOn = true;
        add(NotificationsEventTurnOnSessionsScheduledNotifications());
      } else {
        _areScheduledNotificationsOn = false;
        add(NotificationsEventTurnOffSessionsScheduledNotifications());
      }
    }
    if (state.areSessionsDefaultNotificationsOn != _areDefaultNotificationsOn) {
      if (state.areSessionsDefaultNotificationsOn) {
        _areDefaultNotificationsOn = true;
        add(NotificationsEventTurnOnSessionsDefaultNotifications());
      } else {
        _areDefaultNotificationsOn = false;
        add(NotificationsEventTurnOffSessionsDefaultNotifications());
      }
    }
  }
}

import 'dart:async';
import 'package:fiszkomaniak/core/notifications_settings/notifications_settings_bloc.dart';
import 'package:fiszkomaniak/interfaces/sessions_notifications_interface.dart';
import 'package:rxdart/rxdart.dart';
import '../../models/date_model.dart';
import '../../models/session_model.dart';
import '../../models/time_model.dart';
import '../sessions/sessions_bloc.dart';

class SessionsNotificationsBloc {
  late final SessionsNotificationsInterface _sessionsNotificationsInterface;
  late final NotificationsSettingsBloc _notificationsSettingsBloc;
  late final SessionsBloc _sessionsBloc;
  StreamSubscription<SessionsState>? _sessionsStateListener;
  final BehaviorSubject<String> errorStream = BehaviorSubject<String>();

  SessionsNotificationsBloc({
    required SessionsNotificationsInterface sessionsNotificationsInterface,
    required NotificationsSettingsBloc notificationsSettingsBloc,
    required SessionsBloc sessionsBloc,
  }) {
    _sessionsNotificationsInterface = sessionsNotificationsInterface;
    _notificationsSettingsBloc = notificationsSettingsBloc;
    _sessionsBloc = sessionsBloc;
  }

  void initialize() {
    _setSessionsStateListener();
    setScheduledNotifications();
    setDefaultNotificationsForAllSessions();
  }

  void dispose() {
    _sessionsStateListener?.cancel();
    errorStream.close();
  }

  Future<void> setScheduledNotifications() async {
    if (_notificationsSettingsBloc.state.areSessionsPlannedNotificationsOn) {
      try {
        for (final session in _sessionsBloc.state.allSessions) {
          const String groupName = 'groupName';
          final Time? notificationTime = session.notificationTime;
          if (notificationTime != null) {
            await _setScheduledNotification(
              sessionId: session.id,
              groupName: groupName,
              date: session.date,
              time: notificationTime,
              sessionStartTime: session.time,
            );
          }
        }
      } catch (error) {
        errorStream.add(error.toString());
      }
    }
  }

  Future<void> cancelScheduledNotifications() async {
    try {
      for (final session in _sessionsBloc.state.allSessions) {
        if (session.notificationTime != null) {
          await _removeScheduledNotification(session.id);
        }
      }
    } catch (error) {
      errorStream.add(error.toString());
    }
  }

  Future<void> setDefaultNotificationsForAllSessions() async {
    if (_notificationsSettingsBloc.state.areSessionsDefaultNotificationsOn) {
      try {
        for (final session in _sessionsBloc.state.allSessions) {
          await _setDefaultNotification(
            sessionId: session.id,
            groupName: 'WOWOWOWO',
            date: session.date,
            sessionStartTime: session.time,
          );
        }
      } catch (error) {
        errorStream.add(error.toString());
      }
    }
  }

  Future<void> cancelDefaultNotificationsForAllSessions() async {
    try {
      for (final session in _sessionsBloc.state.allSessions) {
        await _removeDefaultNotification(session.id);
      }
    } catch (error) {
      errorStream.add(error.toString());
    }
  }

  void _setSessionsStateListener() {
    _sessionsStateListener = _sessionsBloc.stream.listen((state) async {
      final SessionsStatus status = state.status;
      if (status is SessionsStatusSessionAdded) {
        await _setNotifications(status.sessionId);
      } else if (status is SessionsStatusSessionUpdated) {
        await _setNotifications(status.sessionId);
      } else if (status is SessionsStatusSessionRemoved) {
        await _removeNotifications(status.sessionId);
      }
    });
  }

  Future<void> _setScheduledNotification({
    required String sessionId,
    required String groupName,
    required Date date,
    required Time time,
    required Time sessionStartTime,
  }) async {
    if (_notificationsSettingsBloc.state.areSessionsPlannedNotificationsOn) {
      await _sessionsNotificationsInterface.setScheduledNotification(
        sessionId: sessionId,
        groupName: groupName,
        date: date,
        time: time,
        sessionStartTime: sessionStartTime,
      );
    }
  }

  Future<void> _removeScheduledNotification(String sessionId) async {
    await _sessionsNotificationsInterface.removeScheduledNotification(
      sessionId: sessionId,
    );
  }

  Future<void> _setDefaultNotification({
    required String sessionId,
    required String groupName,
    required Date date,
    required Time sessionStartTime,
  }) async {
    if (_notificationsSettingsBloc.state.areSessionsDefaultNotificationsOn) {
      await _sessionsNotificationsInterface.setDefaultNotification(
        sessionId: sessionId,
        groupName: groupName,
        date: date,
        sessionStartTime: sessionStartTime,
      );
    }
  }

  Future<void> _removeDefaultNotification(String sessionId) async {
    await _sessionsNotificationsInterface.removeDefaultNotification(
      sessionId: sessionId,
    );
  }

  Future<void> _setNotifications(String sessionId) async {
    final Session? session = _sessionsBloc.state.getSessionById(sessionId);
    if (session != null) {
      try {
        await _setScheduledAndDefaultNotifications(
          sessionId: sessionId,
          groupName: 'WOWOWOWOW',
          date: session.date,
          time: session.notificationTime,
          sessionStartTime: session.time,
        );
      } catch (error) {
        errorStream.add(error.toString());
      }
    }
  }

  Future<void> _removeNotifications(String sessionId) async {
    try {
      await _removeScheduledNotification(sessionId);
      await _removeDefaultNotification(sessionId);
    } catch (error) {
      errorStream.add(error.toString());
    }
  }

  Future<void> _setScheduledAndDefaultNotifications({
    required String sessionId,
    required String groupName,
    required Date date,
    required Time? time,
    required Time sessionStartTime,
  }) async {
    if (time != null) {
      await _setScheduledNotification(
        sessionId: sessionId,
        groupName: groupName,
        date: date,
        time: time,
        sessionStartTime: sessionStartTime,
      );
    }
    await _setDefaultNotification(
      sessionId: sessionId,
      groupName: groupName,
      date: date,
      sessionStartTime: sessionStartTime,
    );
  }
}

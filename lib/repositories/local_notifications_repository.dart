import 'package:fiszkomaniak/interfaces/local_notifications_interface.dart';
import 'package:fiszkomaniak/local_notifications/local_notifications_service.dart';
import 'package:fiszkomaniak/models/date_model.dart';
import 'package:fiszkomaniak/models/notification_model.dart';
import 'package:fiszkomaniak/models/time_model.dart';
import 'package:fiszkomaniak/utils/utils.dart';

class LocalNotificationsRepository implements LocalNotificationsInterface {
  late final LocalNotificationsService _localNotificationsService;

  LocalNotificationsRepository({
    required LocalNotificationsService localNotificationsService,
  }) {
    _localNotificationsService = localNotificationsService;
  }

  @override
  Future<Notification?> didNotificationLaunchApp() async {
    try {
      final details = await _localNotificationsService.getLaunchDetails();
      final notification = _getNotificationType(details?.payload);
      if (details != null &&
          details.didNotificationLaunchApp &&
          notification != null) {
        return notification;
      }
      return null;
    } catch (error) {
      rethrow;
    }
  }

  @override
  Future<void> initializeSettings({
    required Function(Notification type) onNotificationSelected,
  }) async {
    try {
      await _localNotificationsService.initializeSettings(
        onNotificationSelected: (String? payload) {
          final Notification? notification = _getNotificationType(payload);
          if (notification != null) {
            onNotificationSelected(notification);
          }
        },
      );
    } catch (error) {
      rethrow;
    }
  }

  @override
  Future<void> setSessionNotification({
    required String sessionId,
    required Date date,
    required Time time,
    required String groupName,
    required Time sessionStartTime,
  }) async {
    try {
      final String startTimeHour = Utils.twoDigits(sessionStartTime.hour);
      final String startTimeMinute = Utils.twoDigits(sessionStartTime.minute);
      await _localNotificationsService.addNotification(
        id: sessionId.hashCode,
        body:
            'Masz zaplanowaną sesję z grupy $groupName na godzinę $startTimeHour:$startTimeMinute',
        date: DateTime(date.year, date.month, date.day, time.hour, time.minute),
        payload: 'session $sessionId',
      );
    } catch (error) {
      rethrow;
    }
  }

  @override
  Future<void> setDayStreakLoseNotification() async {
    //TODO
  }

  Notification? _getNotificationType(String? payload) {
    if (payload == null) {
      return null;
    }
    if (payload.contains('session')) {
      return SessionNotification(sessionId: payload.split(' ')[1]);
    } else if (payload == 'dayStreakLose') {
      return DayStreakLoseNotification();
    }
    return null;
  }
}

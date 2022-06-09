import 'package:fiszkomaniak/interfaces/sessions_notifications_interface.dart';
import 'package:fiszkomaniak/local_notifications/local_notifications_service.dart';
import '../models/date_model.dart';
import '../models/time_model.dart';
import '../utils/time_utils.dart';
import '../utils/utils.dart';

class SessionsNotificationsRepository
    implements SessionsNotificationsInterface {
  late final LocalNotificationsService _localNotificationsService;

  SessionsNotificationsRepository({
    required LocalNotificationsService localNotificationsService,
  }) {
    _localNotificationsService = localNotificationsService;
  }

  @override
  Future<void> setScheduledNotification({
    required String sessionId,
    required String groupName,
    required Date date,
    required Time time,
    required Time sessionStartTime,
  }) async {
    if (!TimeUtils.isPastTime(time, date) && !TimeUtils.isNow(time, date)) {
      final String startHour = Utils.twoDigits(sessionStartTime.hour);
      final String startMinute = Utils.twoDigits(sessionStartTime.minute);
      await _localNotificationsService.addNotification(
        id: sessionId.hashCode,
        body:
            'Masz zaplanowaną na dzisiaj sesję z grupy $groupName na godzinę $startHour:$startMinute',
        dateTime:
            DateTime(date.year, date.month, date.day, time.hour, time.minute),
        payload: 'session $sessionId',
      );
    }
  }

  @override
  Future<void> setDefaultNotification({
    required String sessionId,
    required String groupName,
    required Date date,
    required Time sessionStartTime,
  }) async {
    final time15minBefore = sessionStartTime.subtractMinutes(15);
    if (!TimeUtils.isPastTime(time15minBefore, date) &&
        !TimeUtils.isNow(time15minBefore, date)) {
      await _localNotificationsService.addNotification(
        id: '${sessionId}15MIN'.hashCode,
        body: 'Za 15 min wybije godzina rozpoczęcia sesji z grupy $groupName!',
        dateTime: DateTime(
          date.year,
          date.month,
          date.day,
          time15minBefore.hour,
          time15minBefore.minute,
        ),
        payload: 'session $sessionId',
      );
    }
  }

  @override
  Future<void> removeScheduledNotification({
    required String sessionId,
  }) async {
    await _localNotificationsService.cancelNotification(id: sessionId.hashCode);
  }

  @override
  Future<void> removeDefaultNotification({
    required String sessionId,
  }) async {
    await _localNotificationsService.cancelNotification(
      id: '${sessionId}15MIN'.hashCode,
    );
  }
}

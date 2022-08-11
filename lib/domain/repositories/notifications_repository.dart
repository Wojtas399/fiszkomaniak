import '../../interfaces/notifications_interface.dart';
import '../../local_notifications/local_notification_model.dart';
import '../../local_notifications/local_notifications_service.dart';
import '../../models/date_model.dart';
import '../../models/time_model.dart';
import '../../utils/time_utils.dart';
import '../../utils/utils.dart';
import '../entities/notification.dart';

class NotificationsRepository implements NotificationsInterface {
  late final LocalNotificationsService _localNotificationsService;
  late final TimeUtils _timeUtils;

  NotificationsRepository({
    required LocalNotificationsService localNotificationsService,
    required TimeUtils timeUtils,
  }) {
    _localNotificationsService = localNotificationsService;
    _timeUtils = timeUtils;
  }

  @override
  Stream<Notification?> get selectedNotification$ =>
      _localNotificationsService.selectedNotification$
          .map(_convertLocalNotificationToNotification);

  @override
  Future<Notification?> didNotificationLaunchApp() async {
    return _convertLocalNotificationToNotification(
      await _localNotificationsService.getLaunchDetails(),
    );
  }

  @override
  Future<void> initializeSettings() async {
    await _localNotificationsService.initializeSettings();
  }

  @override
  Future<void> setScheduledNotificationForSession({
    required String sessionId,
    required String groupName,
    required Date date,
    required Time time,
    required Time sessionStartTime,
  }) async {
    if (!_timeUtils.isPastTime(time, date) && !_timeUtils.isNow(time, date)) {
      final String startHour = Utils.twoDigits(sessionStartTime.hour);
      final String startMinute = Utils.twoDigits(sessionStartTime.minute);
      await _localNotificationsService.addScheduledNotificationForSession(
        sessionId: sessionId,
        groupName: groupName,
        startHour: startHour,
        startMinute: startMinute,
        dateTime: DateTime(
          date.year,
          date.month,
          date.day,
          time.hour,
          time.minute,
        ),
      );
    }
  }

  @override
  Future<void> setNotificationForSession15minBeforeStartTime({
    required String sessionId,
    required String groupName,
    required Date date,
    required Time sessionStartTime,
  }) async {
    final time15minBefore = sessionStartTime.subtractMinutes(15);
    if (!_timeUtils.isPastTime(time15minBefore, date) &&
        !_timeUtils.isNow(time15minBefore, date)) {
      await _localNotificationsService.addDefaultNotificationForSession(
        sessionId: sessionId,
        groupName: groupName,
        dateTime: DateTime(
          date.year,
          date.month,
          date.day,
          time15minBefore.hour,
          time15minBefore.minute,
        ),
      );
    }
  }

  @override
  Future<void> setLossOfDaysStreakNotification({required Date date}) async {
    await _localNotificationsService.addLossOfDaysStreakNotification(
      year: date.year,
      month: date.month,
      day: date.day,
    );
  }

  @override
  Future<void> deleteScheduledNotificationForSession({
    required String sessionId,
  }) async {
    await _localNotificationsService.cancelScheduledNotificationForSession(
      sessionId: sessionId,
    );
  }

  @override
  Future<void> deleteNotificationForSession15minBeforeStartTime({
    required String sessionId,
  }) async {
    await _localNotificationsService.cancelDefaultNotificationForSession(
      sessionId: sessionId,
    );
  }

  @override
  Future<void> deleteLossOfDaysStreakNotification() async {
    await _localNotificationsService.cancelLossOfDaysStreakNotification();
  }

  Notification? _convertLocalNotificationToNotification(
    LocalNotification? localNotification,
  ) {
    if (localNotification is LocalSessionNotification) {
      return SessionNotification(sessionId: localNotification.sessionId);
    } else if (localNotification is LocalLossOfDaysStreakNotification) {
      return DaysStreakLoseNotification();
    }
    return null;
  }
}

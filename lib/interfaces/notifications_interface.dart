import '../domain/entities/notification.dart';
import '../models/date_model.dart';
import '../models/time_model.dart';

abstract class NotificationsInterface {
  Stream<Notification?> get selectedNotification$;

  Future<Notification?> didNotificationLaunchApp();

  Future<void> initializeSettings();

  Future<void> setScheduledNotificationForSession({
    required String sessionId,
    required String groupName,
    required Date date,
    required Time time,
    required Time sessionStartTime,
  });

  Future<void> setDefaultNotificationForSession({
    required String sessionId,
    required String groupName,
    required Date date,
    required Time sessionStartTime,
  });

  Future<void> setLossOfDaysStreakNotification({required Date date});

  Future<void> deleteScheduledNotificationForSession({
    required String sessionId,
  });

  Future<void> deleteDefaultNotificationForSession({
    required String sessionId,
  });

  Future<void> deleteLossOfDaysStreakNotification();
}

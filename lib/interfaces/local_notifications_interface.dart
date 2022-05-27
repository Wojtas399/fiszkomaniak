import '../models/date_model.dart';
import '../models/notification_model.dart';
import '../models/time_model.dart';

abstract class LocalNotificationsInterface {
  Future<Notification?> didNotificationLaunchApp();

  Future<void> initializeSettings({
    required Function(Notification type) onNotificationSelected,
  });

  Future<void> setSessionNotification({
    required String sessionId,
    required Date date,
    required Time time,
    required String groupName,
    required Time sessionStartTime,
  });

  Future<void> setDayStreakLoseNotification();
}

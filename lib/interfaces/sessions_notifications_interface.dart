import '../models/date_model.dart';
import '../models/time_model.dart';

abstract class SessionsNotificationsInterface {
  Future<void> setScheduledNotification({
    required String sessionId,
    required String groupName,
    required Date date,
    required Time time,
    required Time sessionStartTime,
  });

  Future<void> setDefaultNotification({
    required String sessionId,
    required String groupName,
    required Date date,
    required Time sessionStartTime,
  });

  Future<void> removeScheduledNotification({required String sessionId});

  Future<void> removeDefaultNotification({required String sessionId});
}

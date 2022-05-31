import '../models/notification_model.dart';

abstract class NotificationsInterface {
  Future<Notification?> didNotificationLaunchApp();

  Future<void> initializeSettings({
    required Function(Notification type) onNotificationSelected,
  });
}

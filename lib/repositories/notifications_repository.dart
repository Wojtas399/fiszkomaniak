import 'package:fiszkomaniak/firebase/fire_extensions.dart';
import 'package:fiszkomaniak/interfaces/notifications_interface.dart';
import 'package:fiszkomaniak/local_notifications/local_notifications_service.dart';
import 'package:fiszkomaniak/models/notification_model.dart';

class NotificationsRepository implements NotificationsInterface {
  late final LocalNotificationsService _localNotificationsService;

  NotificationsRepository({
    required LocalNotificationsService localNotificationsService,
  }) {
    _localNotificationsService = localNotificationsService;
  }

  @override
  Future<Notification?> didNotificationLaunchApp() async {
    final details = await _localNotificationsService.getLaunchDetails();
    final notification = details?.payload?.convertToNotification();
    if (details != null &&
        details.didNotificationLaunchApp &&
        notification != null) {
      return notification;
    }
    return null;
  }

  @override
  Future<void> initializeSettings({
    required Function(Notification type) onNotificationSelected,
  }) async {
    await _localNotificationsService.initializeSettings(
      onNotificationSelected: (String? payload) {
        final Notification? notification = payload?.convertToNotification();
        if (notification != null) {
          onNotificationSelected(notification);
        }
      },
    );
  }
}

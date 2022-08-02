import '../../../interfaces/notifications_interface.dart';
import '../../entities/notification.dart';

class DidNotificationLaunchAppUseCase {
  late final NotificationsInterface _notificationsInterface;

  DidNotificationLaunchAppUseCase({
    required NotificationsInterface notificationsInterface,
  }) {
    _notificationsInterface = notificationsInterface;
  }

  Future<Notification?> execute() async {
    return await _notificationsInterface.didNotificationLaunchApp();
  }
}

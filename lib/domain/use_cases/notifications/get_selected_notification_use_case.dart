import '../../../interfaces/notifications_interface.dart';
import '../../entities/notification.dart';

class GetSelectedNotificationUseCase {
  late final NotificationsInterface _notificationsInterface;

  GetSelectedNotificationUseCase({
    required NotificationsInterface notificationsInterface,
  }) {
    _notificationsInterface = notificationsInterface;
  }

  Stream<Notification?> execute() {
    return _notificationsInterface.selectedNotification$;
  }
}

import '../interfaces/notifications_interface.dart';
import '../local_notifications/local_notifications_service.dart';
import '../domain/repositories/notifications_repository.dart';
import '../utils/time_utils.dart';

class NotificationsProvider {
  static NotificationsInterface provideNotificationsInterface() {
    return NotificationsRepository(
      localNotificationsService: LocalNotificationsService(),
      timeUtils: TimeUtils(),
    );
  }
}

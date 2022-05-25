import 'package:fiszkomaniak/interfaces/notifications_interface.dart';
import 'package:fiszkomaniak/notifications/notifications_service.dart';
import 'package:fiszkomaniak/repositories/notifications_repository.dart';

class NotificationsProvider {
  static NotificationsInterface provide() {
    return NotificationsRepository(
      notificationsService: NotificationsService(),
    );
  }
}

import 'package:fiszkomaniak/interfaces/local_notifications_interface.dart';
import 'package:fiszkomaniak/local_notifications/local_notifications_service.dart';
import 'package:fiszkomaniak/repositories/local_notifications_repository.dart';

class LocalNotificationsProvider {
  static LocalNotificationsInterface provide() {
    return LocalNotificationsRepository(
      localNotificationsService: LocalNotificationsService(),
    );
  }
}

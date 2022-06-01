import 'package:fiszkomaniak/interfaces/achievements_notifications_interface.dart';
import 'package:fiszkomaniak/interfaces/notifications_interface.dart';
import 'package:fiszkomaniak/interfaces/sessions_notifications_interface.dart';
import 'package:fiszkomaniak/local_notifications/local_notifications_service.dart';
import 'package:fiszkomaniak/repositories/achievements_notifications_repository.dart';
import 'package:fiszkomaniak/repositories/notifications_repository.dart';
import 'package:fiszkomaniak/repositories/sessions_notifications_repository.dart';

class NotificationsProvider {
  static NotificationsInterface provideNotificationsInterface() {
    return NotificationsRepository(
      localNotificationsService: LocalNotificationsService(),
    );
  }

  static SessionsNotificationsInterface
      provideSessionsNotificationsInterface() {
    return SessionsNotificationsRepository(
      localNotificationsService: LocalNotificationsService(),
    );
  }

  static AchievementsNotificationsInterface
      provideAchievementsNotificationsInterface() {
    return AchievementsNotificationsRepository(
      localNotificationsService: LocalNotificationsService(),
    );
  }
}

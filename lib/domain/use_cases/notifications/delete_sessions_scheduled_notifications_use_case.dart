import '../../../domain/entities/session.dart';
import '../../../interfaces/sessions_interface.dart';
import '../../../interfaces/notifications_interface.dart';

class DeleteSessionsScheduledNotificationsUseCase {
  late final SessionsInterface _sessionsInterface;
  late final NotificationsInterface _notificationsInterface;

  DeleteSessionsScheduledNotificationsUseCase({
    required SessionsInterface sessionsInterface,
    required NotificationsInterface notificationsInterface,
  }) {
    _sessionsInterface = sessionsInterface;
    _notificationsInterface = notificationsInterface;
  }

  Future<void> execute() async {
    final List<Session> sessions = await _sessionsInterface.allSessions$.first;
    for (final Session session in sessions) {
      if (session.notificationTime != null) {
        await _notificationsInterface.deleteScheduledNotificationForSession(
          sessionId: session.id,
        );
      }
    }
  }
}

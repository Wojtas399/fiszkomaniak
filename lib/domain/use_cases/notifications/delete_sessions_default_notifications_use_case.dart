import '../../../domain/entities/session.dart';
import '../../../interfaces/sessions_interface.dart';
import '../../../interfaces/notifications_interface.dart';

class DeleteSessionsDefaultNotificationsUseCase {
  late final SessionsInterface _sessionsInterface;
  late final NotificationsInterface _notificationsInterface;

  DeleteSessionsDefaultNotificationsUseCase({
    required SessionsInterface sessionsInterface,
    required NotificationsInterface notificationsInterface,
  }) {
    _sessionsInterface = sessionsInterface;
    _notificationsInterface = notificationsInterface;
  }

  Future<void> execute() async {
    final List<Session> sessions = await _sessionsInterface.allSessions$.first;
    for (final Session session in sessions) {
      await _notificationsInterface.deleteDefaultNotificationForSession(
        sessionId: session.id,
      );
    }
  }
}

import '../../../interfaces/sessions_interface.dart';
import '../../../interfaces/notifications_interface.dart';

class DeleteSessionUseCase {
  late final SessionsInterface _sessionsInterface;
  late final NotificationsInterface _notificationsInterface;

  DeleteSessionUseCase({
    required SessionsInterface sessionsInterface,
    required NotificationsInterface notificationsInterface,
  }) {
    _sessionsInterface = sessionsInterface;
    _notificationsInterface = notificationsInterface;
  }

  Future<void> execute({required String sessionId}) async {
    await _sessionsInterface.removeSession(sessionId);
    await _notificationsInterface.deleteDefaultNotificationForSession(
      sessionId: sessionId,
    );
    await _notificationsInterface.deleteScheduledNotificationForSession(
      sessionId: sessionId,
    );
  }
}

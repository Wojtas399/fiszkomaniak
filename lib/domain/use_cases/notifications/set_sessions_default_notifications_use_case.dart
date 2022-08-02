import '../../../domain/entities/session.dart';
import '../../../interfaces/groups_interface.dart';
import '../../../interfaces/sessions_interface.dart';
import '../../../interfaces/notifications_interface.dart';

class SetSessionsDefaultNotificationsUseCase {
  late final SessionsInterface _sessionsInterface;
  late final GroupsInterface _groupsInterface;
  late final NotificationsInterface _notificationsInterface;

  SetSessionsDefaultNotificationsUseCase({
    required SessionsInterface sessionsInterface,
    required GroupsInterface groupsInterface,
    required NotificationsInterface notificationsInterface,
  }) {
    _sessionsInterface = sessionsInterface;
    _groupsInterface = groupsInterface;
    _notificationsInterface = notificationsInterface;
  }

  Future<void> execute() async {
    final List<Session> allSessions =
        await _sessionsInterface.allSessions$.first;
    for (final Session session in allSessions) {
      final String groupName =
          await _groupsInterface.getGroupName(groupId: session.groupId).first;
      await _notificationsInterface.setDefaultNotificationForSession(
        sessionId: session.id,
        groupName: groupName,
        date: session.date,
        sessionStartTime: session.startTime,
      );
    }
  }
}

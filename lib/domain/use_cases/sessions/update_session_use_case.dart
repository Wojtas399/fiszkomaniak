import '../../../domain/entities/settings.dart';
import '../../../domain/entities/session.dart';
import '../../../interfaces/notifications_interface.dart';
import '../../../interfaces/settings_interface.dart';
import '../../../interfaces/sessions_interface.dart';
import '../../../interfaces/groups_interface.dart';
import '../../../models/date_model.dart';
import '../../../models/time_model.dart';

class UpdateSessionUseCase {
  late final SessionsInterface _sessionsInterface;
  late final GroupsInterface _groupsInterface;
  late final NotificationsInterface _notificationsInterface;
  late final SettingsInterface _settingsInterface;

  UpdateSessionUseCase({
    required SessionsInterface sessionsInterface,
    required GroupsInterface groupsInterface,
    required NotificationsInterface notificationsInterface,
    required SettingsInterface settingsInterface,
  }) {
    _sessionsInterface = sessionsInterface;
    _groupsInterface = groupsInterface;
    _notificationsInterface = notificationsInterface;
    _settingsInterface = settingsInterface;
  }

  Future<void> execute({
    required String sessionId,
    String? groupId,
    FlashcardsType? flashcardsType,
    bool? areQuestionsAndAnswersSwapped,
    Date? date,
    Time? startTime,
    Duration? duration,
    Time? notificationTime,
  }) async {
    final Session? updatedSession = await _sessionsInterface.updateSession(
      sessionId: sessionId,
      groupId: groupId,
      flashcardsType: flashcardsType,
      areQuestionsAndAnswersSwapped: areQuestionsAndAnswersSwapped,
      date: date,
      startTime: startTime,
      duration: duration,
      notificationTime: notificationTime,
    );
    if (updatedSession != null) {
      final NotificationsSettings notificationsSettings =
          await _settingsInterface.notificationsSettings$.first;
      final String groupName = await _groupsInterface
          .getGroupName(groupId: updatedSession.groupId)
          .first;
      if (notificationsSettings.areSessionsDefaultNotificationsOn) {
        await _notificationsInterface.setDefaultNotificationForSession(
          sessionId: sessionId,
          groupName: groupName,
          date: updatedSession.date,
          sessionStartTime: updatedSession.startTime,
        );
      }
      final Time? notificationTime = updatedSession.notificationTime;
      if (notificationTime != null &&
          notificationsSettings.areSessionsScheduledNotificationsOn) {
        await _notificationsInterface.setScheduledNotificationForSession(
          sessionId: sessionId,
          groupName: groupName,
          date: updatedSession.date,
          time: notificationTime,
          sessionStartTime: updatedSession.startTime,
        );
      }
    }
  }
}

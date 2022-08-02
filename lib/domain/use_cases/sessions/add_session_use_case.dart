import '../../../domain/entities/notifications_settings.dart';
import '../../../domain/entities/session.dart';
import '../../../interfaces/groups_interface.dart';
import '../../../interfaces/notifications_settings_interface.dart';
import '../../../interfaces/sessions_interface.dart';
import '../../../interfaces/notifications_interface.dart';
import '../../../models/date_model.dart';
import '../../../models/time_model.dart';

class AddSessionUseCase {
  late final SessionsInterface _sessionsInterface;
  late final GroupsInterface _groupsInterface;
  late final NotificationsInterface _notificationsInterface;
  late final NotificationsSettingsInterface _notificationsSettingsInterface;

  AddSessionUseCase({
    required SessionsInterface sessionsInterface,
    required GroupsInterface groupsInterface,
    required NotificationsInterface notificationsInterface,
    required NotificationsSettingsInterface notificationsSettingsInterface,
  }) {
    _sessionsInterface = sessionsInterface;
    _groupsInterface = groupsInterface;
    _notificationsInterface = notificationsInterface;
    _notificationsSettingsInterface = notificationsSettingsInterface;
  }

  Future<void> execute({
    required String groupId,
    required FlashcardsType flashcardsType,
    required bool areQuestionsAndAnswersSwapped,
    required Date date,
    required Time startTime,
    required Duration? duration,
    required Time? notificationTime,
  }) async {
    final String? sessionId = await _sessionsInterface.addNewSession(
      groupId: groupId,
      flashcardsType: flashcardsType,
      areQuestionsAndAnswersSwapped: areQuestionsAndAnswersSwapped,
      date: date,
      startTime: startTime,
      duration: duration,
      notificationTime: notificationTime,
    );
    if (sessionId != null) {
      final NotificationsSettings notificationsSettings =
          await _notificationsSettingsInterface.notificationsSettings$.first;
      final String groupName =
          await _groupsInterface.getGroupName(groupId: groupId).first;
      if (notificationsSettings.areSessionsDefaultNotificationsOn) {
        await _notificationsInterface.setDefaultNotificationForSession(
          sessionId: sessionId,
          groupName: groupName,
          date: date,
          sessionStartTime: startTime,
        );
      }
      if (notificationTime != null &&
          notificationsSettings.areSessionsPlannedNotificationsOn) {
        await _notificationsInterface.setScheduledNotificationForSession(
          sessionId: sessionId,
          groupName: groupName,
          date: date,
          time: notificationTime,
          sessionStartTime: startTime,
        );
      }
    }
  }
}

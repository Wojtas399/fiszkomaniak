import '../../../domain/entities/session.dart';
import '../../../domain/entities/settings.dart';
import '../../../interfaces/groups_interface.dart';
import '../../../interfaces/notifications_interface.dart';
import '../../../interfaces/sessions_interface.dart';
import '../../../interfaces/settings_interface.dart';
import '../../../models/date_model.dart';
import '../../../models/time_model.dart';

class AddSessionUseCase {
  late final SessionsInterface _sessionsInterface;
  late final GroupsInterface _groupsInterface;
  late final NotificationsInterface _notificationsInterface;
  late final SettingsInterface _settingsInterface;

  AddSessionUseCase({
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
          await _settingsInterface.notificationsSettings$.first;
      final String groupName =
          await _groupsInterface.getGroupName(groupId: groupId).first;
      if (notificationsSettings.areSessionsDefaultNotificationsOn) {
        await _notificationsInterface
            .setNotificationForSession15minBeforeStartTime(
          sessionId: sessionId,
          groupName: groupName,
          date: date,
          sessionStartTime: startTime,
        );
      }
      if (notificationTime != null &&
          notificationsSettings.areSessionsScheduledNotificationsOn) {
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

import '../../../domain/entities/settings.dart';
import '../../../domain/entities/session.dart';
import '../../../interfaces/notifications_interface.dart';
import '../../../interfaces/settings_interface.dart';
import '../../../interfaces/sessions_interface.dart';
import '../../../interfaces/groups_interface.dart';
import '../../../models/date_model.dart';
import '../../../models/time_model.dart';
import '../../../utils/time_utils.dart';

class UpdateSessionUseCase {
  late final SessionsInterface _sessionsInterface;
  late final GroupsInterface _groupsInterface;
  late final NotificationsInterface _notificationsInterface;
  late final SettingsInterface _settingsInterface;
  late final TimeUtils _timeUtils;

  UpdateSessionUseCase({
    required SessionsInterface sessionsInterface,
    required GroupsInterface groupsInterface,
    required NotificationsInterface notificationsInterface,
    required SettingsInterface settingsInterface,
    required TimeUtils timeUtils,
  }) {
    _sessionsInterface = sessionsInterface;
    _groupsInterface = groupsInterface;
    _notificationsInterface = notificationsInterface;
    _settingsInterface = settingsInterface;
    _timeUtils = timeUtils;
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
      await _manageDefaultNotification(
        areSessionsDefaultNotificationsOn:
            notificationsSettings.areSessionsDefaultNotificationsOn,
        sessionId: sessionId,
        groupName: groupName,
        date: updatedSession.date,
        sessionStartTime: updatedSession.startTime,
      );
      await _manageScheduledNotification(
        areSessionsScheduledNotificationsOn:
            notificationsSettings.areSessionsScheduledNotificationsOn,
        time: updatedSession.notificationTime,
        sessionId: sessionId,
        groupName: groupName,
        date: updatedSession.date,
        sessionStartTime: updatedSession.startTime,
      );
    }
  }

  Future<void> _manageDefaultNotification({
    required bool areSessionsDefaultNotificationsOn,
    required String sessionId,
    required String groupName,
    required Date date,
    required Time sessionStartTime,
  }) async {
    final Time time15minBefore = sessionStartTime.subtractMinutes(15);
    if (_timeUtils.isPastTime(time15minBefore, date) ||
        _timeUtils.isNow(time15minBefore, date)) {
      await _notificationsInterface
          .deleteNotificationForSession15minBeforeStartTime(
        sessionId: sessionId,
      );
    } else if (areSessionsDefaultNotificationsOn) {
      await _notificationsInterface
          .setNotificationForSession15minBeforeStartTime(
        sessionId: sessionId,
        groupName: groupName,
        date: date,
        sessionStartTime: sessionStartTime,
      );
    }
  }

  Future<void> _manageScheduledNotification({
    required bool areSessionsScheduledNotificationsOn,
    required Time? time,
    required String sessionId,
    required String groupName,
    required Date date,
    required Time sessionStartTime,
  }) async {
    if (time != null && areSessionsScheduledNotificationsOn) {
      await _notificationsInterface.setScheduledNotificationForSession(
        sessionId: sessionId,
        groupName: groupName,
        date: date,
        time: time,
        sessionStartTime: sessionStartTime,
      );
    } else {
      await _notificationsInterface.deleteScheduledNotificationForSession(
        sessionId: sessionId,
      );
    }
  }
}

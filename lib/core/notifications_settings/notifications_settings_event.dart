abstract class NotificationsSettingsEvent {}

class NotificationsSettingsEventLoad extends NotificationsSettingsEvent {}

class NotificationsSettingsEventUpdate extends NotificationsSettingsEvent {
  final bool? areSessionsPlannedNotificationsOn;
  final bool? areSessionsDefaultNotificationsOn;
  final bool? areAchievementsNotificationsOn;
  final bool? areLossOfDaysNotificationsOn;

  NotificationsSettingsEventUpdate({
    required this.areSessionsPlannedNotificationsOn,
    required this.areSessionsDefaultNotificationsOn,
    required this.areAchievementsNotificationsOn,
    required this.areLossOfDaysNotificationsOn,
  });
}

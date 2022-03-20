abstract class NotificationsSettingsEvent {}

class NotificationsSettingsEventLoad extends NotificationsSettingsEvent {}

class NotificationsSettingsEventUpdate extends NotificationsSettingsEvent {
  final bool? areSessionsPlannedNotificationsOn;
  final bool? areSessionsDefaultNotificationsOn;
  final bool? areAchievementsNotificationsOn;
  final bool? areLossOfDaysNotificationsOn;

  NotificationsSettingsEventUpdate({
    this.areSessionsPlannedNotificationsOn,
    this.areSessionsDefaultNotificationsOn,
    this.areAchievementsNotificationsOn,
    this.areLossOfDaysNotificationsOn,
  });
}

part of 'notifications_settings_bloc.dart';

abstract class NotificationsSettingsEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class NotificationsSettingsEventLoad extends NotificationsSettingsEvent {}

class NotificationsSettingsEventUpdate extends NotificationsSettingsEvent {
  final bool? areSessionsPlannedNotificationsOn;
  final bool? areSessionsDefaultNotificationsOn;
  final bool? areAchievementsNotificationsOn;
  final bool? areDaysStreakLoseNotificationsOn;

  NotificationsSettingsEventUpdate({
    this.areSessionsPlannedNotificationsOn,
    this.areSessionsDefaultNotificationsOn,
    this.areAchievementsNotificationsOn,
    this.areDaysStreakLoseNotificationsOn,
  });

  @override
  List<Object> get props => [
        areSessionsPlannedNotificationsOn ?? false,
        areSessionsDefaultNotificationsOn ?? false,
        areAchievementsNotificationsOn ?? false,
        areDaysStreakLoseNotificationsOn ?? false,
      ];
}

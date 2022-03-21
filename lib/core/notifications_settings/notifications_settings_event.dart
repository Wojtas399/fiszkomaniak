import 'package:equatable/equatable.dart';

abstract class NotificationsSettingsEvent extends Equatable {
  @override
  List<Object> get props => [];
}

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

  @override
  List<Object> get props => [
        areSessionsPlannedNotificationsOn ?? false,
        areSessionsDefaultNotificationsOn ?? false,
        areAchievementsNotificationsOn ?? false,
        areLossOfDaysNotificationsOn ?? false,
      ];
}

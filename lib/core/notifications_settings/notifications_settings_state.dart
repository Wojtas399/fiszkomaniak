part of 'notifications_settings_bloc.dart';

class NotificationsSettingsState extends NotificationsSettings {
  final InitializationStatus initializationStatus;
  final HttpStatus httpStatus;

  const NotificationsSettingsState({
    this.initializationStatus = InitializationStatus.loading,
    bool areSessionsPlannedNotificationsOn = false,
    bool areSessionsDefaultNotificationsOn = false,
    bool areAchievementsNotificationsOn = false,
    bool areDaysStreakLoseNotificationsOn = false,
    this.httpStatus = const HttpStatusInitial(),
  }) : super(
          areSessionsPlannedNotificationsOn: areSessionsPlannedNotificationsOn,
          areSessionsDefaultNotificationsOn: areSessionsDefaultNotificationsOn,
          areAchievementsNotificationsOn: areAchievementsNotificationsOn,
          areDaysStreakLoseNotificationsOn: areDaysStreakLoseNotificationsOn,
        );

  NotificationsSettingsState copyWith({
    InitializationStatus? initializationStatus,
    bool? areSessionsPlannedNotificationsOn,
    bool? areSessionsDefaultNotificationsOn,
    bool? areAchievementsNotificationsOn,
    bool? areDaysStreakLoseNotificationsOn,
    HttpStatus? httpStatus,
  }) {
    return NotificationsSettingsState(
      initializationStatus: initializationStatus ?? this.initializationStatus,
      areSessionsPlannedNotificationsOn: areSessionsPlannedNotificationsOn ??
          this.areSessionsPlannedNotificationsOn,
      areSessionsDefaultNotificationsOn: areSessionsDefaultNotificationsOn ??
          this.areSessionsDefaultNotificationsOn,
      areAchievementsNotificationsOn:
          areAchievementsNotificationsOn ?? this.areAchievementsNotificationsOn,
      areDaysStreakLoseNotificationsOn: areDaysStreakLoseNotificationsOn ??
          this.areDaysStreakLoseNotificationsOn,
      httpStatus: httpStatus ?? const HttpStatusInitial(),
    );
  }

  @override
  List<Object> get props => [
        initializationStatus,
        areSessionsPlannedNotificationsOn,
        areSessionsDefaultNotificationsOn,
        areAchievementsNotificationsOn,
        areDaysStreakLoseNotificationsOn,
        httpStatus,
      ];
}

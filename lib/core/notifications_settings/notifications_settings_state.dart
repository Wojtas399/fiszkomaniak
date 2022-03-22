import 'package:fiszkomaniak/models/http_status_model.dart';
import 'package:fiszkomaniak/models/settings/notifications_settings_model.dart';

class NotificationsSettingsState extends NotificationsSettings {
  final HttpStatus httpStatus;

  const NotificationsSettingsState({
    bool areSessionsPlannedNotificationsOn = false,
    bool areSessionsDefaultNotificationsOn = false,
    bool areAchievementsNotificationsOn = false,
    bool areLossOfDaysNotificationsOn = false,
    this.httpStatus = const HttpStatusInitial(),
  }) : super(
          areSessionsPlannedNotificationsOn: areSessionsPlannedNotificationsOn,
          areSessionsDefaultNotificationsOn: areSessionsDefaultNotificationsOn,
          areAchievementsNotificationsOn: areAchievementsNotificationsOn,
          areLossOfDaysNotificationsOn: areLossOfDaysNotificationsOn,
        );

  NotificationsSettingsState copyWith({
    bool? areSessionsPlannedNotificationsOn,
    bool? areSessionsDefaultNotificationsOn,
    bool? areAchievementsNotificationsOn,
    bool? areLossOfDaysNotificationsOn,
    HttpStatus? httpStatus,
  }) {
    return NotificationsSettingsState(
      areSessionsPlannedNotificationsOn: areSessionsPlannedNotificationsOn ??
          this.areSessionsPlannedNotificationsOn,
      areSessionsDefaultNotificationsOn: areSessionsDefaultNotificationsOn ??
          this.areSessionsDefaultNotificationsOn,
      areAchievementsNotificationsOn:
          areAchievementsNotificationsOn ?? this.areAchievementsNotificationsOn,
      areLossOfDaysNotificationsOn:
          areLossOfDaysNotificationsOn ?? this.areLossOfDaysNotificationsOn,
      httpStatus: httpStatus ?? const HttpStatusInitial(),
    );
  }

  @override
  List<Object> get props => [
        areSessionsPlannedNotificationsOn,
        areSessionsDefaultNotificationsOn,
        areAchievementsNotificationsOn,
        areLossOfDaysNotificationsOn,
        httpStatus,
      ];
}

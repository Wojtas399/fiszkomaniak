import 'package:equatable/equatable.dart';

class NotificationsSettings extends Equatable {
  final bool areSessionsPlannedNotificationsOn;
  final bool areSessionsDefaultNotificationsOn;
  final bool areAchievementsNotificationsOn;
  final bool areLossOfDaysNotificationsOn;

  const NotificationsSettings({
    required this.areSessionsPlannedNotificationsOn,
    required this.areSessionsDefaultNotificationsOn,
    required this.areAchievementsNotificationsOn,
    required this.areLossOfDaysNotificationsOn,
  });

  @override
  List<Object> get props => [
        areSessionsPlannedNotificationsOn,
        areSessionsDefaultNotificationsOn,
        areAchievementsNotificationsOn,
        areLossOfDaysNotificationsOn,
      ];
}

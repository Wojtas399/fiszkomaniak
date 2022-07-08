import 'package:equatable/equatable.dart';

class NotificationsSettings extends Equatable {
  final bool areSessionsPlannedNotificationsOn;
  final bool areSessionsDefaultNotificationsOn;
  final bool areAchievementsNotificationsOn;
  final bool areLossOfDaysStreakNotificationsOn;

  const NotificationsSettings({
    required this.areSessionsPlannedNotificationsOn,
    required this.areSessionsDefaultNotificationsOn,
    required this.areAchievementsNotificationsOn,
    required this.areLossOfDaysStreakNotificationsOn,
  });

  @override
  List<Object> get props => [
        areSessionsPlannedNotificationsOn,
        areSessionsDefaultNotificationsOn,
        areAchievementsNotificationsOn,
        areLossOfDaysStreakNotificationsOn,
      ];
}

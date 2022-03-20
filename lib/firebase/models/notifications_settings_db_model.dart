class NotificationsSettingsDbModel {
  final bool? areSessionsPlannedNotificationsOn;
  final bool? areSessionsDefaultNotificationsOn;
  final bool? areAchievementsNotificationsOn;
  final bool? areLossOfDaysNotificationsOn;

  NotificationsSettingsDbModel({
    this.areSessionsPlannedNotificationsOn,
    this.areSessionsDefaultNotificationsOn,
    this.areAchievementsNotificationsOn,
    this.areLossOfDaysNotificationsOn,
  });

  NotificationsSettingsDbModel.fromJson(Map<String, Object?> json)
      : this(
          areSessionsPlannedNotificationsOn:
              json['areSessionsPlannedNotificationsOn']! as bool,
          areSessionsDefaultNotificationsOn:
              json['areSessionsDefaultNotificationsOn']! as bool,
          areAchievementsNotificationsOn:
              json['areAchievementsNotificationsOn']! as bool,
          areLossOfDaysNotificationsOn:
              json['areLossOfDaysNotificationsOn']! as bool,
        );

  Map<String, bool?> toJson() {
    Map<String, bool?> params = {
      'areSessionsPlannedNotificationsOn': areSessionsPlannedNotificationsOn,
      'areSessionsDefaultNotificationsOn': areSessionsDefaultNotificationsOn,
      'areAchievementsNotificationsOn': areAchievementsNotificationsOn,
      'areLossOfDaysNotificationsOn': areLossOfDaysNotificationsOn,
    }..removeWhere((key, value) => value == null);
    return params;
  }
}

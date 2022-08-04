class NotificationsSettingsDbModel {
  final bool? areSessionsScheduledNotificationsOn;
  final bool? areSessionsDefaultNotificationsOn;
  final bool? areAchievementsNotificationsOn;
  final bool? areLossOfDaysNotificationsOn;

  NotificationsSettingsDbModel({
    this.areSessionsScheduledNotificationsOn,
    this.areSessionsDefaultNotificationsOn,
    this.areAchievementsNotificationsOn,
    this.areLossOfDaysNotificationsOn,
  });

  NotificationsSettingsDbModel.fromJson(Map<String, Object?> json)
      : this(
          areSessionsScheduledNotificationsOn:
              json['areSessionsScheduledNotificationsOn']! as bool,
          areSessionsDefaultNotificationsOn:
              json['areSessionsDefaultNotificationsOn']! as bool,
          areAchievementsNotificationsOn:
              json['areAchievementsNotificationsOn']! as bool,
          areLossOfDaysNotificationsOn:
              json['areLossOfDaysNotificationsOn']! as bool,
        );

  Map<String, bool?> toJson() {
    Map<String, bool?> params = {
      'areSessionsScheduledNotificationsOn':
          areSessionsScheduledNotificationsOn,
      'areSessionsDefaultNotificationsOn': areSessionsDefaultNotificationsOn,
      'areAchievementsNotificationsOn': areAchievementsNotificationsOn,
      'areLossOfDaysNotificationsOn': areLossOfDaysNotificationsOn,
    }..removeWhere((key, value) => value == null);
    return params;
  }
}

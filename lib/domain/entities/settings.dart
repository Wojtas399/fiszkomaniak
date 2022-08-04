import 'package:equatable/equatable.dart';

class Settings extends Equatable {
  final AppearanceSettings appearanceSettings;
  final NotificationsSettings notificationsSettings;

  const Settings({
    required this.appearanceSettings,
    required this.notificationsSettings,
  });

  @override
  List<Object> get props => [
        appearanceSettings,
        notificationsSettings,
      ];

  Settings copyWith({
    AppearanceSettings? appearanceSettings,
    NotificationsSettings? notificationsSettings,
  }) {
    return Settings(
      appearanceSettings: appearanceSettings ?? this.appearanceSettings,
      notificationsSettings:
          notificationsSettings ?? this.notificationsSettings,
    );
  }
}

class AppearanceSettings extends Equatable {
  final bool isDarkModeOn;
  final bool isDarkModeCompatibilityWithSystemOn;
  final bool isSessionTimerInvisibilityOn;

  const AppearanceSettings({
    required this.isDarkModeOn,
    required this.isDarkModeCompatibilityWithSystemOn,
    required this.isSessionTimerInvisibilityOn,
  });

  @override
  List<Object> get props => [
        isDarkModeOn,
        isDarkModeCompatibilityWithSystemOn,
        isSessionTimerInvisibilityOn,
      ];

  AppearanceSettings copyWith({
    bool? isDarkModeOn,
    bool? isDarkModeCompatibilityWithSystemOn,
    bool? isSessionTimerInvisibilityOn,
  }) {
    return AppearanceSettings(
      isDarkModeOn: isDarkModeOn ?? this.isDarkModeOn,
      isDarkModeCompatibilityWithSystemOn:
          isDarkModeCompatibilityWithSystemOn ??
              this.isDarkModeCompatibilityWithSystemOn,
      isSessionTimerInvisibilityOn:
          isSessionTimerInvisibilityOn ?? this.isSessionTimerInvisibilityOn,
    );
  }
}

class NotificationsSettings extends Equatable {
  final bool areSessionsScheduledNotificationsOn;
  final bool areSessionsDefaultNotificationsOn;
  final bool areAchievementsNotificationsOn;
  final bool areLossOfDaysStreakNotificationsOn;

  const NotificationsSettings({
    required this.areSessionsScheduledNotificationsOn,
    required this.areSessionsDefaultNotificationsOn,
    required this.areAchievementsNotificationsOn,
    required this.areLossOfDaysStreakNotificationsOn,
  });

  @override
  List<Object> get props => [
        areSessionsScheduledNotificationsOn,
        areSessionsDefaultNotificationsOn,
        areAchievementsNotificationsOn,
        areLossOfDaysStreakNotificationsOn,
      ];

  NotificationsSettings copyWith({
    bool? areSessionsScheduledNotificationsOn,
    bool? areSessionsDefaultNotificationsOn,
    bool? areAchievementsNotificationsOn,
    bool? areLossOfDaysStreakNotificationsOn,
  }) {
    return NotificationsSettings(
      areSessionsScheduledNotificationsOn:
          areSessionsScheduledNotificationsOn ??
              this.areSessionsScheduledNotificationsOn,
      areSessionsDefaultNotificationsOn: areSessionsDefaultNotificationsOn ??
          this.areSessionsDefaultNotificationsOn,
      areAchievementsNotificationsOn:
          areAchievementsNotificationsOn ?? this.areAchievementsNotificationsOn,
      areLossOfDaysStreakNotificationsOn: areLossOfDaysStreakNotificationsOn ??
          this.areLossOfDaysStreakNotificationsOn,
    );
  }
}

Settings createSettings({
  AppearanceSettings? appearanceSettings,
  NotificationsSettings? notificationsSettings,
}) {
  return Settings(
    appearanceSettings: appearanceSettings ?? createAppearanceSettings(),
    notificationsSettings: notificationsSettings ?? createNotificationsSettings(),
  );
}

AppearanceSettings createAppearanceSettings({
  bool isDarkModeOn = false,
  bool isDarkModeCompatibilityWithSystemOn = false,
  bool isSessionTimerInvisibilityOn = false,
}) {
  return AppearanceSettings(
    isDarkModeOn: isDarkModeOn,
    isDarkModeCompatibilityWithSystemOn: isDarkModeCompatibilityWithSystemOn,
    isSessionTimerInvisibilityOn: isSessionTimerInvisibilityOn,
  );
}

NotificationsSettings createNotificationsSettings({
  bool areSessionsScheduledNotificationsOn = false,
  bool areSessionsDefaultNotificationsOn = false,
  bool areAchievementsNotificationsOn = false,
  bool areLossOfDaysStreakNotificationsOn = false,
}) {
  return NotificationsSettings(
    areSessionsScheduledNotificationsOn: areSessionsScheduledNotificationsOn,
    areSessionsDefaultNotificationsOn: areSessionsDefaultNotificationsOn,
    areAchievementsNotificationsOn: areAchievementsNotificationsOn,
    areLossOfDaysStreakNotificationsOn: areLossOfDaysStreakNotificationsOn,
  );
}

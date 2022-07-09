part of 'settings_bloc.dart';

abstract class SettingsEvent {}

class SettingsEventInitialize extends SettingsEvent {}

class SettingsEventAppearanceSettingsUpdated extends SettingsEvent {
  final AppearanceSettings appearanceSettings;

  SettingsEventAppearanceSettingsUpdated({required this.appearanceSettings});
}

class SettingsEventNotificationsSettingsUpdated extends SettingsEvent {
  final NotificationsSettings notificationsSettings;

  SettingsEventNotificationsSettingsUpdated({
    required this.notificationsSettings,
  });
}

class SettingsEventAppearanceSettingsChanged extends SettingsEvent {
  final bool? isDarkModeOn;
  final bool? isDarkModeCompatibilityWithSystemOn;
  final bool? isSessionTimerInvisibilityOn;

  SettingsEventAppearanceSettingsChanged({
    this.isDarkModeOn,
    this.isDarkModeCompatibilityWithSystemOn,
    this.isSessionTimerInvisibilityOn,
  });
}

class SettingsEventNotificationsSettingsChanged extends SettingsEvent {
  final bool? areSessionsPlannedNotificationsOn;
  final bool? areSessionsDefaultNotificationsOn;
  final bool? areAchievementsNotificationsOn;
  final bool? areLossOfDaysStreakNotificationsOn;

  SettingsEventNotificationsSettingsChanged({
    this.areSessionsPlannedNotificationsOn,
    this.areSessionsDefaultNotificationsOn,
    this.areAchievementsNotificationsOn,
    this.areLossOfDaysStreakNotificationsOn,
  });
}

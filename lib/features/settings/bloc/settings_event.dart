part of 'settings_bloc.dart';

abstract class SettingsEvent {}

class SettingsEventInitialize extends SettingsEvent {}

class SettingsEventSettingsUpdated extends SettingsEvent {
  final Settings settings;

  SettingsEventSettingsUpdated({required this.settings});
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
  final bool? areSessionsScheduledNotificationsOn;
  final bool? areSessionsDefaultNotificationsOn;
  final bool? areAchievementsNotificationsOn;
  final bool? areLossOfDaysStreakNotificationsOn;

  SettingsEventNotificationsSettingsChanged({
    this.areSessionsScheduledNotificationsOn,
    this.areSessionsDefaultNotificationsOn,
    this.areAchievementsNotificationsOn,
    this.areLossOfDaysStreakNotificationsOn,
  });
}

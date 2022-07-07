import 'package:fiszkomaniak/domain/entities/appearance_settings.dart';
import 'package:fiszkomaniak/domain/entities/notifications_settings.dart';

abstract class SettingsEvent {}

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
  final bool? areDaysStreakLoseNotificationsOn;

  SettingsEventNotificationsSettingsChanged({
    this.areSessionsPlannedNotificationsOn,
    this.areSessionsDefaultNotificationsOn,
    this.areAchievementsNotificationsOn,
    this.areDaysStreakLoseNotificationsOn,
  });
}

class SettingsEventEmitNewAppearanceSettings extends SettingsEvent {
  final AppearanceSettings appearanceSettings;

  SettingsEventEmitNewAppearanceSettings({
    required this.appearanceSettings,
  });
}

class SettingsEventEmitNewNotificationsSettings extends SettingsEvent {
  final NotificationsSettings notificationsSettings;

  SettingsEventEmitNewNotificationsSettings({
    required this.notificationsSettings,
  });
}

import 'package:fiszkomaniak/models/settings/notifications_settings_model.dart';

abstract class SettingsEvent {}

class SettingsEventAppearanceSettingsChanged extends SettingsEvent {
  final bool? isDarkModeOn;
  final bool? isDarkModeCompatibilityWithSystemOn;
  final bool? isSessionTimerOn;

  SettingsEventAppearanceSettingsChanged({
    this.isDarkModeOn,
    this.isDarkModeCompatibilityWithSystemOn,
    this.isSessionTimerOn,
  });
}

class SettingsEventNotificationsSettingsChanged extends SettingsEvent {
  final bool? areSessionsPlannedNotificationsOn;
  final bool? areSessionsDefaultNotificationsOn;
  final bool? areAchievementsNotificationsOn;
  final bool? areLossOfDaysNotificationsOn;

  SettingsEventNotificationsSettingsChanged({
    this.areSessionsPlannedNotificationsOn,
    this.areSessionsDefaultNotificationsOn,
    this.areAchievementsNotificationsOn,
    this.areLossOfDaysNotificationsOn,
  });
}

class SettingsEventEmitNewNotificationsSettings extends SettingsEvent {
  final NotificationsSettings notificationsSettings;

  SettingsEventEmitNewNotificationsSettings({
    required this.notificationsSettings,
  });
}

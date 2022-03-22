import 'package:equatable/equatable.dart';
import 'package:fiszkomaniak/models/settings/appearance_settings_model.dart';
import 'package:fiszkomaniak/models/settings/notifications_settings_model.dart';

class SettingsState extends Equatable {
  final AppearanceSettings appearanceSettings;
  final NotificationsSettings notificationsSettings;
  final bool areAllNotificationsOn;

  const SettingsState({
    this.appearanceSettings = const AppearanceSettings(
      isDarkModeOn: false,
      isDarkModeCompatibilityWithSystemOn: false,
      isSessionTimerInvisibilityOn: false,
    ),
    this.notificationsSettings = const NotificationsSettings(
      areSessionsPlannedNotificationsOn: false,
      areSessionsDefaultNotificationsOn: false,
      areAchievementsNotificationsOn: false,
      areLossOfDaysNotificationsOn: false,
    ),
    this.areAllNotificationsOn = false,
  });

  SettingsState copyWith({
    AppearanceSettings? appearanceSettings,
    NotificationsSettings? notificationsSettings,
    bool? areAllNotificationsOn,
  }) {
    return SettingsState(
      appearanceSettings: appearanceSettings ?? this.appearanceSettings,
      notificationsSettings:
          notificationsSettings ?? this.notificationsSettings,
      areAllNotificationsOn:
          areAllNotificationsOn ?? this.areAllNotificationsOn,
    );
  }

  @override
  List<Object> get props => [
        appearanceSettings,
        notificationsSettings,
        areAllNotificationsOn,
      ];
}

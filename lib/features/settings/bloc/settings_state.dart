import 'package:equatable/equatable.dart';
import 'package:fiszkomaniak/domain/entities/appearance_settings.dart';
import 'package:fiszkomaniak/domain/entities/notifications_settings.dart';

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
      areDaysStreakLoseNotificationsOn: false,
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

part of 'settings_bloc.dart';

class SettingsState extends Equatable {
  final Settings settings;
  final bool areAllNotificationsOn;

  const SettingsState({
    required this.settings,
    required this.areAllNotificationsOn,
  });

  @override
  List<Object> get props => [
        settings,
        areAllNotificationsOn,
      ];

  AppearanceSettings get appearanceSettings => settings.appearanceSettings;

  NotificationsSettings get notificationsSettings =>
      settings.notificationsSettings;

  SettingsState copyWith({
    Settings? settings,
    bool? areAllNotificationsOn,
  }) {
    return SettingsState(
      settings: settings ?? this.settings,
      areAllNotificationsOn:
          areAllNotificationsOn ?? this.areAllNotificationsOn,
    );
  }
}

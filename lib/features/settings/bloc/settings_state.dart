part of 'settings_bloc.dart';

class SettingsState extends Equatable {
  final AppearanceSettings appearanceSettings;
  final NotificationsSettings notificationsSettings;
  final bool areAllNotificationsOn;

  const SettingsState({
    required this.appearanceSettings,
    required this.notificationsSettings,
    required this.areAllNotificationsOn,
  });

  @override
  List<Object> get props => [
        appearanceSettings,
        notificationsSettings,
        areAllNotificationsOn,
      ];

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
}

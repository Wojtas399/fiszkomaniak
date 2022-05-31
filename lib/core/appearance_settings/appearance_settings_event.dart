part of 'appearance_settings_bloc.dart';

abstract class AppearanceSettingsEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class AppearanceSettingsEventLoad extends AppearanceSettingsEvent {}

class AppearanceSettingsEventUpdate extends AppearanceSettingsEvent {
  final bool? isDarkModeOn;
  final bool? isDarkModeCompatibilityWithSystemOn;
  final bool? isSessionTimerInvisibilityOn;

  AppearanceSettingsEventUpdate({
    this.isDarkModeOn,
    this.isDarkModeCompatibilityWithSystemOn,
    this.isSessionTimerInvisibilityOn,
  });

  @override
  List<Object> get props => [
        isDarkModeOn ?? false,
        isDarkModeCompatibilityWithSystemOn ?? false,
        isSessionTimerInvisibilityOn ?? false,
      ];
}

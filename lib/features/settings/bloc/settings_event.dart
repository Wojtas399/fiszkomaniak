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

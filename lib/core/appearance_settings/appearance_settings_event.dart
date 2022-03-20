abstract class AppearanceSettingsEvent {}

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
}

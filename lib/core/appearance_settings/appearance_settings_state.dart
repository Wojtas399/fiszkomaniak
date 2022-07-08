part of 'appearance_settings_bloc.dart';

class AppearanceSettingsState extends AppearanceSettings {
  const AppearanceSettingsState({
    required bool isDarkModeOn,
    required bool isDarkModeCompatibilityWithSystemOn,
    required bool isSessionTimerInvisibilityOn,
  }) : super(
          isDarkModeOn: isDarkModeOn,
          isDarkModeCompatibilityWithSystemOn:
              isDarkModeCompatibilityWithSystemOn,
          isSessionTimerInvisibilityOn: isSessionTimerInvisibilityOn,
        );

  @override
  List<Object> get props => [
        isDarkModeOn,
        isDarkModeCompatibilityWithSystemOn,
        isSessionTimerInvisibilityOn,
      ];

  AppearanceSettingsState copyWith({
    bool? isDarkModeOn,
    bool? isDarkModeCompatibilityWithSystemOn,
    bool? isSessionTimerInvisibilityOn,
  }) {
    return AppearanceSettingsState(
      isDarkModeOn: isDarkModeOn ?? this.isDarkModeOn,
      isDarkModeCompatibilityWithSystemOn:
          isDarkModeCompatibilityWithSystemOn ??
              this.isDarkModeCompatibilityWithSystemOn,
      isSessionTimerInvisibilityOn:
          isSessionTimerInvisibilityOn ?? this.isSessionTimerInvisibilityOn,
    );
  }
}

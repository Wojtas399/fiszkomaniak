part of 'appearance_settings_bloc.dart';

class AppearanceSettingsState extends AppearanceSettings {
  final InitializationStatus initializationStatus;
  final HttpStatus httpStatus;

  const AppearanceSettingsState({
    this.initializationStatus = InitializationStatus.loading,
    bool isDarkModeOn = false,
    bool isDarkModeCompatibilityWithSystemOn = false,
    bool isSessionTimerInvisibilityOn = false,
    this.httpStatus = const HttpStatusInitial(),
  }) : super(
          isDarkModeOn: isDarkModeOn,
          isDarkModeCompatibilityWithSystemOn:
              isDarkModeCompatibilityWithSystemOn,
          isSessionTimerInvisibilityOn: isSessionTimerInvisibilityOn,
        );

  AppearanceSettingsState copyWith({
    InitializationStatus? initializationStatus,
    bool? isDarkModeOn,
    bool? isDarkModeCompatibilityWithSystemOn,
    bool? isSessionTimerInvisibilityOn,
    HttpStatus? httpStatus,
  }) {
    return AppearanceSettingsState(
      initializationStatus: initializationStatus ?? this.initializationStatus,
      isDarkModeOn: isDarkModeOn ?? this.isDarkModeOn,
      isDarkModeCompatibilityWithSystemOn:
          isDarkModeCompatibilityWithSystemOn ??
              this.isDarkModeCompatibilityWithSystemOn,
      isSessionTimerInvisibilityOn:
          isSessionTimerInvisibilityOn ?? this.isSessionTimerInvisibilityOn,
      httpStatus: httpStatus ?? const HttpStatusInitial(),
    );
  }

  @override
  List<Object> get props => [
        initializationStatus,
        isDarkModeOn,
        isDarkModeCompatibilityWithSystemOn,
        isSessionTimerInvisibilityOn,
        httpStatus,
      ];
}

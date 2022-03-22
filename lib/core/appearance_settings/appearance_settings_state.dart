import 'package:fiszkomaniak/models/http_status_model.dart';
import 'package:fiszkomaniak/models/settings/appearance_settings_model.dart';

class AppearanceSettingsState extends AppearanceSettings {
  final HttpStatus httpStatus;

  const AppearanceSettingsState({
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
    bool? isDarkModeOn,
    bool? isDarkModeCompatibilityWithSystemOn,
    bool? isSessionTimerInvisibilityOn,
    HttpStatus? httpStatus,
  }) {
    return AppearanceSettingsState(
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
        isDarkModeOn,
        isDarkModeCompatibilityWithSystemOn,
        isSessionTimerInvisibilityOn,
        httpStatus,
      ];
}

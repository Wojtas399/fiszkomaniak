import 'package:fiszkomaniak/models/http_status_model.dart';
import 'package:fiszkomaniak/models/settings/appearance_settings_model.dart';

class AppearanceSettingsState extends AppearanceSettings {
  final HttpStatus httpStatus;

  const AppearanceSettingsState({
    bool isDarkModeOn = false,
    bool isDarkModeCompatibilityWithSystemOn = false,
    bool isSessionTimerVisibilityOn = false,
    this.httpStatus = const HttpStatusInitial(),
  }) : super(
          isDarkModeOn: isDarkModeOn,
          isDarkModeCompatibilityWithSystemOn:
              isDarkModeCompatibilityWithSystemOn,
          isSessionTimerVisibilityOn: isSessionTimerVisibilityOn,
        );

  AppearanceSettingsState copyWith({
    bool? isDarkModeOn,
    bool? isDarkModeCompatibilityWithSystemOn,
    bool? isSessionTimerVisibilityOn,
    HttpStatus? httpStatus,
  }) {
    return AppearanceSettingsState(
      isDarkModeOn: isDarkModeOn ?? this.isDarkModeOn,
      isDarkModeCompatibilityWithSystemOn:
          isDarkModeCompatibilityWithSystemOn ??
              this.isDarkModeCompatibilityWithSystemOn,
      isSessionTimerVisibilityOn:
          isSessionTimerVisibilityOn ?? this.isSessionTimerVisibilityOn,
      httpStatus: httpStatus ?? const HttpStatusInitial(),
    );
  }

  @override
  List<Object> get props => [
        isDarkModeOn,
        isDarkModeCompatibilityWithSystemOn,
        isSessionTimerVisibilityOn,
        httpStatus,
      ];
}

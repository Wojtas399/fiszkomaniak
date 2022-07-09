import 'package:equatable/equatable.dart';

class AppearanceSettings extends Equatable {
  final bool isDarkModeOn;
  final bool isDarkModeCompatibilityWithSystemOn;
  final bool isSessionTimerInvisibilityOn;

  const AppearanceSettings({
    required this.isDarkModeOn,
    required this.isDarkModeCompatibilityWithSystemOn,
    required this.isSessionTimerInvisibilityOn,
  });

  @override
  List<Object> get props => [
        isDarkModeOn,
        isDarkModeCompatibilityWithSystemOn,
        isSessionTimerInvisibilityOn,
      ];

  AppearanceSettings copyWith({
    bool? isDarkModeOn,
    bool? isDarkModeCompatibilityWithSystemOn,
    bool? isSessionTimerInvisibilityOn,
  }) {
    return AppearanceSettings(
      isDarkModeOn: isDarkModeOn ?? this.isDarkModeOn,
      isDarkModeCompatibilityWithSystemOn:
          isDarkModeCompatibilityWithSystemOn ??
              this.isDarkModeCompatibilityWithSystemOn,
      isSessionTimerInvisibilityOn:
          isSessionTimerInvisibilityOn ?? this.isSessionTimerInvisibilityOn,
    );
  }
}

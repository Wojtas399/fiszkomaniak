import 'package:equatable/equatable.dart';

class AppearanceSettings extends Equatable {
  final bool isDarkModeOn;
  final bool isDarkModeCompatibilityWithSystemOn;
  final bool isSessionTimerVisibilityOn;

  const AppearanceSettings({
    required this.isDarkModeOn,
    required this.isDarkModeCompatibilityWithSystemOn,
    required this.isSessionTimerVisibilityOn,
  });

  @override
  List<Object> get props => [
        isDarkModeOn,
        isDarkModeCompatibilityWithSystemOn,
        isSessionTimerVisibilityOn,
      ];
}

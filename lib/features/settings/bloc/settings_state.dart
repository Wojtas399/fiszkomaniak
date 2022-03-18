import 'package:equatable/equatable.dart';
import 'package:fiszkomaniak/models/settings/appearance_settings_model.dart';

class SettingsState extends Equatable {
  final AppearanceSettings appearanceSettings;

  const SettingsState({required this.appearanceSettings});

  SettingsState copyWith({AppearanceSettings? appearanceSettings}) {
    return SettingsState(
      appearanceSettings: appearanceSettings ?? this.appearanceSettings,
    );
  }

  @override
  List<Object> get props => [appearanceSettings];
}

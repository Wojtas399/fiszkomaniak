import 'package:fiszkomaniak/core/appearance_settings/appearance_settings_bloc.dart';
import 'package:fiszkomaniak/core/appearance_settings/appearance_settings_event.dart';
import 'package:fiszkomaniak/features/settings/bloc/settings_event.dart';
import 'package:fiszkomaniak/features/settings/bloc/settings_state.dart';
import 'package:fiszkomaniak/models/settings/appearance_settings_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  late final AppearanceSettingsBloc _appearanceSettingsBloc;

  SettingsBloc({
    required AppearanceSettingsBloc appearanceSettingsBloc,
  }) : super(
          SettingsState(
            appearanceSettings: AppearanceSettings(
              isDarkModeOn: appearanceSettingsBloc.state.isDarkModeOn,
              isDarkModeCompatibilityWithSystemOn: appearanceSettingsBloc
                  .state.isDarkModeCompatibilityWithSystemOn,
              isSessionTimerVisibilityOn:
                  appearanceSettingsBloc.state.isSessionTimerVisibilityOn,
            ),
          ),
        ) {
    _appearanceSettingsBloc = appearanceSettingsBloc;
    on<SettingsEventAppearanceSettingsChanged>(_updateAppearanceSettings);
  }

  void _updateAppearanceSettings(
    SettingsEventAppearanceSettingsChanged event,
    Emitter emit,
  ) {
    AppearanceSettings currentAppearanceSettings = state.appearanceSettings;
    emit(state.copyWith(
      appearanceSettings: AppearanceSettings(
        isDarkModeOn:
            event.isDarkModeOn ?? currentAppearanceSettings.isDarkModeOn,
        isDarkModeCompatibilityWithSystemOn:
            event.isDarkModeCompatibilityWithSystemOn ??
                currentAppearanceSettings.isDarkModeCompatibilityWithSystemOn,
        isSessionTimerVisibilityOn: event.isSessionTimerOn ??
            currentAppearanceSettings.isSessionTimerVisibilityOn,
      ),
    ));
    _appearanceSettingsBloc.add(AppearanceSettingsEventUpdate(
      isDarkModeOn: event.isDarkModeOn,
      isDarkModeCompatibilityWithSystemOn:
          event.isDarkModeCompatibilityWithSystemOn,
      isSessionTimerVisibilityOn: event.isSessionTimerOn,
    ));
  }
}

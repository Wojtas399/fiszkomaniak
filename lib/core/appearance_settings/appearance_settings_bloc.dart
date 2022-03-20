import 'package:fiszkomaniak/core/appearance_settings/appearance_settings_event.dart';
import 'package:fiszkomaniak/core/appearance_settings/appearance_settings_state.dart';
import 'package:fiszkomaniak/interfaces/settings_interface.dart';
import 'package:fiszkomaniak/models/http_status_model.dart';
import 'package:fiszkomaniak/models/settings/appearance_settings_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppearanceSettingsBloc
    extends Bloc<AppearanceSettingsEvent, AppearanceSettingsState> {
  late final SettingsInterface _interface;

  AppearanceSettingsBloc({required SettingsInterface settingsInterface})
      : super(const AppearanceSettingsState()) {
    _interface = settingsInterface;
    on<AppearanceSettingsEventLoad>(_load);
    on<AppearanceSettingsEventUpdate>(_update);
  }

  Future<void> _load(
    AppearanceSettingsEvent event,
    Emitter<AppearanceSettingsState> emit,
  ) async {
    try {
      final AppearanceSettings settings =
          await _interface.loadAppearanceSettings();
      emit(state.copyWith(
        isDarkModeOn: settings.isDarkModeOn,
        isDarkModeCompatibilityWithSystemOn:
            settings.isDarkModeCompatibilityWithSystemOn,
        isSessionTimerInvisibilityOn: settings.isSessionTimerInvisibilityOn,
        httpStatus: HttpStatusSuccess(),
      ));
    } catch (error) {
      emit(state.copyWith(
        httpStatus: const HttpStatusFailure(
          message: 'Cannot load appearance settings',
        ),
      ));
    }
  }

  Future<void> _update(
    AppearanceSettingsEventUpdate event,
    Emitter<AppearanceSettingsState> emit,
  ) async {
    final AppearanceSettingsState currentState = state;
    try {
      emit(state.copyWith(
        isDarkModeOn: event.isDarkModeOn,
        isDarkModeCompatibilityWithSystemOn:
            event.isDarkModeCompatibilityWithSystemOn,
        isSessionTimerInvisibilityOn: event.isSessionTimerInvisibilityOn,
      ));
      await _interface.saveAppearanceSettings(
        isDarkModeOn: event.isDarkModeOn,
        isDarkModeCompatibilityWithSystemOn:
            event.isDarkModeCompatibilityWithSystemOn,
        isSessionTimerInvisibilityOn: event.isSessionTimerInvisibilityOn,
      );
    } catch (error) {
      emit(state.copyWith(
        isDarkModeOn: currentState.isDarkModeOn,
        isDarkModeCompatibilityWithSystemOn:
            currentState.isDarkModeCompatibilityWithSystemOn,
        isSessionTimerInvisibilityOn: currentState.isSessionTimerInvisibilityOn,
        httpStatus: HttpStatusFailure(message: error.toString()),
      ));
    }
  }
}

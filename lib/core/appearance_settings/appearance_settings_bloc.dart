import 'package:fiszkomaniak/core/appearance_settings/appearance_settings_event.dart';
import 'package:fiszkomaniak/core/appearance_settings/appearance_settings_state.dart';
import 'package:fiszkomaniak/models/http_status_model.dart';
import 'package:fiszkomaniak/models/settings/appearance_settings_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../interfaces/appearance_settings_storage_interface.dart';

class AppearanceSettingsBloc
    extends Bloc<AppearanceSettingsEvent, AppearanceSettingsState> {
  late final AppearanceSettingsStorageInterface _interface;

  AppearanceSettingsBloc({
    required AppearanceSettingsStorageInterface
        appearanceSettingsStorageInterface,
  }) : super(const AppearanceSettingsState()) {
    _interface = appearanceSettingsStorageInterface;
    on<AppearanceSettingsEventLoad>(_load);
    on<AppearanceSettingsEventUpdate>(_update);
  }

  Future<void> _load(
    AppearanceSettingsEvent event,
    Emitter<AppearanceSettingsState> emit,
  ) async {
    try {
      AppearanceSettings settings = await _interface.load();
      emit(state.copyWith(
        isDarkModeOn: settings.isDarkModeOn,
        isDarkModeCompatibilityWithSystemOn:
            settings.isDarkModeCompatibilityWithSystemOn,
        isSessionTimerVisibilityOn: settings.isSessionTimerVisibilityOn,
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
    AppearanceSettingsState currentState = state;
    try {
      emit(state.copyWith(
        isDarkModeOn: event.isDarkModeOn,
        isDarkModeCompatibilityWithSystemOn:
            event.isDarkModeCompatibilityWithSystemOn,
        isSessionTimerVisibilityOn: event.isSessionTimerVisibilityOn,
      ));
      await _interface.save(
        isDarkModeOn: event.isDarkModeOn,
        isDarkModeCompatibilityWithSystemOn:
            event.isDarkModeCompatibilityWithSystemOn,
        isSessionTimerVisibilityOn: event.isSessionTimerVisibilityOn,
      );
    } catch (error) {
      emit(state.copyWith(
        isDarkModeOn: currentState.isDarkModeOn,
        isDarkModeCompatibilityWithSystemOn:
            currentState.isDarkModeCompatibilityWithSystemOn,
        isSessionTimerVisibilityOn: currentState.isSessionTimerVisibilityOn,
        httpStatus: HttpStatusFailure(message: error.toString()),
      ));
    }
  }
}

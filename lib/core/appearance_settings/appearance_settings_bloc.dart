import 'package:equatable/equatable.dart';
import 'package:fiszkomaniak/domain/use_cases/appearance_settings/update_appearance_settings_use_case.dart';
import 'package:fiszkomaniak/domain/entities/appearance_settings.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/use_cases/appearance_settings/get_appearance_settings_use_case.dart';

part 'appearance_settings_event.dart';

part 'appearance_settings_state.dart';

class AppearanceSettingsBloc
    extends Bloc<AppearanceSettingsEvent, AppearanceSettingsState> {
  late final GetAppearanceSettingsUseCase _getAppearanceSettingsUseCase;
  late final UpdateAppearanceSettingsUseCase _updateAppearanceSettingsUseCase;

  AppearanceSettingsBloc({
    required GetAppearanceSettingsUseCase getAppearanceSettingsUseCase,
    required UpdateAppearanceSettingsUseCase updateAppearanceSettingsUseCase,
    bool isDarkModeOn = false,
    bool isDarkModeCompatibilityWithSystemOn = false,
    bool isSessionTimerInvisibilityOn = false,
  }) : super(
          AppearanceSettingsState(
            isDarkModeOn: isDarkModeOn,
            isDarkModeCompatibilityWithSystemOn:
                isDarkModeCompatibilityWithSystemOn,
            isSessionTimerInvisibilityOn: isSessionTimerInvisibilityOn,
          ),
        ) {
    _getAppearanceSettingsUseCase = getAppearanceSettingsUseCase;
    _updateAppearanceSettingsUseCase = updateAppearanceSettingsUseCase;
    on<AppearanceSettingsEventLoad>(_load);
    on<AppearanceSettingsEventUpdate>(_update);
  }

  Future<void> _load(
    AppearanceSettingsEvent event,
    Emitter<AppearanceSettingsState> emit,
  ) async {
    final AppearanceSettings settings =
        await _getAppearanceSettingsUseCase.execute().first;
    emit(state.copyWith(
      isDarkModeOn: settings.isDarkModeOn,
      isDarkModeCompatibilityWithSystemOn:
          settings.isDarkModeCompatibilityWithSystemOn,
      isSessionTimerInvisibilityOn: settings.isSessionTimerInvisibilityOn,
    ));
  }

  Future<void> _update(
    AppearanceSettingsEventUpdate event,
    Emitter<AppearanceSettingsState> emit,
  ) async {
    emit(state.copyWith(
      isDarkModeOn: event.isDarkModeOn,
      isDarkModeCompatibilityWithSystemOn:
          event.isDarkModeCompatibilityWithSystemOn,
      isSessionTimerInvisibilityOn: event.isSessionTimerInvisibilityOn,
    ));
    await _updateAppearanceSettingsUseCase.execute(
      isDarkModeOn: event.isDarkModeOn,
      isDarkModeCompatibilityWithSystemOn:
          event.isDarkModeCompatibilityWithSystemOn,
      isSessionTimerInvisibilityOn: event.isSessionTimerInvisibilityOn,
    );
  }
}

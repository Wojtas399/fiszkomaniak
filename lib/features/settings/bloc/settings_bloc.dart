import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/settings.dart';
import '../../../domain/use_cases/settings/get_settings_use_case.dart';
import '../../../domain/use_cases/settings/update_appearance_settings_use_case.dart';
import '../../../domain/use_cases/settings/update_notifications_settings_use_case.dart';

part 'settings_event.dart';

part 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  late final GetSettingsUseCase _getSettingsUseCase;
  late final UpdateAppearanceSettingsUseCase _updateAppearanceSettingsUseCase;
  late final UpdateNotificationsSettingsUseCase
      _updateNotificationsSettingsUseCase;
  StreamSubscription<Settings>? _settingsListener;

  SettingsBloc({
    required GetSettingsUseCase getSettingsUseCase,
    required UpdateAppearanceSettingsUseCase updateAppearanceSettingsUseCase,
    required UpdateNotificationsSettingsUseCase
        updateNotificationsSettingsUseCase,
    Settings settings = const Settings(
      appearanceSettings: AppearanceSettings(
        isDarkModeOn: false,
        isDarkModeCompatibilityWithSystemOn: false,
        isSessionTimerInvisibilityOn: false,
      ),
      notificationsSettings: NotificationsSettings(
        areSessionsScheduledNotificationsOn: false,
        areSessionsDefaultNotificationsOn: false,
        areAchievementsNotificationsOn: false,
        areLossOfDaysStreakNotificationsOn: false,
      ),
    ),
    bool areAllNotificationsOn = false,
  }) : super(
          SettingsState(
            settings: settings,
            areAllNotificationsOn: areAllNotificationsOn,
          ),
        ) {
    _getSettingsUseCase = getSettingsUseCase;
    _updateAppearanceSettingsUseCase = updateAppearanceSettingsUseCase;
    _updateNotificationsSettingsUseCase = updateNotificationsSettingsUseCase;
    on<SettingsEventInitialize>(_initialize);
    on<SettingsEventSettingsUpdated>(_settingsUpdated);
    on<SettingsEventAppearanceSettingsChanged>(_appearanceSettingsChanged);
    on<SettingsEventNotificationsSettingsChanged>(
      _notificationsSettingsChanged,
    );
  }

  @override
  Future<void> close() {
    _settingsListener?.cancel();
    return super.close();
  }

  Future<void> _initialize(
    SettingsEventInitialize event,
    Emitter<SettingsState> emit,
  ) async {
    _setSettingsListener();
  }

  void _settingsUpdated(
    SettingsEventSettingsUpdated event,
    Emitter<SettingsState> emit,
  ) {
    emit(state.copyWith(
      settings: event.settings,
      areAllNotificationsOn: _areAllNotificationsOn(
        event.settings.notificationsSettings,
      ),
    ));
  }

  Future<void> _appearanceSettingsChanged(
    SettingsEventAppearanceSettingsChanged event,
    Emitter<SettingsState> emit,
  ) async {
    await _updateAppearanceSettingsUseCase.execute(
      isDarkModeOn: event.isDarkModeOn,
      isDarkModeCompatibilityWithSystemOn:
          event.isDarkModeCompatibilityWithSystemOn,
      isSessionTimerInvisibilityOn: event.isSessionTimerInvisibilityOn,
    );
  }

  Future<void> _notificationsSettingsChanged(
    SettingsEventNotificationsSettingsChanged event,
    Emitter<SettingsState> emit,
  ) async {
    await _updateNotificationsSettingsUseCase.execute(
      areSessionsScheduledNotificationsOn:
          event.areSessionsScheduledNotificationsOn,
      areSessionsDefaultNotificationsOn:
          event.areSessionsDefaultNotificationsOn,
      areAchievementsNotificationsOn: event.areAchievementsNotificationsOn,
      areLossOfDaysStreakNotificationsOn:
          event.areLossOfDaysStreakNotificationsOn,
    );
  }

  void _setSettingsListener() {
    _settingsListener ??= _getSettingsUseCase.execute().listen(
          (Settings settings) => add(
            SettingsEventSettingsUpdated(settings: settings),
          ),
        );
  }

  bool _areAllNotificationsOn(NotificationsSettings settings) {
    return settings.areSessionsScheduledNotificationsOn &&
        settings.areSessionsDefaultNotificationsOn &&
        settings.areAchievementsNotificationsOn &&
        settings.areLossOfDaysStreakNotificationsOn;
  }
}

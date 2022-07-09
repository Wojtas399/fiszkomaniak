import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:fiszkomaniak/domain/use_cases/appearance_settings/get_appearance_settings_use_case.dart';
import 'package:fiszkomaniak/domain/use_cases/appearance_settings/update_appearance_settings_use_case.dart';
import 'package:fiszkomaniak/domain/use_cases/notifications_settings/get_notifications_settings_use_case.dart';
import 'package:fiszkomaniak/domain/use_cases/notifications_settings/update_notifications_settings_use_case.dart';
import 'package:fiszkomaniak/domain/entities/appearance_settings.dart';
import 'package:fiszkomaniak/domain/entities/notifications_settings.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'settings_event.dart';

part 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  late final GetAppearanceSettingsUseCase _getAppearanceSettingsUseCase;
  late final GetNotificationsSettingsUseCase _getNotificationsSettingsUseCase;
  late final UpdateAppearanceSettingsUseCase _updateAppearanceSettingsUseCase;
  late final UpdateNotificationsSettingsUseCase
      _updateNotificationsSettingsUseCase;
  StreamSubscription<AppearanceSettings>? _appearanceSettingsListener;
  StreamSubscription<NotificationsSettings>? _notificationsSettingsListener;

  SettingsBloc({
    required GetAppearanceSettingsUseCase getAppearanceSettingsUseCase,
    required GetNotificationsSettingsUseCase getNotificationsSettingsUseCase,
    required UpdateAppearanceSettingsUseCase updateAppearanceSettingsUseCase,
    required UpdateNotificationsSettingsUseCase
        updateNotificationsSettingsUseCase,
    AppearanceSettings appearanceSettings = const AppearanceSettings(
      isDarkModeOn: false,
      isDarkModeCompatibilityWithSystemOn: false,
      isSessionTimerInvisibilityOn: false,
    ),
    NotificationsSettings notificationsSettings = const NotificationsSettings(
      areSessionsPlannedNotificationsOn: false,
      areSessionsDefaultNotificationsOn: false,
      areAchievementsNotificationsOn: false,
      areLossOfDaysStreakNotificationsOn: false,
    ),
    bool areAllNotificationsOn = false,
  }) : super(
          SettingsState(
            appearanceSettings: appearanceSettings,
            notificationsSettings: notificationsSettings,
            areAllNotificationsOn: areAllNotificationsOn,
          ),
        ) {
    _getAppearanceSettingsUseCase = getAppearanceSettingsUseCase;
    _getNotificationsSettingsUseCase = getNotificationsSettingsUseCase;
    _updateAppearanceSettingsUseCase = updateAppearanceSettingsUseCase;
    _updateNotificationsSettingsUseCase = updateNotificationsSettingsUseCase;
    on<SettingsEventInitialize>(_initialize);
    on<SettingsEventAppearanceSettingsUpdated>(_appearanceSettingsUpdated);
    on<SettingsEventNotificationsSettingsUpdated>(
      _notificationsSettingsUpdated,
    );
    on<SettingsEventAppearanceSettingsChanged>(_appearanceSettingsChanged);
    on<SettingsEventNotificationsSettingsChanged>(
      _notificationsSettingsChanged,
    );
  }

  @override
  Future<void> close() {
    _appearanceSettingsListener?.cancel();
    _notificationsSettingsListener?.cancel();
    return super.close();
  }

  Future<void> _initialize(
    SettingsEventInitialize event,
    Emitter<SettingsState> emit,
  ) async {
    _setAppearanceSettingsListener();
    _setNotificationsSettingsListener();
  }

  void _appearanceSettingsUpdated(
    SettingsEventAppearanceSettingsUpdated event,
    Emitter<SettingsState> emit,
  ) {
    emit(state.copyWith(
      appearanceSettings: event.appearanceSettings,
    ));
  }

  void _notificationsSettingsUpdated(
    SettingsEventNotificationsSettingsUpdated event,
    Emitter<SettingsState> emit,
  ) {
    emit(state.copyWith(
      notificationsSettings: event.notificationsSettings,
      areAllNotificationsOn: _areAllNotificationsOn(
        event.notificationsSettings,
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
      areSessionsPlannedNotificationsOn:
          event.areSessionsPlannedNotificationsOn,
      areSessionsDefaultNotificationsOn:
          event.areSessionsDefaultNotificationsOn,
      areAchievementsNotificationsOn: event.areAchievementsNotificationsOn,
      areLossOfDaysStreakNotificationsOn:
          event.areLossOfDaysStreakNotificationsOn,
    );
  }

  void _setAppearanceSettingsListener() {
    _appearanceSettingsListener =
        _getAppearanceSettingsUseCase.execute().listen(
              (appearanceSettings) => add(
                SettingsEventAppearanceSettingsUpdated(
                  appearanceSettings: appearanceSettings,
                ),
              ),
            );
  }

  void _setNotificationsSettingsListener() {
    _notificationsSettingsListener =
        _getNotificationsSettingsUseCase.execute().listen(
              (notificationsSettings) => add(
                SettingsEventNotificationsSettingsUpdated(
                  notificationsSettings: notificationsSettings,
                ),
              ),
            );
  }

  bool _areAllNotificationsOn(NotificationsSettings settings) {
    return settings.areSessionsPlannedNotificationsOn &&
        settings.areSessionsDefaultNotificationsOn &&
        settings.areAchievementsNotificationsOn &&
        settings.areLossOfDaysStreakNotificationsOn;
  }
}

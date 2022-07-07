import 'dart:async';
import 'package:fiszkomaniak/core/appearance_settings/appearance_settings_bloc.dart';
import 'package:fiszkomaniak/features/settings/bloc/settings_event.dart';
import 'package:fiszkomaniak/features/settings/bloc/settings_state.dart';
import 'package:fiszkomaniak/domain/entities/appearance_settings.dart';
import 'package:fiszkomaniak/domain/entities/notifications_settings.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/notifications_settings/notifications_settings_bloc.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  late final AppearanceSettingsBloc _appearanceSettingsBloc;
  late final NotificationsSettingsBloc _notificationsSettingsBloc;
  StreamSubscription? _appearanceSettingsSubscription;
  StreamSubscription? _notificationsSettingsSubscription;

  SettingsBloc({
    required AppearanceSettingsBloc appearanceSettingsBloc,
    required NotificationsSettingsBloc notificationsSettingsBloc,
  }) : super(
          SettingsState(
            appearanceSettings: AppearanceSettings(
              isDarkModeOn: appearanceSettingsBloc.state.isDarkModeOn,
              isDarkModeCompatibilityWithSystemOn: appearanceSettingsBloc
                  .state.isDarkModeCompatibilityWithSystemOn,
              isSessionTimerInvisibilityOn:
                  appearanceSettingsBloc.state.isSessionTimerInvisibilityOn,
            ),
            notificationsSettings: NotificationsSettings(
              areSessionsPlannedNotificationsOn: notificationsSettingsBloc
                  .state.areSessionsPlannedNotificationsOn,
              areSessionsDefaultNotificationsOn: notificationsSettingsBloc
                  .state.areSessionsDefaultNotificationsOn,
              areAchievementsNotificationsOn: notificationsSettingsBloc
                  .state.areAchievementsNotificationsOn,
              areDaysStreakLoseNotificationsOn: notificationsSettingsBloc
                  .state.areDaysStreakLoseNotificationsOn,
            ),
            areAllNotificationsOn: notificationsSettingsBloc
                    .state.areSessionsPlannedNotificationsOn &&
                notificationsSettingsBloc
                    .state.areSessionsDefaultNotificationsOn &&
                notificationsSettingsBloc
                    .state.areAchievementsNotificationsOn &&
                notificationsSettingsBloc
                    .state.areDaysStreakLoseNotificationsOn,
          ),
        ) {
    _appearanceSettingsBloc = appearanceSettingsBloc;
    _notificationsSettingsBloc = notificationsSettingsBloc;
    _setAppearanceSettingsSubscriber();
    _setNotificationsSettingsSubscriber();
    on<SettingsEventAppearanceSettingsChanged>(_updateAppearanceSettings);
    on<SettingsEventNotificationsSettingsChanged>(_updateNotificationsSettings);
    on<SettingsEventEmitNewAppearanceSettings>(_emitNewAppearanceSettings);
    on<SettingsEventEmitNewNotificationsSettings>(
      _emitNewNotificationsSettings,
    );
  }

  void _setAppearanceSettingsSubscriber() {
    final Stream<AppearanceSettingsState> stream =
        _appearanceSettingsBloc.stream;
    _appearanceSettingsSubscription = stream.listen(
      (settings) {
        add(SettingsEventEmitNewAppearanceSettings(
          appearanceSettings: settings,
        ));
      },
    );
  }

  void _setNotificationsSettingsSubscriber() {
    final Stream<NotificationsSettingsState> stream =
        _notificationsSettingsBloc.stream;
    _notificationsSettingsSubscription = stream.listen(
      (settings) {
        add(SettingsEventEmitNewNotificationsSettings(
          notificationsSettings: settings,
        ));
      },
    );
  }

  void _updateAppearanceSettings(
    SettingsEventAppearanceSettingsChanged event,
    Emitter<SettingsState> emit,
  ) {
    final AppearanceSettings currentAppearanceSettings =
        state.appearanceSettings;
    emit(state.copyWith(
      appearanceSettings: AppearanceSettings(
        isDarkModeOn:
            event.isDarkModeOn ?? currentAppearanceSettings.isDarkModeOn,
        isDarkModeCompatibilityWithSystemOn:
            event.isDarkModeCompatibilityWithSystemOn ??
                currentAppearanceSettings.isDarkModeCompatibilityWithSystemOn,
        isSessionTimerInvisibilityOn: event.isSessionTimerInvisibilityOn ??
            currentAppearanceSettings.isSessionTimerInvisibilityOn,
      ),
    ));
    _appearanceSettingsBloc.add(AppearanceSettingsEventUpdate(
      isDarkModeOn: event.isDarkModeOn,
      isDarkModeCompatibilityWithSystemOn:
          event.isDarkModeCompatibilityWithSystemOn,
      isSessionTimerInvisibilityOn: event.isSessionTimerInvisibilityOn,
    ));
  }

  void _updateNotificationsSettings(
    SettingsEventNotificationsSettingsChanged event,
    Emitter<SettingsState> emit,
  ) {
    final NotificationsSettings currentNotificationsSettings =
        state.notificationsSettings;
    emit(state.copyWith(
      notificationsSettings: NotificationsSettings(
        areSessionsPlannedNotificationsOn:
            event.areSessionsPlannedNotificationsOn ??
                currentNotificationsSettings.areSessionsPlannedNotificationsOn,
        areSessionsDefaultNotificationsOn:
            event.areSessionsDefaultNotificationsOn ??
                currentNotificationsSettings.areSessionsDefaultNotificationsOn,
        areAchievementsNotificationsOn: event.areAchievementsNotificationsOn ??
            currentNotificationsSettings.areAchievementsNotificationsOn,
        areDaysStreakLoseNotificationsOn:
            event.areDaysStreakLoseNotificationsOn ??
                currentNotificationsSettings.areDaysStreakLoseNotificationsOn,
      ),
    ));
    _notificationsSettingsBloc.add(NotificationsSettingsEventUpdate(
      areSessionsPlannedNotificationsOn:
          event.areSessionsPlannedNotificationsOn,
      areSessionsDefaultNotificationsOn:
          event.areSessionsDefaultNotificationsOn,
      areAchievementsNotificationsOn: event.areAchievementsNotificationsOn,
      areDaysStreakLoseNotificationsOn: event.areDaysStreakLoseNotificationsOn,
    ));
  }

  void _emitNewAppearanceSettings(
    SettingsEventEmitNewAppearanceSettings event,
    Emitter<SettingsState> emit,
  ) {
    emit(state.copyWith(
      appearanceSettings: event.appearanceSettings,
    ));
  }

  void _emitNewNotificationsSettings(
    SettingsEventEmitNewNotificationsSettings event,
    Emitter<SettingsState> emit,
  ) {
    emit(state.copyWith(
      notificationsSettings: event.notificationsSettings,
      areAllNotificationsOn: _areAllNotificationsOn(
        event.notificationsSettings,
      ),
    ));
  }

  bool _areAllNotificationsOn(NotificationsSettings settings) {
    return settings.areSessionsPlannedNotificationsOn &&
        settings.areSessionsDefaultNotificationsOn &&
        settings.areAchievementsNotificationsOn &&
        settings.areDaysStreakLoseNotificationsOn;
  }

  @override
  Future<void> close() {
    _appearanceSettingsSubscription?.cancel();
    _notificationsSettingsSubscription?.cancel();
    return super.close();
  }
}

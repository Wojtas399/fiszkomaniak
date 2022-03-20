import 'dart:async';
import 'package:fiszkomaniak/core/appearance_settings/appearance_settings_bloc.dart';
import 'package:fiszkomaniak/core/appearance_settings/appearance_settings_event.dart';
import 'package:fiszkomaniak/core/appearance_settings/appearance_settings_state.dart';
import 'package:fiszkomaniak/core/notifications_settings/notifications_settings_event.dart';
import 'package:fiszkomaniak/core/notifications_settings/notifications_settings_state.dart';
import 'package:fiszkomaniak/features/settings/bloc/settings_event.dart';
import 'package:fiszkomaniak/features/settings/bloc/settings_state.dart';
import 'package:fiszkomaniak/models/settings/appearance_settings_model.dart';
import 'package:fiszkomaniak/models/settings/notifications_settings_model.dart';
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
              areLossOfDaysNotificationsOn:
                  notificationsSettingsBloc.state.areLossOfDaysNotificationsOn,
            ),
            areAllNotificationsOn: notificationsSettingsBloc
                    .state.areSessionsPlannedNotificationsOn &&
                notificationsSettingsBloc
                    .state.areSessionsDefaultNotificationsOn &&
                notificationsSettingsBloc
                    .state.areAchievementsNotificationsOn &&
                notificationsSettingsBloc.state.areLossOfDaysNotificationsOn,
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
        areLossOfDaysNotificationsOn: event.areLossOfDaysNotificationsOn ??
            currentNotificationsSettings.areLossOfDaysNotificationsOn,
      ),
    ));
    _notificationsSettingsBloc.add(NotificationsSettingsEventUpdate(
      areSessionsPlannedNotificationsOn:
          event.areSessionsPlannedNotificationsOn,
      areSessionsDefaultNotificationsOn:
          event.areSessionsDefaultNotificationsOn,
      areAchievementsNotificationsOn: event.areAchievementsNotificationsOn,
      areLossOfDaysNotificationsOn: event.areLossOfDaysNotificationsOn,
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
        settings.areLossOfDaysNotificationsOn;
  }

  @override
  Future<void> close() {
    _appearanceSettingsSubscription?.cancel();
    _notificationsSettingsSubscription?.cancel();
    return super.close();
  }
}

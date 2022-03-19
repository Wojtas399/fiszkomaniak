import 'package:fiszkomaniak/core/notifications_settings/notifications_settings_event.dart';
import 'package:fiszkomaniak/core/notifications_settings/notifications_settings_state.dart';
import 'package:fiszkomaniak/interfaces/notifications_settings_storage_interface.dart';
import 'package:fiszkomaniak/models/http_status_model.dart';
import 'package:fiszkomaniak/models/settings/notifications_settings_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NotificationsSettingsBloc
    extends Bloc<NotificationsSettingsEvent, NotificationsSettingsState> {
  late final NotificationsSettingsStorageInterface _interface;

  NotificationsSettingsBloc({
    required NotificationsSettingsStorageInterface
        notificationsSettingsStorageInterface,
  }) : super(const NotificationsSettingsState()) {
    _interface = notificationsSettingsStorageInterface;
    on<NotificationsSettingsEventLoad>(_load);
    on<NotificationsSettingsEventUpdate>(_update);
  }

  Future<void> _load(
    NotificationsSettingsEventLoad event,
    Emitter<NotificationsSettingsState> emit,
  ) async {
    try {
      NotificationsSettings settings = await _interface.load();
      emit(state.copyWith(
        areSessionsPlannedNotificationsOn:
            settings.areSessionsPlannedNotificationsOn,
        areSessionsDefaultNotificationsOn:
            settings.areSessionsDefaultNotificationsOn,
        areAchievementsNotificationsOn: settings.areAchievementsNotificationsOn,
        areLossOfDaysNotificationsOn: settings.areLossOfDaysNotificationsOn,
        httpStatus: HttpStatusSuccess(),
      ));
    } catch (error) {
      emit(state.copyWith(
        httpStatus: const HttpStatusFailure(
          message: 'Cannot load notifications settings',
        ),
      ));
    }
  }

  Future<void> _update(
    NotificationsSettingsEventUpdate event,
    Emitter<NotificationsSettingsState> emit,
  ) async {
    final NotificationsSettingsState currentState = state;
    try {
      emit(state.copyWith(
        areSessionsPlannedNotificationsOn:
            event.areSessionsPlannedNotificationsOn,
        areSessionsDefaultNotificationsOn:
            event.areSessionsDefaultNotificationsOn,
        areAchievementsNotificationsOn: event.areAchievementsNotificationsOn,
        areLossOfDaysNotificationsOn: event.areLossOfDaysNotificationsOn,
      ));
      await _interface.save(
        areSessionsPlannedNotificationsOn:
            event.areSessionsPlannedNotificationsOn,
        areSessionsDefaultNotificationsOn:
            event.areSessionsDefaultNotificationsOn,
        areAchievementsNotificationsOn: event.areAchievementsNotificationsOn,
        areLossOfDaysNotificationsOn: event.areLossOfDaysNotificationsOn,
      );
    } catch (error) {
      emit(state.copyWith(
        areSessionsPlannedNotificationsOn:
            currentState.areSessionsPlannedNotificationsOn,
        areSessionsDefaultNotificationsOn:
            currentState.areSessionsDefaultNotificationsOn,
        areAchievementsNotificationsOn:
            currentState.areAchievementsNotificationsOn,
        areLossOfDaysNotificationsOn: currentState.areLossOfDaysNotificationsOn,
        httpStatus: HttpStatusFailure(message: error.toString()),
      ));
    }
  }
}

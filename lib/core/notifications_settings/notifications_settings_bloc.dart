import 'package:equatable/equatable.dart';
import 'package:fiszkomaniak/core/initialization_status.dart';
import 'package:fiszkomaniak/models/http_status_model.dart';
import 'package:fiszkomaniak/domain/entities/notifications_settings.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'notifications_settings_event.dart';

part 'notifications_settings_state.dart';

class NotificationsSettingsBloc
    extends Bloc<NotificationsSettingsEvent, NotificationsSettingsState> {
  NotificationsSettingsBloc() : super(const NotificationsSettingsState()) {
    on<NotificationsSettingsEventLoad>(_load);
    on<NotificationsSettingsEventUpdate>(_update);
  }

  Future<void> _load(
    NotificationsSettingsEventLoad event,
    Emitter<NotificationsSettingsState> emit,
  ) async {
    try {
      // final NotificationsSettings settings =
      //     await _interface.loadNotificationsSettings();
      // emit(state.copyWith(
      //   initializationStatus: InitializationStatus.ready,
      //   areSessionsPlannedNotificationsOn:
      //       settings.areSessionsPlannedNotificationsOn,
      //   areSessionsDefaultNotificationsOn:
      //       settings.areSessionsDefaultNotificationsOn,
      //   areAchievementsNotificationsOn: settings.areAchievementsNotificationsOn,
      //   areDaysStreakLoseNotificationsOn:
      //       settings.areDaysStreakLoseNotificationsOn,
      //   httpStatus: const HttpStatusSuccess(),
      // ));
    } catch (error) {
      emit(state.copyWith(
        httpStatus: HttpStatusFailure(message: error.toString()),
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
        areDaysStreakLoseNotificationsOn:
            event.areDaysStreakLoseNotificationsOn,
      ));
      // await _interface.updateNotificationsSettings(
      //   areSessionsPlannedNotificationsOn:
      //       event.areSessionsPlannedNotificationsOn,
      //   areSessionsDefaultNotificationsOn:
      //       event.areSessionsDefaultNotificationsOn,
      //   areAchievementsNotificationsOn: event.areAchievementsNotificationsOn,
      //   areLossOfDaysNotificationsOn: event.areDaysStreakLoseNotificationsOn,
      // );
    } catch (error) {
      emit(state.copyWith(
        areSessionsPlannedNotificationsOn:
            currentState.areSessionsPlannedNotificationsOn,
        areSessionsDefaultNotificationsOn:
            currentState.areSessionsDefaultNotificationsOn,
        areAchievementsNotificationsOn:
            currentState.areAchievementsNotificationsOn,
        areDaysStreakLoseNotificationsOn:
            currentState.areDaysStreakLoseNotificationsOn,
        httpStatus: HttpStatusFailure(message: error.toString()),
      ));
    }
  }
}

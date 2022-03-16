import 'package:fiszkomaniak/features/settings/bloc/settings_event.dart';
import 'package:fiszkomaniak/features/settings/bloc/settings_state.dart';
import 'package:fiszkomaniak/providers/theme_provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final ThemeProvider themeProvider;

  SettingsBloc({required this.themeProvider})
      : super(
          SettingsState(isDarkMode: themeProvider.isDarkMode),
        ) {
    on<SettingsEventDarkModeChanged>(
      (event, emit) => {
        themeProvider.toggleTheme(!themeProvider.isDarkMode),
        emit(state.copyWith(isDarkMode: themeProvider.isDarkMode)),
      },
    );
    on<SettingsEventTimerVisibilityChanged>(
      (event, emit) => emit(
        state.copyWith(isTimerHidden: !state.isTimerHidden),
      ),
    );
    on<SettingsEventAllNotificationsChanged>(
      (_, emit) => emit(state.copyWith(
        areAllNotifications: !state.areAllNotifications,
        arePlannedSessionsNotifications: !state.areAllNotifications,
        areDefaultSessionsNotifications: !state.areAllNotifications,
        areAchievementsNotifications: !state.areAllNotifications,
        areDaysNotifications: !state.areAllNotifications,
      )),
    );
    on<SettingsEventPlannedSessionsNotificationsChanged>(
      (_, emit) => emit(state.copyWith(
        arePlannedSessionsNotifications: !state.arePlannedSessionsNotifications,
        areAllNotifications: !state.arePlannedSessionsNotifications == false
            ? false
            : state.areAllNotifications,
      )),
    );
    on<SettingsEventDefaultSessionsNotificationsChanged>(
      (_, emit) => emit(state.copyWith(
        areDefaultSessionsNotifications: !state.areDefaultSessionsNotifications,
        areAllNotifications: !state.areDefaultSessionsNotifications == false
            ? false
            : state.areAllNotifications,
      )),
    );
    on<SettingsEventAchievementNotificationsChanged>(
      (_, emit) => emit(state.copyWith(
        areAchievementsNotifications: !state.areAchievementsNotifications,
        areAllNotifications: !state.areAchievementsNotifications == false
            ? false
            : state.areAllNotifications,
      )),
    );
    on<SettingsEventDaysNotificationsChanged>(
      (_, emit) => emit(state.copyWith(
        areDaysNotifications: !state.areDaysNotifications,
        areAllNotifications: !state.areDaysNotifications == false
            ? false
            : state.areAllNotifications,
      )),
    );
  }
}

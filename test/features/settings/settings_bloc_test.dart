import 'package:bloc_test/bloc_test.dart';
import 'package:fiszkomaniak/core/appearance_settings/appearance_settings_bloc.dart';
import 'package:fiszkomaniak/core/notifications_settings/notifications_settings_bloc.dart';
import 'package:fiszkomaniak/features/settings/bloc/settings_bloc.dart';
import 'package:fiszkomaniak/features/settings/bloc/settings_event.dart';
import 'package:fiszkomaniak/features/settings/bloc/settings_state.dart';
import 'package:fiszkomaniak/models/settings/appearance_settings_model.dart';
import 'package:fiszkomaniak/models/settings/notifications_settings_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAppearanceSettingsBloc extends Mock
    implements AppearanceSettingsBloc {}

class MockNotificationsSettingsBloc extends Mock
    implements NotificationsSettingsBloc {}

void main() {
  final AppearanceSettingsBloc appearanceSettingsBloc =
      MockAppearanceSettingsBloc();
  final NotificationsSettingsBloc notificationsSettingsBloc =
      MockNotificationsSettingsBloc();
  late SettingsBloc settingsBloc;
  const AppearanceSettings appearanceSettings = AppearanceSettings(
    isDarkModeOn: true,
    isDarkModeCompatibilityWithSystemOn: false,
    isSessionTimerInvisibilityOn: false,
  );
  const NotificationsSettings notificationsSettings = NotificationsSettings(
    areSessionsPlannedNotificationsOn: true,
    areSessionsDefaultNotificationsOn: true,
    areAchievementsNotificationsOn: true,
    areDaysStreakLoseNotificationsOn: false,
  );

  setUp(() {
    when(() => appearanceSettingsBloc.state).thenReturn(
      const AppearanceSettingsState(
        isDarkModeOn: true,
        isDarkModeCompatibilityWithSystemOn: false,
        isSessionTimerInvisibilityOn: false,
      ),
    );
    when(() => notificationsSettingsBloc.state).thenReturn(
      const NotificationsSettingsState(
        areSessionsPlannedNotificationsOn: true,
        areSessionsDefaultNotificationsOn: true,
        areAchievementsNotificationsOn: true,
        areDaysStreakLoseNotificationsOn: false,
      ),
    );
    when(() => appearanceSettingsBloc.stream)
        .thenAnswer((_) => const Stream.empty());
    when(() => notificationsSettingsBloc.stream)
        .thenAnswer((_) => const Stream.empty());
    settingsBloc = SettingsBloc(
      appearanceSettingsBloc: appearanceSettingsBloc,
      notificationsSettingsBloc: notificationsSettingsBloc,
    );
  });

  tearDown(() {
    reset(appearanceSettingsBloc);
    reset(notificationsSettingsBloc);
  });

  test('initial state', () {
    final SettingsState state = settingsBloc.state;
    expect(state.appearanceSettings.isDarkModeOn, true);
    expect(state.appearanceSettings.isDarkModeCompatibilityWithSystemOn, false);
    expect(state.appearanceSettings.isSessionTimerInvisibilityOn, false);
    expect(state.notificationsSettings.areSessionsPlannedNotificationsOn, true);
    expect(state.notificationsSettings.areSessionsDefaultNotificationsOn, true);
    expect(state.notificationsSettings.areAchievementsNotificationsOn, true);
    expect(state.notificationsSettings.areDaysStreakLoseNotificationsOn, false);
  });

  blocTest(
    'appearance settings changed',
    build: () => settingsBloc,
    act: (SettingsBloc bloc) => bloc.add(SettingsEventAppearanceSettingsChanged(
      isDarkModeOn: false,
      isDarkModeCompatibilityWithSystemOn: true,
    )),
    expect: () => [
      const SettingsState(
        appearanceSettings: AppearanceSettings(
          isDarkModeOn: false,
          isDarkModeCompatibilityWithSystemOn: true,
          isSessionTimerInvisibilityOn: false,
        ),
        notificationsSettings: notificationsSettings,
      ),
    ],
    verify: (_) {
      verify(
        () => appearanceSettingsBloc.add(AppearanceSettingsEventUpdate(
          isDarkModeOn: false,
          isDarkModeCompatibilityWithSystemOn: true,
        )),
      ).called(1);
    },
  );

  blocTest(
    'notifications settings changed',
    build: () => settingsBloc,
    act: (SettingsBloc bloc) => bloc.add(
      SettingsEventNotificationsSettingsChanged(
        areSessionsPlannedNotificationsOn: false,
      ),
    ),
    expect: () => [
      const SettingsState(
        appearanceSettings: appearanceSettings,
        notificationsSettings: NotificationsSettings(
          areSessionsPlannedNotificationsOn: false,
          areSessionsDefaultNotificationsOn: true,
          areAchievementsNotificationsOn: true,
          areDaysStreakLoseNotificationsOn: false,
        ),
      ),
    ],
    verify: (_) {
      verify(
        () => notificationsSettingsBloc.add(NotificationsSettingsEventUpdate(
          areSessionsPlannedNotificationsOn: false,
        )),
      ).called(1);
    },
  );

  blocTest(
    'emit new appearance settings',
    build: () => settingsBloc,
    act: (SettingsBloc bloc) => bloc.add(
      SettingsEventEmitNewAppearanceSettings(
        appearanceSettings: const AppearanceSettings(
          isDarkModeOn: true,
          isDarkModeCompatibilityWithSystemOn: true,
          isSessionTimerInvisibilityOn: true,
        ),
      ),
    ),
    expect: () => [
      const SettingsState(
        appearanceSettings: AppearanceSettings(
          isDarkModeOn: true,
          isDarkModeCompatibilityWithSystemOn: true,
          isSessionTimerInvisibilityOn: true,
        ),
        notificationsSettings: notificationsSettings,
      ),
    ],
  );

  blocTest(
    'emit new notifications settings',
    build: () => settingsBloc,
    act: (SettingsBloc bloc) => bloc.add(
      SettingsEventEmitNewNotificationsSettings(
        notificationsSettings: const NotificationsSettings(
          areSessionsPlannedNotificationsOn: true,
          areSessionsDefaultNotificationsOn: true,
          areAchievementsNotificationsOn: true,
          areDaysStreakLoseNotificationsOn: true,
        ),
      ),
    ),
    expect: () => [
      const SettingsState(
        appearanceSettings: appearanceSettings,
        notificationsSettings: NotificationsSettings(
          areSessionsPlannedNotificationsOn: true,
          areSessionsDefaultNotificationsOn: true,
          areAchievementsNotificationsOn: true,
          areDaysStreakLoseNotificationsOn: true,
        ),
        areAllNotificationsOn: true,
      ),
    ],
  );
}

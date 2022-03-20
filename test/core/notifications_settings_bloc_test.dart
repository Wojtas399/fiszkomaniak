import 'package:bloc_test/bloc_test.dart';
import 'package:fiszkomaniak/core/notifications_settings/notifications_settings_bloc.dart';
import 'package:fiszkomaniak/core/notifications_settings/notifications_settings_event.dart';
import 'package:fiszkomaniak/core/notifications_settings/notifications_settings_state.dart';
import 'package:fiszkomaniak/interfaces/settings_interface.dart';
import 'package:fiszkomaniak/models/http_status_model.dart';
import 'package:fiszkomaniak/models/settings/notifications_settings_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockSettingsInterface extends Mock implements SettingsInterface {}

void main() {
  final SettingsInterface settingsInterface = MockSettingsInterface();
  late NotificationsSettingsBloc notificationsSettingsBloc;

  setUp(() {
    notificationsSettingsBloc = NotificationsSettingsBloc(
      settingsInterface: settingsInterface,
    );
  });

  tearDown(() {
    reset(settingsInterface);
  });

  test('initial state', () {
    final NotificationsSettingsState state = notificationsSettingsBloc.state;
    expect(state.areSessionsPlannedNotificationsOn, false);
    expect(state.areSessionsDefaultNotificationsOn, false);
    expect(state.areAchievementsNotificationsOn, false);
    expect(state.areLossOfDaysNotificationsOn, false);
    expect(state.httpStatus, const HttpStatusInitial());
  });

  blocTest(
    'load, success',
    build: () => notificationsSettingsBloc,
    setUp: () {
      when(() => settingsInterface.loadNotificationsSettings()).thenAnswer(
        (_) async => const NotificationsSettings(
          areSessionsPlannedNotificationsOn: true,
          areSessionsDefaultNotificationsOn: false,
          areAchievementsNotificationsOn: false,
          areLossOfDaysNotificationsOn: true,
        ),
      );
    },
    act: (NotificationsSettingsBloc bloc) => bloc.add(
      NotificationsSettingsEventLoad(),
    ),
    expect: () => [
      NotificationsSettingsState(
        areSessionsPlannedNotificationsOn: true,
        areSessionsDefaultNotificationsOn: false,
        areAchievementsNotificationsOn: false,
        areLossOfDaysNotificationsOn: true,
        httpStatus: HttpStatusSuccess(),
      ),
    ],
    verify: (_) {
      verify(() => settingsInterface.loadNotificationsSettings()).called(1);
    },
  );

  blocTest(
    'load, failure',
    build: () => notificationsSettingsBloc,
    setUp: () {
      when(() => settingsInterface.loadAppearanceSettings()).thenThrow('');
    },
    act: (NotificationsSettingsBloc bloc) => bloc.add(
      NotificationsSettingsEventLoad(),
    ),
    expect: () => [
      const NotificationsSettingsState(
        httpStatus: HttpStatusFailure(
          message: 'Cannot load notifications settings',
        ),
      ),
    ],
    verify: (_) {
      verify(() => settingsInterface.loadNotificationsSettings()).called(1);
    },
  );

  blocTest(
    'update, success',
    build: () => notificationsSettingsBloc,
    setUp: () {
      when(() => settingsInterface.saveNotificationsSettings(
            areSessionsDefaultNotificationsOn: true,
            areAchievementsNotificationsOn: true,
          )).thenAnswer((_) async => '');
    },
    act: (NotificationsSettingsBloc bloc) => bloc.add(
      NotificationsSettingsEventUpdate(
        areSessionsDefaultNotificationsOn: true,
        areAchievementsNotificationsOn: true,
      ),
    ),
    expect: () => [
      const NotificationsSettingsState(
        areSessionsDefaultNotificationsOn: true,
        areAchievementsNotificationsOn: true,
      ),
    ],
    verify: (_) {
      verify(() => settingsInterface.saveNotificationsSettings(
            areSessionsDefaultNotificationsOn: true,
            areAchievementsNotificationsOn: true,
          )).called(1);
    },
  );

  blocTest(
    'update, failure',
    build: () => notificationsSettingsBloc,
    setUp: () {
      when(() => settingsInterface.saveNotificationsSettings(
            areSessionsDefaultNotificationsOn: true,
            areAchievementsNotificationsOn: true,
          )).thenThrow('Error...');
    },
    act: (NotificationsSettingsBloc bloc) => bloc.add(
      NotificationsSettingsEventUpdate(
        areSessionsDefaultNotificationsOn: true,
        areAchievementsNotificationsOn: true,
      ),
    ),
    expect: () => [
      const NotificationsSettingsState(
        areSessionsDefaultNotificationsOn: true,
        areAchievementsNotificationsOn: true,
      ),
      const NotificationsSettingsState(
        areSessionsDefaultNotificationsOn: false,
        areAchievementsNotificationsOn: false,
        httpStatus: HttpStatusFailure(message: 'Error...'),
      ),
    ],
    verify: (_) {
      verify(() => settingsInterface.saveNotificationsSettings(
            areSessionsDefaultNotificationsOn: true,
            areAchievementsNotificationsOn: true,
          )).called(1);
    },
  );
}

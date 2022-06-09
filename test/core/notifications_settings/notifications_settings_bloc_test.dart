import 'package:bloc_test/bloc_test.dart';
import 'package:fiszkomaniak/core/initialization_status.dart';
import 'package:fiszkomaniak/core/notifications_settings/notifications_settings_bloc.dart';
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

  blocTest(
    'load, success',
    build: () => notificationsSettingsBloc,
    setUp: () {
      when(() => settingsInterface.loadNotificationsSettings()).thenAnswer(
        (_) async => const NotificationsSettings(
          areSessionsPlannedNotificationsOn: true,
          areSessionsDefaultNotificationsOn: false,
          areAchievementsNotificationsOn: false,
          areDaysStreakLoseNotificationsOn: true,
        ),
      );
    },
    act: (NotificationsSettingsBloc bloc) => bloc.add(
      NotificationsSettingsEventLoad(),
    ),
    expect: () => [
      const NotificationsSettingsState(
        initializationStatus: InitializationStatus.ready,
        areSessionsPlannedNotificationsOn: true,
        areSessionsDefaultNotificationsOn: false,
        areAchievementsNotificationsOn: false,
        areDaysStreakLoseNotificationsOn: true,
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
      when(() => settingsInterface.loadNotificationsSettings()).thenThrow(
        'Error...',
      );
    },
    act: (NotificationsSettingsBloc bloc) => bloc.add(
      NotificationsSettingsEventLoad(),
    ),
    expect: () => [
      const NotificationsSettingsState(
        httpStatus: HttpStatusFailure(message: 'Error...'),
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
      when(() => settingsInterface.updateNotificationsSettings(
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
      verify(() => settingsInterface.updateNotificationsSettings(
            areSessionsDefaultNotificationsOn: true,
            areAchievementsNotificationsOn: true,
          )).called(1);
    },
  );

  blocTest(
    'update, failure',
    build: () => notificationsSettingsBloc,
    setUp: () {
      when(() => settingsInterface.updateNotificationsSettings(
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
      verify(() => settingsInterface.updateNotificationsSettings(
            areSessionsDefaultNotificationsOn: true,
            areAchievementsNotificationsOn: true,
          )).called(1);
    },
  );
}

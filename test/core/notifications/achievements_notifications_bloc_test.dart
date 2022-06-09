import 'package:fiszkomaniak/core/achievements/achievements_bloc.dart';
import 'package:fiszkomaniak/core/notifications/achievements_notifications_bloc.dart';
import 'package:fiszkomaniak/core/notifications_settings/notifications_settings_bloc.dart';
import 'package:fiszkomaniak/interfaces/achievements_notifications_interface.dart';
import 'package:fiszkomaniak/models/date_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAchievementsNotificationsInterface extends Mock
    implements AchievementsNotificationsInterface {}

class MockAchievementsBloc extends Mock implements AchievementsBloc {}

class MockNotificationsSettingsBloc extends Mock
    implements NotificationsSettingsBloc {}

class FakeDate extends Fake implements Date {}

void main() {
  final AchievementsNotificationsInterface achievementsNotificationsInterface =
      MockAchievementsNotificationsInterface();
  final AchievementsBloc achievementsBloc = MockAchievementsBloc();
  final NotificationsSettingsBloc notificationsSettingsBloc =
      MockNotificationsSettingsBloc();
  late AchievementsNotificationsBloc bloc;

  setUpAll(() {
    registerFallbackValue(FakeDate());
  });

  setUp(() {
    bloc = AchievementsNotificationsBloc(
      achievementsNotificationsInterface: achievementsNotificationsInterface,
      achievementsBloc: achievementsBloc,
      notificationsSettingsBloc: notificationsSettingsBloc,
    );
  });

  tearDown(() {
    reset(achievementsNotificationsInterface);
    reset(achievementsBloc);
    reset(notificationsSettingsBloc);
  });

  test(
    'set days streak lose notification, days streak lose notifications are disabled',
    () async {
      when(() => notificationsSettingsBloc.state).thenReturn(
        const NotificationsSettingsState(
          areDaysStreakLoseNotificationsOn: false,
        ),
      );

      await bloc.setDaysStreakLoseNotification();

      verifyNever(
        () => achievementsNotificationsInterface.setDaysStreakLoseNotification(
          date: any(named: 'date'),
        ),
      );
    },
  );

  test('set days streak lose notification, days streak is equal 0', () async {
    when(() => notificationsSettingsBloc.state).thenReturn(
      const NotificationsSettingsState(
        areDaysStreakLoseNotificationsOn: false,
      ),
    );
    when(() => achievementsBloc.state).thenReturn(
      const AchievementsState(daysStreak: 0),
    );

    await bloc.setDaysStreakLoseNotification();

    verifyNever(
      () => achievementsNotificationsInterface.setDaysStreakLoseNotification(
        date: any(named: 'date'),
      ),
    );
  });

  test('set days streak lose notification, conditions have been met', () async {
    when(() => notificationsSettingsBloc.state).thenReturn(
      const NotificationsSettingsState(
        areDaysStreakLoseNotificationsOn: true,
      ),
    );
    when(() => achievementsBloc.state).thenReturn(
      const AchievementsState(daysStreak: 3),
    );

    await bloc.setDaysStreakLoseNotification();

    verify(
      () => achievementsNotificationsInterface.setDaysStreakLoseNotification(
        date: any(named: 'date'),
      ),
    ).called(1);
  });

  test('cancel days streak lose notification', () async {
    await bloc.cancelDaysStreakLoseNotification();

    verify(
      () =>
          achievementsNotificationsInterface.removeDaysStreakLoseNotification(),
    ).called(1);
  });
}

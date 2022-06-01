import 'package:bloc_test/bloc_test.dart';
import 'package:fiszkomaniak/core/notifications/achievements_notifications_bloc.dart';
import 'package:fiszkomaniak/core/notifications/notifications_bloc.dart';
import 'package:fiszkomaniak/core/notifications/sessions_notifications_bloc.dart';
import 'package:fiszkomaniak/core/notifications_settings/notifications_settings_bloc.dart';
import 'package:fiszkomaniak/interfaces/notifications_interface.dart';
import 'package:fiszkomaniak/models/notification_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rxdart/rxdart.dart';

class MockNotificationsInterface extends Mock
    implements NotificationsInterface {}

class MockSessionsNotificationsBloc extends Mock
    implements SessionsNotificationsBloc {}

class MockAchievementsNotificationsBloc extends Mock
    implements AchievementsNotificationsBloc {}

class MockNotificationsSettingsBloc extends Mock
    implements NotificationsSettingsBloc {}

void main() {
  final NotificationsInterface notificationsInterface =
      MockNotificationsInterface();
  final SessionsNotificationsBloc sessionsNotificationsBloc =
      MockSessionsNotificationsBloc();
  final AchievementsNotificationsBloc achievementsNotificationsBloc =
      MockAchievementsNotificationsBloc();
  final NotificationsSettingsBloc notificationsSettingsBloc =
      MockNotificationsSettingsBloc();
  late NotificationsBloc bloc;
  const NotificationsSettingsState notificationsSettingsState =
      NotificationsSettingsState(
    areSessionsPlannedNotificationsOn: true,
    areSessionsDefaultNotificationsOn: true,
    areDaysStreakLoseNotificationsOn: true,
  );

  setUp(() {
    bloc = NotificationsBloc(
      notificationsInterface: notificationsInterface,
      sessionsNotificationsBloc: sessionsNotificationsBloc,
      achievementsNotificationsBloc: achievementsNotificationsBloc,
      notificationsSettingsBloc: notificationsSettingsBloc,
    );
    when(() => notificationsInterface.didNotificationLaunchApp())
        .thenAnswer((_) async => null);
    when(
      () => notificationsInterface.initializeSettings(
        onNotificationSelected: any(named: 'onNotificationSelected'),
      ),
    ).thenAnswer((_) async => '');
    when(() => notificationsSettingsBloc.stream).thenAnswer(
      (_) => const Stream.empty(),
    );
    when(() => sessionsNotificationsBloc.errorStream)
        .thenAnswer((_) => BehaviorSubject());
    when(() => achievementsNotificationsBloc.errorStream)
        .thenAnswer((_) => BehaviorSubject());
  });

  tearDown(() {
    reset(notificationsInterface);
    reset(sessionsNotificationsBloc);
    reset(achievementsNotificationsBloc);
    reset(notificationsSettingsBloc);
  });

  blocTest(
    'initialize, normal',
    build: () => bloc,
    setUp: () {
      when(() => notificationsSettingsBloc.stream)
          .thenAnswer((_) => const Stream.empty());
      when(() => notificationsSettingsBloc.state)
          .thenReturn(notificationsSettingsState);
    },
    act: (_) => bloc.add(NotificationsEventInitialize()),
    expect: () => [
      NotificationsState(
        status: NotificationsStatusLoaded(),
        areScheduledNotificationsOn: true,
        areDefaultNotificationsOn: true,
        areDaysStreakLoseNotificationsOn: true,
      ),
    ],
  );

  blocTest(
    'initialize, notifications launched app',
    build: () => bloc,
    setUp: () {
      when(() => notificationsInterface.didNotificationLaunchApp())
          .thenAnswer((_) async => SessionNotification(sessionId: 's1'));
      when(() => notificationsSettingsBloc.stream)
          .thenAnswer((_) => const Stream.empty());
      when(() => notificationsSettingsBloc.state)
          .thenReturn(notificationsSettingsState);
    },
    act: (_) => bloc.add(NotificationsEventInitialize()),
    expect: () => [
      NotificationsState(
        status: NotificationsStatusLoaded(),
        areScheduledNotificationsOn: true,
        areDefaultNotificationsOn: true,
        areDaysStreakLoseNotificationsOn: true,
      ),
      const NotificationsState(
        status: NotificationsStatusSessionSelected(sessionId: 's1'),
        areScheduledNotificationsOn: true,
        areDefaultNotificationsOn: true,
        areDaysStreakLoseNotificationsOn: true,
      ),
      NotificationsState(
        status: NotificationsStatusLoaded(),
        areScheduledNotificationsOn: true,
        areDefaultNotificationsOn: true,
        areDaysStreakLoseNotificationsOn: true,
      ),
    ],
  );

  blocTest(
    'on changed notifications settings state, notifications turned on',
    build: () => bloc,
    setUp: () {
      when(() => notificationsSettingsBloc.state).thenReturn(
        const NotificationsSettingsState(
          areSessionsPlannedNotificationsOn: false,
          areSessionsDefaultNotificationsOn: false,
          areDaysStreakLoseNotificationsOn: false,
        ),
      );
      when(() => sessionsNotificationsBloc.setScheduledNotifications())
          .thenAnswer((_) async => '');
      when(
        () => sessionsNotificationsBloc.setDefaultNotificationsForAllSessions(),
      ).thenAnswer((_) async => '');
      when(() => achievementsNotificationsBloc.setDaysStreakLoseNotification())
          .thenAnswer((_) async => '');
    },
    act: (_) {
      bloc.add(NotificationsEventInitialize());
      bloc.add(
        NotificationsEventNotificationsSettingsStateChanged(
          newNotificationsSettingsState: const NotificationsSettingsState(
            areSessionsPlannedNotificationsOn: true,
            areSessionsDefaultNotificationsOn: true,
            areDaysStreakLoseNotificationsOn: true,
          ),
        ),
      );
    },
    expect: () => [
      NotificationsState(
        status: NotificationsStatusLoaded(),
        areScheduledNotificationsOn: false,
        areDefaultNotificationsOn: false,
        areDaysStreakLoseNotificationsOn: false,
      ),
      NotificationsState(
        status: NotificationsStatusLoaded(),
        areScheduledNotificationsOn: true,
        areDefaultNotificationsOn: true,
        areDaysStreakLoseNotificationsOn: true,
      ),
    ],
    verify: (_) {
      verify(() => sessionsNotificationsBloc.setScheduledNotifications())
          .called(1);
      verify(
        () => sessionsNotificationsBloc.setDefaultNotificationsForAllSessions(),
      ).called(1);
      verify(
        () => achievementsNotificationsBloc.setDaysStreakLoseNotification(),
      ).called(1);
    },
  );

  blocTest(
    'on changed notifications settings state, notifications turned off',
    build: () => bloc,
    setUp: () {
      when(() => notificationsSettingsBloc.state).thenReturn(
        const NotificationsSettingsState(
          areSessionsPlannedNotificationsOn: true,
          areSessionsDefaultNotificationsOn: true,
          areDaysStreakLoseNotificationsOn: true,
        ),
      );
      when(() => sessionsNotificationsBloc.cancelScheduledNotifications())
          .thenAnswer((_) async => '');
      when(
        () => sessionsNotificationsBloc
            .cancelDefaultNotificationsForAllSessions(),
      ).thenAnswer((_) async => '');
      when(
        () => achievementsNotificationsBloc.cancelDaysStreakLoseNotification(),
      ).thenAnswer((_) async => '');
    },
    act: (_) {
      bloc.add(NotificationsEventInitialize());
      bloc.add(
        NotificationsEventNotificationsSettingsStateChanged(
          newNotificationsSettingsState: const NotificationsSettingsState(
            areSessionsPlannedNotificationsOn: false,
            areSessionsDefaultNotificationsOn: false,
            areDaysStreakLoseNotificationsOn: false,
          ),
        ),
      );
    },
    expect: () => [
      NotificationsState(
        status: NotificationsStatusLoaded(),
        areScheduledNotificationsOn: true,
        areDefaultNotificationsOn: true,
        areDaysStreakLoseNotificationsOn: true,
      ),
      NotificationsState(
        status: NotificationsStatusLoaded(),
        areScheduledNotificationsOn: false,
        areDefaultNotificationsOn: false,
        areDaysStreakLoseNotificationsOn: false,
      ),
    ],
    verify: (_) {
      verify(() => sessionsNotificationsBloc.cancelScheduledNotifications())
          .called(1);
      verify(
        () => sessionsNotificationsBloc
            .cancelDefaultNotificationsForAllSessions(),
      ).called(1);
      verify(
        () => achievementsNotificationsBloc.cancelDaysStreakLoseNotification(),
      ).called(1);
    },
  );

  blocTest(
    'on changed notifications settings state, notifications have not been changed',
    build: () => bloc,
    setUp: () {
      when(() => notificationsSettingsBloc.state).thenReturn(
        const NotificationsSettingsState(
          areSessionsPlannedNotificationsOn: false,
          areSessionsDefaultNotificationsOn: false,
          areDaysStreakLoseNotificationsOn: false,
        ),
      );
    },
    act: (_) {
      bloc.add(NotificationsEventInitialize());
      bloc.add(
        NotificationsEventNotificationsSettingsStateChanged(
          newNotificationsSettingsState: const NotificationsSettingsState(
            areSessionsPlannedNotificationsOn: false,
            areSessionsDefaultNotificationsOn: false,
            areDaysStreakLoseNotificationsOn: false,
          ),
        ),
      );
    },
    expect: () => [
      NotificationsState(
        status: NotificationsStatusLoaded(),
        areScheduledNotificationsOn: false,
        areDefaultNotificationsOn: false,
        areDaysStreakLoseNotificationsOn: false,
      ),
    ],
    verify: (_) {
      verifyNever(() => sessionsNotificationsBloc.setScheduledNotifications());
      verifyNever(
        () => sessionsNotificationsBloc.setDefaultNotificationsForAllSessions(),
      );
      verifyNever(
        () => achievementsNotificationsBloc.setDaysStreakLoseNotification(),
      );
      verifyNever(
        () => sessionsNotificationsBloc.cancelScheduledNotifications(),
      );
      verifyNever(
        () => sessionsNotificationsBloc
            .cancelDefaultNotificationsForAllSessions(),
      );
      verifyNever(
        () => achievementsNotificationsBloc.cancelDaysStreakLoseNotification(),
      );
    },
  );

  blocTest(
    'notification selected, session',
    build: () => bloc,
    act: (_) => bloc.add(
      NotificationsEventNotificationSelected(
        notification: SessionNotification(sessionId: 's1'),
      ),
    ),
    expect: () => [
      const NotificationsState(
        status: NotificationsStatusSessionSelected(sessionId: 's1'),
      ),
      NotificationsState(status: NotificationsStatusLoaded()),
    ],
  );

  blocTest(
    'notification selected, days streak lose',
    build: () => bloc,
    act: (_) => bloc.add(
      NotificationsEventNotificationSelected(
        notification: DaysStreakLoseNotification(),
      ),
    ),
    expect: () => [
      NotificationsState(status: NotificationsStatusDaysStreakLoseSelected()),
      NotificationsState(status: NotificationsStatusLoaded()),
    ],
  );

  blocTest(
    'error received',
    build: () => bloc,
    act: (_) => bloc.add(NotificationsEventErrorReceived(message: 'Error')),
    expect: () => [
      const NotificationsState(
        status: NotificationsStatusError(message: 'Error'),
      ),
    ],
  );
}

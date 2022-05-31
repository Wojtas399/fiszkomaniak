import 'package:bloc_test/bloc_test.dart';
import 'package:fiszkomaniak/core/notifications/notifications_bloc.dart';
import 'package:fiszkomaniak/core/notifications/sessions_notifications/sessions_notifications_bloc.dart';
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

class MockNotificationsSettingsBloc extends Mock
    implements NotificationsSettingsBloc {}

void main() {
  final NotificationsInterface notificationsInterface =
      MockNotificationsInterface();
  final SessionsNotificationsBloc sessionsNotificationsBloc =
      MockSessionsNotificationsBloc();
  final NotificationsSettingsBloc notificationsSettingsBloc =
      MockNotificationsSettingsBloc();
  late NotificationsBloc bloc;
  const NotificationsSettingsState notificationsSettingsState =
      NotificationsSettingsState(
    areSessionsPlannedNotificationsOn: true,
    areSessionsDefaultNotificationsOn: true,
  );

  setUp(() {
    bloc = NotificationsBloc(
      notificationsInterface: notificationsInterface,
      sessionsNotificationsBloc: sessionsNotificationsBloc,
      notificationsSettingsBloc: notificationsSettingsBloc,
    );
    when(() => notificationsInterface.didNotificationLaunchApp())
        .thenAnswer((_) async => SessionNotification(sessionId: 's1'));
    when(
      () => notificationsInterface.initializeSettings(
        onNotificationSelected: any(named: 'onNotificationSelected'),
      ),
    ).thenAnswer((_) async => '');
    when(() => sessionsNotificationsBloc.errorStream)
        .thenAnswer((_) => BehaviorSubject());
  });

  tearDown(() {
    reset(notificationsInterface);
    reset(sessionsNotificationsBloc);
    reset(notificationsSettingsBloc);
  });

  blocTest(
    'initialize, notifications launched app',
    build: () => bloc,
    setUp: () {
      when(() => notificationsSettingsBloc.stream)
          .thenAnswer((_) => const Stream.empty());
      when(() => notificationsSettingsBloc.state)
          .thenReturn(notificationsSettingsState);
    },
    act: (_) => bloc.add(NotificationsEventInitialize()),
    expect: () => [
      const NotificationsStateSessionSelected(sessionId: 's1'),
      NotificationsStateLoaded(),
    ],
  );

  blocTest(
    'error received',
    build: () => bloc,
    act: (_) => bloc.add(NotificationsEventErrorReceived(message: 'Error')),
    expect: () => [
      const NotificationsStateError(message: 'Error'),
    ],
  );

  blocTest(
    'turn on sessions scheduled notifications',
    build: () => bloc,
    setUp: () {
      when(() => sessionsNotificationsBloc.setScheduledNotifications())
          .thenAnswer((_) async => '');
    },
    act: (_) => bloc.add(
      NotificationsEventTurnOnSessionsScheduledNotifications(),
    ),
    verify: (_) {
      verify(() => sessionsNotificationsBloc.setScheduledNotifications())
          .called(1);
    },
  );

  blocTest(
    'turn off sessions scheduled notifications',
    build: () => bloc,
    setUp: () {
      when(() => sessionsNotificationsBloc.cancelScheduledNotifications())
          .thenAnswer((_) async => '');
    },
    act: (_) => bloc.add(
      NotificationsEventTurnOffSessionsScheduledNotifications(),
    ),
    verify: (_) {
      verify(() => sessionsNotificationsBloc.cancelScheduledNotifications())
          .called(1);
    },
  );

  blocTest(
    'turn on sessions default notifications',
    build: () => bloc,
    setUp: () {
      when(
        () => sessionsNotificationsBloc.setDefaultNotificationsForAllSessions(),
      ).thenAnswer((_) async => '');
    },
    act: (_) => bloc.add(
      NotificationsEventTurnOnSessionsDefaultNotifications(),
    ),
    verify: (_) {
      verify(
        () => sessionsNotificationsBloc.setDefaultNotificationsForAllSessions(),
      ).called(1);
    },
  );

  blocTest(
    'turn off sessions default notifications',
    build: () => bloc,
    setUp: () {
      when(
        () => sessionsNotificationsBloc
            .cancelDefaultNotificationsForAllSessions(),
      ).thenAnswer((_) async => '');
    },
    act: (_) => bloc.add(
      NotificationsEventTurnOffSessionsDefaultNotifications(),
    ),
    verify: (_) {
      verify(
        () => sessionsNotificationsBloc
            .cancelDefaultNotificationsForAllSessions(),
      ).called(1);
    },
  );

  blocTest(
    'on changed settings state, sessions notifications turned on',
    build: () => bloc,
    setUp: () {
      when(() => notificationsSettingsBloc.stream).thenAnswer(
        (_) => Stream.value(
          const NotificationsSettingsState(
            areSessionsPlannedNotificationsOn: true,
            areSessionsDefaultNotificationsOn: true,
          ),
        ),
      );
      when(() => notificationsSettingsBloc.state).thenReturn(
        const NotificationsSettingsState(
          areSessionsPlannedNotificationsOn: false,
          areSessionsDefaultNotificationsOn: false,
        ),
      );
      when(() => sessionsNotificationsBloc.setScheduledNotifications())
          .thenAnswer((_) async => '');
      when(
        () => sessionsNotificationsBloc.setDefaultNotificationsForAllSessions(),
      ).thenAnswer((_) async => '');
    },
    act: (_) => bloc.add(NotificationsEventInitialize()),
    verify: (_) {
      verify(() => sessionsNotificationsBloc.setScheduledNotifications())
          .called(1);
      verify(
        () => sessionsNotificationsBloc.setDefaultNotificationsForAllSessions(),
      ).called(1);
    },
  );

  blocTest(
    'on changed settings state, sessions notifications turned off',
    build: () => bloc,
    setUp: () {
      when(() => notificationsSettingsBloc.stream).thenAnswer(
        (_) => Stream.value(
          const NotificationsSettingsState(
            areSessionsPlannedNotificationsOn: false,
            areSessionsDefaultNotificationsOn: false,
          ),
        ),
      );
      when(() => notificationsSettingsBloc.state).thenReturn(
        const NotificationsSettingsState(
          areSessionsPlannedNotificationsOn: true,
          areSessionsDefaultNotificationsOn: true,
        ),
      );
      when(() => sessionsNotificationsBloc.cancelScheduledNotifications())
          .thenAnswer((_) async => '');
      when(
        () => sessionsNotificationsBloc
            .cancelDefaultNotificationsForAllSessions(),
      ).thenAnswer((_) async => '');
    },
    act: (_) => bloc.add(NotificationsEventInitialize()),
    verify: (_) {
      verify(() => sessionsNotificationsBloc.cancelScheduledNotifications())
          .called(1);
      verify(
        () => sessionsNotificationsBloc
            .cancelDefaultNotificationsForAllSessions(),
      ).called(1);
    },
  );

  blocTest(
    'on changed settings state, notifications settings have not changed',
    build: () => bloc,
    setUp: () {
      when(() => notificationsSettingsBloc.stream).thenAnswer(
        (_) => Stream.value(
          const NotificationsSettingsState(
            areSessionsPlannedNotificationsOn: false,
            areSessionsDefaultNotificationsOn: false,
          ),
        ),
      );
      when(() => notificationsSettingsBloc.state).thenReturn(
        const NotificationsSettingsState(
          areSessionsPlannedNotificationsOn: false,
          areSessionsDefaultNotificationsOn: false,
        ),
      );
    },
    act: (_) => bloc.add(NotificationsEventInitialize()),
    verify: (_) {
      verifyNever(() => sessionsNotificationsBloc.setScheduledNotifications());
      verifyNever(
        () => sessionsNotificationsBloc.setDefaultNotificationsForAllSessions(),
      );
    },
  );
}

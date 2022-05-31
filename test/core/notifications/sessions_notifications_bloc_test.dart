import 'package:fiszkomaniak/core/groups/groups_bloc.dart';
import 'package:fiszkomaniak/core/notifications/sessions_notifications/sessions_notifications_bloc.dart';
import 'package:fiszkomaniak/core/notifications_settings/notifications_settings_bloc.dart';
import 'package:fiszkomaniak/core/sessions/sessions_bloc.dart';
import 'package:fiszkomaniak/interfaces/sessions_notifications_interface.dart';
import 'package:fiszkomaniak/models/date_model.dart';
import 'package:fiszkomaniak/models/group_model.dart';
import 'package:fiszkomaniak/models/session_model.dart';
import 'package:fiszkomaniak/models/time_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockSessionsNotificationsInterface extends Mock
    implements SessionsNotificationsInterface {}

class MockNotificationsSettingsBloc extends Mock
    implements NotificationsSettingsBloc {}

class MockSessionsBloc extends Mock implements SessionsBloc {}

class MockGroupsBloc extends Mock implements GroupsBloc {}

class FakeDate extends Fake implements Date {}

class FakeTime extends Fake implements Time {}

void main() {
  final SessionsNotificationsInterface sessionsNotificationsInterface =
      MockSessionsNotificationsInterface();
  final NotificationsSettingsBloc notificationsSettingsBloc =
      MockNotificationsSettingsBloc();
  final SessionsBloc sessionsBloc = MockSessionsBloc();
  final GroupsBloc groupsBloc = MockGroupsBloc();
  late SessionsNotificationsBloc bloc;

  setUpAll(() {
    registerFallbackValue(FakeDate());
    registerFallbackValue(FakeTime());
  });

  setUp(() {
    bloc = SessionsNotificationsBloc(
      sessionsNotificationsInterface: sessionsNotificationsInterface,
      notificationsSettingsBloc: notificationsSettingsBloc,
      sessionsBloc: sessionsBloc,
      groupsBloc: groupsBloc,
    );
  });

  tearDown(() {
    reset(sessionsNotificationsInterface);
    reset(notificationsSettingsBloc);
    reset(sessionsBloc);
    reset(groupsBloc);
  });

  test('set scheduled notifications, scheduled notifications turned off',
      () async {
    when(() => notificationsSettingsBloc.state).thenReturn(
      const NotificationsSettingsState(
        areSessionsPlannedNotificationsOn: false,
      ),
    );

    await bloc.setScheduledNotifications();

    verifyNever(() => sessionsBloc.state.allSessions);
  });

  test(
    'set scheduled notifications, scheduled notifications turned on',
    () async {
      when(() => notificationsSettingsBloc.state).thenReturn(
        const NotificationsSettingsState(
            areSessionsPlannedNotificationsOn: true),
      );
      when(() => sessionsBloc.state).thenReturn(SessionsState(
        allSessions: [
          createSession(
            id: 's1',
            groupId: 'g1',
            date: Date.now().addDays(2),
            time: const Time(hour: 12, minute: 30),
            notificationTime: Time.now().addMinutes(30),
          ),
          createSession(
            id: 's2',
            groupId: 'g2',
            date: Date.now().addDays(3),
            time: const Time(hour: 10, minute: 0),
            notificationTime: Time.now(),
          ),
          createSession(id: 's3', groupId: 'g3'),
        ],
      ));
      when(() => groupsBloc.state).thenReturn(GroupsState(
        allGroups: [
          createGroup(id: 'g1', name: 'group 1'),
          createGroup(id: 'g2', name: 'group 2'),
        ],
      ));
      when(
        () => sessionsNotificationsInterface.setScheduledNotification(
          sessionId: any(named: 'sessionId'),
          groupName: any(named: 'groupName'),
          date: any(named: 'date'),
          time: any(named: 'time'),
          sessionStartTime: any(named: 'sessionStartTime'),
        ),
      ).thenAnswer((_) async => '');

      await bloc.setScheduledNotifications();

      verify(
        () => sessionsNotificationsInterface.setScheduledNotification(
          sessionId: 's1',
          groupName: 'group 1',
          date: Date.now().addDays(2),
          time: Time.now().addMinutes(30),
          sessionStartTime: const Time(hour: 12, minute: 30),
        ),
      ).called(1);
      verify(
        () => sessionsNotificationsInterface.setScheduledNotification(
          sessionId: 's2',
          groupName: 'group 2',
          date: Date.now().addDays(3),
          time: Time.now(),
          sessionStartTime: const Time(hour: 10, minute: 0),
        ),
      ).called(1);
    },
  );

  test('cancel scheduled notifications', () async {
    when(() => sessionsBloc.state).thenReturn(
      SessionsState(
        allSessions: [
          createSession(id: 's1', notificationTime: Time.now().addMinutes(2)),
          createSession(id: 's2'),
        ],
      ),
    );
    when(() => sessionsNotificationsInterface.removeScheduledNotification(
          sessionId: 's1',
        )).thenAnswer((_) async => '');

    await bloc.cancelScheduledNotifications();

    verify(() => sessionsNotificationsInterface.removeScheduledNotification(
          sessionId: 's1',
        )).called(1);
  });

  test(
    'set default notifications for all sessions, default notifications are turned off',
    () async {
      when(() => notificationsSettingsBloc.state).thenReturn(
        const NotificationsSettingsState(
          areSessionsDefaultNotificationsOn: false,
        ),
      );

      await bloc.setDefaultNotificationsForAllSessions();

      verifyNever(() => sessionsBloc.state.allSessions);
    },
  );

  test(
      'set default notifications for all sessions, default notification are turned on',
      () async {
    when(() => notificationsSettingsBloc.state).thenReturn(
      const NotificationsSettingsState(areSessionsDefaultNotificationsOn: true),
    );
    when(() => sessionsBloc.state).thenReturn(SessionsState(
      allSessions: [
        createSession(
          id: 's1',
          groupId: 'g1',
          date: Date.now().addDays(2),
          time: const Time(hour: 12, minute: 30),
        ),
        createSession(id: 's2', groupId: 'g3'),
      ],
    ));
    when(() => groupsBloc.state).thenReturn(GroupsState(
      allGroups: [
        createGroup(id: 'g1', name: 'group1'),
        createGroup(id: 'g2', name: 'group2'),
      ],
    ));
    when(
      () => sessionsNotificationsInterface.setDefaultNotification(
        sessionId: any(named: 'sessionId'),
        groupName: any(named: 'groupName'),
        date: any(named: 'date'),
        sessionStartTime: any(named: 'sessionStartTime'),
      ),
    ).thenAnswer((_) async => '');

    await bloc.setDefaultNotificationsForAllSessions();

    verify(
      () => sessionsNotificationsInterface.setDefaultNotification(
        sessionId: 's1',
        groupName: 'group1',
        date: Date.now().addDays(2),
        sessionStartTime: const Time(hour: 12, minute: 30),
      ),
    ).called(1);
  });

  test('cancel default notifications for all sessions', () async {
    when(() => sessionsBloc.state).thenReturn(SessionsState(
      allSessions: [
        createSession(id: 's1'),
        createSession(id: 's2'),
      ],
    ));
    when(
      () => sessionsNotificationsInterface.removeDefaultNotification(
        sessionId: any(named: 'sessionId'),
      ),
    ).thenAnswer((_) async => '');

    await bloc.cancelDefaultNotificationsForAllSessions();

    verify(() => sessionsNotificationsInterface.removeDefaultNotification(
          sessionId: 's1',
        )).called(1);
    verify(() => sessionsNotificationsInterface.removeDefaultNotification(
          sessionId: 's2',
        )).called(1);
  });
}

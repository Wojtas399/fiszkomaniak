import 'package:bloc_test/bloc_test.dart';
import 'package:fiszkomaniak/core/groups/groups_bloc.dart';
import 'package:fiszkomaniak/core/initialization_status.dart';
import 'package:fiszkomaniak/core/sessions/sessions_bloc.dart';
import 'package:fiszkomaniak/interfaces/notifications_interface.dart';
import 'package:fiszkomaniak/interfaces/sessions_interface.dart';
import 'package:fiszkomaniak/models/changed_document.dart';
import 'package:fiszkomaniak/models/group_model.dart';
import 'package:fiszkomaniak/models/session_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockSessionsInterface extends Mock implements SessionsInterface {}

class MockNotificationsInterface extends Mock
    implements NotificationsInterface {}

class MockGroupsBloc extends Mock implements GroupsBloc {}

class FakeSession extends Fake implements Session {}

class FakeTimeOfDay extends Fake implements TimeOfDay {}

void main() {
  final SessionsInterface sessionsInterface = MockSessionsInterface();
  final NotificationsInterface notificationsInterface =
      MockNotificationsInterface();
  final GroupsBloc groupsBloc = MockGroupsBloc();
  late SessionsBloc bloc;
  final List<ChangedDocument<Session>> snapshots = [
    ChangedDocument(
      changeType: DbDocChangeType.added,
      doc: createSession(id: 's1'),
    ),
    ChangedDocument(
      changeType: DbDocChangeType.added,
      doc: createSession(id: 's2'),
    ),
    ChangedDocument(
      changeType: DbDocChangeType.added,
      doc: createSession(id: 's3', time: const TimeOfDay(hour: 12, minute: 30)),
    ),
    ChangedDocument(
      changeType: DbDocChangeType.updated,
      doc: createSession(id: 's3', time: const TimeOfDay(hour: 13, minute: 30)),
    ),
    ChangedDocument(
      changeType: DbDocChangeType.removed,
      doc: createSession(id: 's3'),
    )
  ];

  setUp(() {
    bloc = SessionsBloc(
      sessionsInterface: sessionsInterface,
      notificationsInterface: notificationsInterface,
      groupsBloc: groupsBloc,
    );
  });

  setUpAll(() {
    registerFallbackValue(FakeSession());
    registerFallbackValue(FakeTimeOfDay());
  });

  tearDown(() {
    reset(sessionsInterface);
    reset(notificationsInterface);
    reset(groupsBloc);
  });

  blocTest(
    'initialize',
    build: () => bloc,
    setUp: () {
      when(() => sessionsInterface.getSessionsSnapshots()).thenAnswer(
        (_) => Stream.value(snapshots),
      );
    },
    act: (_) => bloc.add(SessionsEventInitialize()),
    expect: () => [
      SessionsState(
        initializationStatus: InitializationStatus.ready,
        allSessions: [snapshots[0].doc, snapshots[1].doc],
        status: SessionsStatusLoaded(),
      ),
    ],
  );

  group('add session with notification time', () {
    final Session newSession = createSession(
      groupId: 'g1',
      time: const TimeOfDay(hour: 12, minute: 20),
      date: DateTime(2022, 5, 20),
      notificationTime: const TimeOfDay(hour: 9, minute: 0),
    );

    blocTest(
      'add session, success',
      build: () => bloc,
      setUp: () {
        when(() => sessionsInterface.addNewSession(newSession))
            .thenAnswer((_) async => 's4');
        when(() => groupsBloc.state).thenReturn(GroupsState(
          allGroups: [createGroup(id: 'g1', name: 'group name')],
        ));
        when(
          () => notificationsInterface.setSessionNotification(
            sessionId: 's4',
            groupName: 'group name',
            startTime: newSession.time,
            date: DateTime(2022, 5, 20, 9, 0),
          ),
        ).thenAnswer((_) async => '');
      },
      act: (_) => bloc.add(SessionsEventAddSession(session: newSession)),
      expect: () => [
        SessionsState(status: SessionsStatusLoading()),
        SessionsState(status: SessionsStatusSessionAdded()),
      ],
      verify: (_) {
        verify(() => sessionsInterface.addNewSession(newSession)).called(1);
        verify(
          () => notificationsInterface.setSessionNotification(
            sessionId: 's4',
            groupName: 'group name',
            startTime: newSession.time,
            date: DateTime(2022, 5, 20, 9, 0),
          ),
        ).called(1);
      },
    );

    blocTest(
      'add session, cannot find group name',
      build: () => bloc,
      setUp: () {
        when(() => sessionsInterface.addNewSession(newSession))
            .thenAnswer((_) async => 's4');
        when(() => groupsBloc.state).thenReturn(GroupsState(
          allGroups: [createGroup(id: 'g3', name: 'group name')],
        ));
        when(
          () => notificationsInterface.setSessionNotification(
            sessionId: 's4',
            groupName: 'group name',
            startTime: newSession.time,
            date: DateTime(2022, 5, 20, 9, 0),
          ),
        ).thenAnswer((_) async => '');
      },
      act: (_) => bloc.add(SessionsEventAddSession(session: newSession)),
      expect: () => [
        SessionsState(status: SessionsStatusLoading()),
        const SessionsState(
          status: SessionsStatusError(message: 'Cannot find appropriate group'),
        ),
      ],
      verify: (_) {
        verifyNever(() => sessionsInterface.addNewSession(any()));
        verifyNever(
          () => notificationsInterface.setSessionNotification(
            sessionId: any(named: 'sessionId'),
            groupName: any(named: 'groupName'),
            startTime: any(named: 'startTime'),
            date: any(named: 'date'),
          ),
        );
      },
    );

    blocTest(
      'add session, add new session failure',
      build: () => bloc,
      setUp: () {
        when(() => sessionsInterface.addNewSession(newSession))
            .thenThrow('Error...');
        when(() => groupsBloc.state).thenReturn(GroupsState(
          allGroups: [createGroup(id: 'g1', name: 'group name')],
        ));
        when(
          () => notificationsInterface.setSessionNotification(
            sessionId: 's4',
            groupName: 'group name',
            startTime: newSession.time,
            date: DateTime(2022, 5, 20, 9, 0),
          ),
        ).thenAnswer((_) async => '');
      },
      act: (_) => bloc.add(SessionsEventAddSession(session: newSession)),
      expect: () => [
        SessionsState(status: SessionsStatusLoading()),
        const SessionsState(status: SessionsStatusError(message: 'Error...')),
      ],
      verify: (_) {
        verify(() => sessionsInterface.addNewSession(newSession)).called(1);
        verifyNever(
          () => notificationsInterface.setSessionNotification(
            sessionId: any(named: 'sessionId'),
            groupName: any(named: 'groupName'),
            startTime: any(named: 'startTime'),
            date: any(named: 'date'),
          ),
        );
      },
    );

    blocTest(
      'add session, set session notification failure',
      build: () => bloc,
      setUp: () {
        when(() => sessionsInterface.addNewSession(newSession))
            .thenAnswer((_) async => 's4');
        when(() => groupsBloc.state).thenReturn(GroupsState(
          allGroups: [createGroup(id: 'g1', name: 'group name')],
        ));
        when(
          () => notificationsInterface.setSessionNotification(
            sessionId: 's4',
            groupName: 'group name',
            startTime: newSession.time,
            date: DateTime(2022, 5, 20, 9, 0),
          ),
        ).thenThrow('Error...');
      },
      act: (_) => bloc.add(SessionsEventAddSession(session: newSession)),
      expect: () => [
        SessionsState(status: SessionsStatusLoading()),
        const SessionsState(status: SessionsStatusError(message: 'Error...')),
      ],
      verify: (_) {
        verify(() => sessionsInterface.addNewSession(newSession)).called(1);
        verify(
          () => notificationsInterface.setSessionNotification(
            sessionId: 's4',
            groupName: 'group name',
            startTime: newSession.time,
            date: DateTime(2022, 5, 20, 9, 0),
          ),
        ).called(1);
      },
    );
  });

  blocTest(
    'add session without notification',
    build: () => bloc,
    setUp: () {
      when(() => sessionsInterface.addNewSession(createSession(groupId: 'g1')))
          .thenAnswer((_) async => 's4');
      when(() => groupsBloc.state).thenReturn(GroupsState(
        allGroups: [createGroup(id: 'g1', name: 'group name')],
      ));
    },
    act: (_) => bloc.add(
      SessionsEventAddSession(session: createSession(groupId: 'g1')),
    ),
    expect: () => [
      SessionsState(status: SessionsStatusLoading()),
      SessionsState(status: SessionsStatusSessionAdded()),
    ],
    verify: (_) {
      verify(
        () => sessionsInterface.addNewSession(createSession(groupId: 'g1')),
      ).called(1);
      verifyNever(
        () => notificationsInterface.setSessionNotification(
          sessionId: any(named: 'sessionId'),
          groupName: any(named: 'groupName'),
          startTime: any(named: 'startTime'),
          date: any(named: 'date'),
        ),
      );
    },
  );

  blocTest(
    'update session, success',
    build: () => bloc,
    setUp: () {
      when(
        () => sessionsInterface.updateSession(
          sessionId: 's1',
          date: DateTime(2022, 1, 1),
          flashcardsType: FlashcardsType.remembered,
        ),
      ).thenAnswer((_) async => '');
    },
    act: (_) => bloc.add(SessionsEventUpdateSession(
      sessionId: 's1',
      date: DateTime(2022, 1, 1),
      flashcardsType: FlashcardsType.remembered,
    )),
    expect: () => [
      SessionsState(status: SessionsStatusLoading()),
      SessionsState(status: SessionsStatusSessionUpdated()),
    ],
    verify: (_) {
      verify(
        () => sessionsInterface.updateSession(
          sessionId: 's1',
          date: DateTime(2022, 1, 1),
          flashcardsType: FlashcardsType.remembered,
        ),
      ).called(1);
    },
  );

  blocTest(
    'update session, failure',
    build: () => bloc,
    setUp: () {
      when(
        () => sessionsInterface.updateSession(
          sessionId: 's1',
          date: DateTime(2022, 1, 1),
          flashcardsType: FlashcardsType.remembered,
        ),
      ).thenThrow('Error...');
    },
    act: (_) => bloc.add(SessionsEventUpdateSession(
      sessionId: 's1',
      date: DateTime(2022, 1, 1),
      flashcardsType: FlashcardsType.remembered,
    )),
    expect: () => [
      SessionsState(status: SessionsStatusLoading()),
      const SessionsState(status: SessionsStatusError(message: 'Error...')),
    ],
    verify: (_) {
      verify(
        () => sessionsInterface.updateSession(
          sessionId: 's1',
          date: DateTime(2022, 1, 1),
          flashcardsType: FlashcardsType.remembered,
        ),
      ).called(1);
    },
  );

  blocTest(
    'remove session, success',
    build: () => bloc,
    setUp: () {
      when(() => sessionsInterface.removeSession('s1'))
          .thenAnswer((_) async => '');
    },
    act: (_) => bloc.add(SessionsEventRemoveSession(sessionId: 's1')),
    expect: () => [
      SessionsState(status: SessionsStatusLoading()),
      SessionsState(status: SessionsStatusSessionRemoved()),
    ],
    verify: (_) {
      verify(() => sessionsInterface.removeSession('s1')).called(1);
    },
  );

  blocTest(
    'remove session, failure',
    build: () => bloc,
    setUp: () {
      when(() => sessionsInterface.removeSession('s1')).thenThrow('Error...');
    },
    act: (_) => bloc.add(SessionsEventRemoveSession(sessionId: 's1')),
    expect: () => [
      SessionsState(status: SessionsStatusLoading()),
      const SessionsState(status: SessionsStatusError(message: 'Error...')),
    ],
    verify: (_) {
      verify(() => sessionsInterface.removeSession('s1')).called(1);
    },
  );
}

import 'package:bloc_test/bloc_test.dart';
import 'package:fiszkomaniak/core/initialization_status.dart';
import 'package:fiszkomaniak/core/sessions/sessions_bloc.dart';
import 'package:fiszkomaniak/interfaces/sessions_interface.dart';
import 'package:fiszkomaniak/models/changed_document.dart';
import 'package:fiszkomaniak/models/date_model.dart';
import 'package:fiszkomaniak/models/session_model.dart';
import 'package:fiszkomaniak/models/time_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockSessionsInterface extends Mock implements SessionsInterface {}

void main() {
  final SessionsInterface sessionsInterface = MockSessionsInterface();
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
      doc: createSession(id: 's3', time: const Time(hour: 12, minute: 30)),
    ),
    ChangedDocument(
      changeType: DbDocChangeType.updated,
      doc: createSession(id: 's3', time: const Time(hour: 13, minute: 30)),
    ),
    ChangedDocument(
      changeType: DbDocChangeType.removed,
      doc: createSession(id: 's3'),
    )
  ];

  setUp(() {
    bloc = SessionsBloc(
      sessionsInterface: sessionsInterface,
    );
  });

  tearDown(() {
    reset(sessionsInterface);
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

  blocTest(
    'add session, success',
    build: () => bloc,
    setUp: () {
      when(() => sessionsInterface.addNewSession(createSession()))
          .thenAnswer((_) async => 's4');
    },
    act: (_) => bloc.add(SessionsEventAddSession(session: createSession())),
    expect: () => [
      SessionsState(status: SessionsStatusLoading()),
      const SessionsState(status: SessionsStatusSessionAdded(sessionId: 's4')),
    ],
    verify: (_) {
      verify(() => sessionsInterface.addNewSession(createSession())).called(1);
    },
  );

  blocTest(
    'add session, failure',
    build: () => bloc,
    setUp: () {
      when(() => sessionsInterface.addNewSession(createSession()))
          .thenThrow('Error...');
    },
    act: (_) => bloc.add(SessionsEventAddSession(session: createSession())),
    expect: () => [
      SessionsState(status: SessionsStatusLoading()),
      const SessionsState(status: SessionsStatusError(message: 'Error...')),
    ],
    verify: (_) {
      verify(() => sessionsInterface.addNewSession(createSession())).called(1);
    },
  );

  blocTest(
    'update session, success',
    build: () => bloc,
    setUp: () {
      when(
        () => sessionsInterface.updateSession(
          sessionId: 's1',
          date: const Date(year: 2022, month: 1, day: 1),
          flashcardsType: FlashcardsType.remembered,
        ),
      ).thenAnswer((_) async => '');
    },
    act: (_) => bloc.add(SessionsEventUpdateSession(
      sessionId: 's1',
      date: const Date(year: 2022, month: 1, day: 1),
      flashcardsType: FlashcardsType.remembered,
    )),
    expect: () => [
      SessionsState(status: SessionsStatusLoading()),
      const SessionsState(
        status: SessionsStatusSessionUpdated(sessionId: 's1'),
      ),
    ],
    verify: (_) {
      verify(
        () => sessionsInterface.updateSession(
          sessionId: 's1',
          date: const Date(year: 2022, month: 1, day: 1),
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
          date: const Date(year: 2022, month: 1, day: 1),
          flashcardsType: FlashcardsType.remembered,
        ),
      ).thenThrow('Error...');
    },
    act: (_) => bloc.add(SessionsEventUpdateSession(
      sessionId: 's1',
      date: const Date(year: 2022, month: 1, day: 1),
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
          date: const Date(year: 2022, month: 1, day: 1),
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
      const SessionsState(
        status: SessionsStatusSessionRemoved(sessionId: 's1'),
      ),
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

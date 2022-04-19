import 'package:bloc_test/bloc_test.dart';
import 'package:fiszkomaniak/core/sessions/sessions_bloc.dart';
import 'package:fiszkomaniak/core/sessions/sessions_event.dart';
import 'package:fiszkomaniak/core/sessions/sessions_state.dart';
import 'package:fiszkomaniak/core/sessions/sessions_status.dart';
import 'package:fiszkomaniak/interfaces/sessions_interface.dart';
import 'package:fiszkomaniak/models/changed_document.dart';
import 'package:fiszkomaniak/models/session_model.dart';
import 'package:flutter/material.dart';
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
    bloc = SessionsBloc(sessionsInterface: sessionsInterface);
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
        allSessions: [snapshots[0].doc],
        status: SessionsStatusLoaded(),
      ),
      SessionsState(
        allSessions: [snapshots[0].doc, snapshots[1].doc],
        status: SessionsStatusLoaded(),
      ),
      SessionsState(
        allSessions: [snapshots[0].doc, snapshots[1].doc, snapshots[2].doc],
        status: SessionsStatusLoaded(),
      ),
      SessionsState(
        allSessions: [snapshots[0].doc, snapshots[1].doc, snapshots[3].doc],
        status: SessionsStatusLoaded(),
      ),
      SessionsState(
        allSessions: [snapshots[0].doc, snapshots[1].doc],
        status: SessionsStatusLoaded(),
      ),
    ],
  );

  blocTest(
    'session added',
    build: () => bloc,
    act: (_) => bloc.add(SessionsEventSessionAdded(session: snapshots[0].doc)),
    expect: () => [
      SessionsState(
        allSessions: [snapshots[0].doc],
        status: SessionsStatusLoaded(),
      ),
    ],
  );

  blocTest(
    'session updated',
    build: () => bloc,
    act: (_) {
      bloc.add(SessionsEventSessionAdded(session: snapshots[2].doc));
      bloc.add(SessionsEventSessionUpdated(session: snapshots[3].doc));
    },
    expect: () => [
      SessionsState(
        allSessions: [snapshots[2].doc],
        status: SessionsStatusLoaded(),
      ),
      SessionsState(
        allSessions: [snapshots[3].doc],
        status: SessionsStatusLoaded(),
      ),
    ],
  );

  blocTest(
    'session removed',
    build: () => bloc,
    act: (_) {
      bloc.add(SessionsEventSessionAdded(session: snapshots[2].doc));
      bloc.add(SessionsEventSessionRemoved(sessionId: snapshots[2].doc.id));
    },
    expect: () => [
      SessionsState(
        allSessions: [snapshots[2].doc],
        status: SessionsStatusLoaded(),
      ),
      SessionsState(
        allSessions: [],
        status: SessionsStatusLoaded(),
      ),
    ],
  );

  blocTest(
    'add session, success',
    build: () => bloc,
    setUp: () {
      when(() => sessionsInterface.addNewSession(snapshots[0].doc))
          .thenAnswer((_) async => '');
    },
    act: (_) => bloc.add(SessionsEventAddSession(session: snapshots[0].doc)),
    expect: () => [
      SessionsState(status: SessionsStatusLoading()),
      SessionsState(status: SessionsStatusSessionAdded()),
    ],
    verify: (_) {
      verify(() => sessionsInterface.addNewSession(snapshots[0].doc)).called(1);
    },
  );

  blocTest(
    'add session, failure',
    build: () => bloc,
    setUp: () {
      when(() => sessionsInterface.addNewSession(snapshots[0].doc))
          .thenThrow('Error...');
    },
    act: (_) => bloc.add(SessionsEventAddSession(session: snapshots[0].doc)),
    expect: () => [
      SessionsState(status: SessionsStatusLoading()),
      const SessionsState(status: SessionsStatusError(message: 'Error...')),
    ],
    verify: (_) {
      verify(() => sessionsInterface.addNewSession(snapshots[0].doc)).called(1);
    },
  );
}

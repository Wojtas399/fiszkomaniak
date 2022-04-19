import 'package:fiszkomaniak/core/sessions/sessions_state.dart';
import 'package:fiszkomaniak/core/sessions/sessions_status.dart';
import 'package:fiszkomaniak/models/session_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late SessionsState state;
  final List<Session> sessions = [
    createSession(id: 's1'),
    createSession(id: 's2'),
  ];

  setUp(() {
    state = const SessionsState();
  });

  test('initial state', () {
    expect(state.allSessions, []);
    expect(state.status, const SessionsStatusInitial());
  });

  test('copy with all sessions', () {
    final SessionsState state2 = state.copyWith(allSessions: sessions);
    final SessionsState state3 = state2.copyWith();

    expect(state2.allSessions, sessions);
    expect(state3.allSessions, sessions);
  });

  test('copy with status', () {
    final SessionsState state2 = state.copyWith(
      status: SessionsStatusLoading(),
    );
    final SessionsState state3 = state2.copyWith();

    expect(state2.status, SessionsStatusLoading());
    expect(state3.status, SessionsStatusLoaded());
  });

  test('get session by id, session exists', () {
    final SessionsState updatedState = state.copyWith(allSessions: sessions);

    final Session? session = updatedState.getSessionById('s1');

    expect(session, sessions[0]);
  });

  test('get session by id, session does not exist', () {
    final SessionsState updatedState = state.copyWith(allSessions: sessions);

    final Session? session = updatedState.getSessionById('s3');

    expect(session, null);
  });
}

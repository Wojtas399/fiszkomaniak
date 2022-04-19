import 'dart:async';
import 'package:fiszkomaniak/core/sessions/sessions_event.dart';
import 'package:fiszkomaniak/core/sessions/sessions_state.dart';
import 'package:fiszkomaniak/core/sessions/sessions_status.dart';
import 'package:fiszkomaniak/interfaces/sessions_interface.dart';
import 'package:fiszkomaniak/models/session_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/changed_document.dart';

class SessionsBloc extends Bloc<SessionsEvent, SessionsState> {
  late final SessionsInterface _sessionsInterface;
  StreamSubscription? _sessionsSubscription;

  SessionsBloc({
    required SessionsInterface sessionsInterface,
  }) : super(const SessionsState()) {
    _sessionsInterface = sessionsInterface;
    on<SessionsEventInitialize>(_initialize);
    on<SessionsEventSessionAdded>(_sessionAdded);
    on<SessionsEventSessionUpdated>(_sessionUpdated);
    on<SessionsEventSessionRemoved>(_sessionRemoved);
    on<SessionsEventAddSession>(_addSession);
  }

  void _initialize(
    SessionsEventInitialize event,
    Emitter<SessionsState> emit,
  ) {
    _sessionsSubscription = _sessionsInterface.getSessionsSnapshots().listen(
      (sessions) {
        for (final session in sessions) {
          switch (session.changeType) {
            case DbDocChangeType.added:
              add(SessionsEventSessionAdded(session: session.doc));
              break;
            case DbDocChangeType.updated:
              add(SessionsEventSessionUpdated(session: session.doc));
              break;
            case DbDocChangeType.removed:
              add(SessionsEventSessionRemoved(sessionId: session.doc.id));
              break;
          }
        }
      },
    );
  }

  void _sessionAdded(
    SessionsEventSessionAdded event,
    Emitter<SessionsState> emit,
  ) {
    emit(state.copyWith(
      allSessions: [
        ...state.allSessions,
        event.session,
      ],
    ));
  }

  void _sessionUpdated(
    SessionsEventSessionUpdated event,
    Emitter<SessionsState> emit,
  ) {
    final List<Session> allSessions = [...state.allSessions];
    final int index = allSessions.indexWhere(
      (session) => session.id == event.session.id,
    );
    allSessions[index] = event.session;
    emit(state.copyWith(allSessions: allSessions));
  }

  void _sessionRemoved(
    SessionsEventSessionRemoved event,
    Emitter<SessionsState> emit,
  ) {
    final List<Session> allSessions = [...state.allSessions];
    allSessions.removeWhere((session) => session.id == event.sessionId);
    emit(state.copyWith(allSessions: allSessions));
  }

  Future<void> _addSession(
    SessionsEventAddSession event,
    Emitter<SessionsState> emit,
  ) async {
    try {
      emit(state.copyWith(status: SessionsStatusLoading()));
      await _sessionsInterface.addNewSession(event.session);
      emit(state.copyWith(status: SessionsStatusSessionAdded()));
    } catch (error) {
      emit(state.copyWith(
        status: SessionsStatusError(message: error.toString()),
      ));
    }
  }

  @override
  Future<void> close() {
    _sessionsSubscription?.cancel();
    return super.close();
  }
}

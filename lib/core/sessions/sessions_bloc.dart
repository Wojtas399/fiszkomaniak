import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:fiszkomaniak/core/initialization_status.dart';
import 'package:fiszkomaniak/interfaces/sessions_interface.dart';
import 'package:fiszkomaniak/models/date_model.dart';
import 'package:fiszkomaniak/models/session_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/changed_document.dart';
import '../../models/time_model.dart';

part 'sessions_event.dart';

part 'sessions_state.dart';

part 'sessions_status.dart';

class SessionsBloc extends Bloc<SessionsEvent, SessionsState> {
  late final SessionsInterface _sessionsInterface;
  StreamSubscription? _sessionsSubscription;

  SessionsBloc({
    required SessionsInterface sessionsInterface,
  }) : super(const SessionsState()) {
    _sessionsInterface = sessionsInterface;
    on<SessionsEventInitialize>(_initialize);
    on<SessionsEventSessionsChanged>(_sessionsChanged);
    on<SessionsEventAddSession>(_addSession);
    on<SessionsEventRemoveSession>(_removeSession);
    on<SessionsEventUpdateSession>(_updateSession);
  }

  @override
  Future<void> close() {
    _sessionsSubscription?.cancel();
    return super.close();
  }

  void _initialize(
    SessionsEventInitialize event,
    Emitter<SessionsState> emit,
  ) {
    _sessionsSubscription = _sessionsInterface.getSessionsSnapshots().listen(
      (sessions) {
        final GroupedDbDocuments<Session> groupedDocuments =
            groupDbDocuments<Session>(sessions);
        add(SessionsEventSessionsChanged(
          addedSessions: groupedDocuments.addedDocuments,
          updatedSessions: groupedDocuments.updatedDocuments,
          deletedSessions: groupedDocuments.removedDocuments,
        ));
      },
    );
  }

  void _sessionsChanged(
    SessionsEventSessionsChanged event,
    Emitter<SessionsState> emit,
  ) {
    final List<Session> newSessions = [...state.allSessions];
    newSessions.addAll(event.addedSessions);
    for (final updatedSession in event.updatedSessions) {
      final int index = newSessions.indexWhere(
        (session) => session.id == updatedSession.id,
      );
      newSessions[index] = updatedSession;
    }
    for (final deletedSession in event.deletedSessions) {
      newSessions.removeWhere((session) => session.id == deletedSession.id);
    }
    emit(state.copyWith(
      allSessions: newSessions,
      initializationStatus: InitializationStatus.ready,
    ));
  }

  Future<void> _addSession(
    SessionsEventAddSession event,
    Emitter<SessionsState> emit,
  ) async {
    try {
      emit(state.copyWith(status: SessionsStatusLoading()));
      final String id = await _sessionsInterface.addNewSession(event.session);
      emit(state.copyWith(status: SessionsStatusSessionAdded(sessionId: id)));
    } catch (error) {
      emit(state.copyWith(
        status: SessionsStatusError(message: error.toString()),
      ));
    }
  }

  Future<void> _updateSession(
    SessionsEventUpdateSession event,
    Emitter<SessionsState> emit,
  ) async {
    try {
      emit(state.copyWith(status: SessionsStatusLoading()));
      await _sessionsInterface.updateSession(
        sessionId: event.sessionId,
        groupId: event.groupId,
        flashcardsType: event.flashcardsType,
        areQuestionsAndAnswersSwapped: event.areQuestionsAndFlashcardsSwapped,
        date: event.date,
        time: event.time,
        duration: event.duration,
        notificationTime: event.notificationTime,
      );
      emit(state.copyWith(
        status: SessionsStatusSessionUpdated(sessionId: event.sessionId),
      ));
    } catch (error) {
      emit(state.copyWith(
        status: SessionsStatusError(message: error.toString()),
      ));
    }
  }

  Future<void> _removeSession(
    SessionsEventRemoveSession event,
    Emitter<SessionsState> emit,
  ) async {
    try {
      emit(state.copyWith(status: SessionsStatusLoading()));
      await _sessionsInterface.removeSession(event.sessionId);
      emit(state.copyWith(
        status: SessionsStatusSessionRemoved(
          sessionId: event.sessionId,
          hasSessionBeenRemovedAfterLearningProcess:
              event.removeAfterLearningProcess,
        ),
      ));
    } catch (error) {
      emit(state.copyWith(
        status: SessionsStatusError(message: error.toString()),
      ));
    }
  }
}

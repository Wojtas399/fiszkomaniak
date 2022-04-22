import 'dart:async';
import 'package:fiszkomaniak/core/courses/courses_bloc.dart';
import 'package:fiszkomaniak/core/groups/groups_bloc.dart';
import 'package:fiszkomaniak/core/sessions/sessions_bloc.dart';
import 'package:fiszkomaniak/core/sessions/sessions_event.dart';
import 'package:fiszkomaniak/features/session_preview/bloc/session_preview_dialogs.dart';
import 'package:fiszkomaniak/features/session_preview/bloc/session_preview_event.dart';
import 'package:fiszkomaniak/features/session_preview/bloc/session_preview_state.dart';
import 'package:fiszkomaniak/models/group_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../models/session_model.dart';

class SessionPreviewBloc
    extends Bloc<SessionPreviewEvent, SessionPreviewState> {
  late final CoursesBloc _coursesBloc;
  late final GroupsBloc _groupsBloc;
  late final SessionsBloc _sessionsBloc;
  late final SessionPreviewDialogs _sessionPreviewDialogs;
  StreamSubscription? _sessionsStateSubscription;

  SessionPreviewBloc({
    required CoursesBloc coursesBloc,
    required GroupsBloc groupsBloc,
    required SessionsBloc sessionsBloc,
    required SessionPreviewDialogs sessionPreviewDialogs,
  }) : super(const SessionPreviewState()) {
    _coursesBloc = coursesBloc;
    _groupsBloc = groupsBloc;
    _sessionsBloc = sessionsBloc;
    _sessionPreviewDialogs = sessionPreviewDialogs;
    on<SessionPreviewEventInitialize>(_initialize);
    on<SessionPreviewEventDurationChanged>(_durationChanged);
    on<SessionPreviewEventFlashcardsTypeChanged>(_flashcardsTypeChanged);
    on<SessionPreviewEventSwapQuestionsAndAnswers>(_swapQuestionsAndAnswers);
    on<SessionPreviewEventEditSession>(_editSession);
    on<SessionPreviewEventDeleteSession>(_deleteSession);
    on<SessionPreviewEventStartLearning>(_startLearning);
    on<SessionPreviewEventSessionsStateUpdated>(_sessionsStateUpdated);
  }

  void _initialize(
    SessionPreviewEventInitialize event,
    Emitter<SessionPreviewState> emit,
  ) {
    final Session? session = _sessionsBloc.state.getSessionById(
      event.sessionId,
    );
    final Group? group = _groupsBloc.state.getGroupById(session?.groupId);
    final String? courseName = _coursesBloc.state.getCourseNameById(
      group?.courseId,
    );
    if (session != null && group != null && courseName != null) {
      emit(state.copyWith(
        mode: event.mode ?? SessionMode.normal,
        session: session,
        group: group,
        courseName: courseName,
        duration: session.duration,
        flashcardsType: session.flashcardsType,
        areQuestionsAndAnswersSwapped: session.areQuestionsAndAnswersSwapped,
      ));
    }
    _setSessionsStateListener();
  }

  void _durationChanged(
    SessionPreviewEventDurationChanged event,
    Emitter<SessionPreviewState> emit,
  ) {
    emit(state.copyWith(duration: event.duration));
  }

  void _flashcardsTypeChanged(
    SessionPreviewEventFlashcardsTypeChanged event,
    Emitter<SessionPreviewState> emit,
  ) {
    emit(state.copyWith(
      flashcardsType: event.flashcardsType,
      duration: state.duration,
    ));
  }

  void _swapQuestionsAndAnswers(
    SessionPreviewEventSwapQuestionsAndAnswers event,
    Emitter<SessionPreviewState> emit,
  ) {
    final bool? areQuestionsAndAnswersSwapped =
        state.areQuestionsAndAnswersSwapped;
    if (areQuestionsAndAnswersSwapped != null) {
      emit(state.copyWith(
        areQuestionsAndAnswersSwapped: !areQuestionsAndAnswersSwapped,
        duration: state.duration,
      ));
    }
  }

  void _editSession(
    SessionPreviewEventEditSession event,
    Emitter<SessionPreviewState> emit,
  ) {
    //TODO
  }

  Future<void> _deleteSession(
    SessionPreviewEventDeleteSession event,
    Emitter<SessionPreviewState> emit,
  ) async {
    final Session? session = state.session;
    final bool confirmation =
        await _sessionPreviewDialogs.askForDeleteConfirmation();
    if (confirmation && session != null) {
      _sessionsBloc.add(SessionsEventRemoveSession(sessionId: session.id));
    }
  }

  void _startLearning(
    SessionPreviewEventStartLearning event,
    Emitter<SessionPreviewState> emit,
  ) {
    //TODO
  }

  void _sessionsStateUpdated(
    SessionPreviewEventSessionsStateUpdated event,
    Emitter<SessionPreviewState> emit,
  ) {
    final String? sessionId = state.session?.id;
    if (sessionId != null) {
      final Session? updatedSession = _sessionsBloc.state.getSessionById(
        sessionId,
      );
      if (updatedSession != null) {
        emit(state.copyWith(session: updatedSession));
      }
    }
  }

  void _setSessionsStateListener() {
    _sessionsStateSubscription = _sessionsBloc.stream.listen((_) {
      add(SessionPreviewEventSessionsStateUpdated());
    });
  }

  @override
  Future<void> close() {
    _sessionsStateSubscription?.cancel();
    return super.close();
  }
}

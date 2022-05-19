import 'dart:async';
import 'package:fiszkomaniak/config/navigation.dart';
import 'package:fiszkomaniak/core/courses/courses_bloc.dart';
import 'package:fiszkomaniak/core/groups/groups_bloc.dart';
import 'package:fiszkomaniak/core/sessions/sessions_bloc.dart';
import 'package:fiszkomaniak/core/sessions/sessions_event.dart';
import 'package:fiszkomaniak/features/session_creator/bloc/session_creator_mode.dart';
import 'package:fiszkomaniak/features/session_preview/bloc/session_preview_dialogs.dart';
import 'package:fiszkomaniak/features/session_preview/bloc/session_preview_event.dart';
import 'package:fiszkomaniak/features/session_preview/bloc/session_preview_mode.dart';
import 'package:fiszkomaniak/features/session_preview/bloc/session_preview_state.dart';
import 'package:fiszkomaniak/models/group_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../models/session_model.dart';
import '../../learning_process/learning_process_data.dart';

class SessionPreviewBloc
    extends Bloc<SessionPreviewEvent, SessionPreviewState> {
  late final CoursesBloc _coursesBloc;
  late final GroupsBloc _groupsBloc;
  late final SessionsBloc _sessionsBloc;
  late final SessionPreviewDialogs _sessionPreviewDialogs;
  late final Navigation _navigation;
  StreamSubscription? _sessionsStateSubscription;

  SessionPreviewBloc({
    required CoursesBloc coursesBloc,
    required GroupsBloc groupsBloc,
    required SessionsBloc sessionsBloc,
    required SessionPreviewDialogs sessionPreviewDialogs,
    required Navigation navigation,
  }) : super(const SessionPreviewState()) {
    _coursesBloc = coursesBloc;
    _groupsBloc = groupsBloc;
    _sessionsBloc = sessionsBloc;
    _sessionPreviewDialogs = sessionPreviewDialogs;
    _navigation = navigation;
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
    final SessionPreviewMode mode = event.mode;
    if (mode is SessionPreviewModeNormal) {
      _initializeNormalMode(mode, emit);
    } else if (mode is SessionPreviewModeQuick) {
      _initializeQuickMode(mode, emit);
    }
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
    emit(state.copyWith(
      areQuestionsAndAnswersSwapped: !state.areQuestionsAndAnswersSwapped,
      duration: state.duration,
    ));
  }

  void _editSession(
    SessionPreviewEventEditSession event,
    Emitter<SessionPreviewState> emit,
  ) {
    final Session? session = state.session;
    if (session != null) {
      _navigation.navigateToSessionCreator(
        SessionCreatorEditMode(session: session),
      );
    }
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
    final Group? group = state.group;
    if (group != null) {
      _navigation.navigateToLearningProcess(LearningProcessData(
        groupId: group.id,
        flashcardsType: state.flashcardsType,
        areQuestionsAndAnswersSwapped: state.areQuestionsAndAnswersSwapped,
        sessionId: state.session?.id,
        duration: state.duration,
      ));
    }
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
        emit(state.copyWith(
          session: updatedSession,
          duration: updatedSession.duration,
        ));
      }
    }
  }

  void _initializeNormalMode(
    SessionPreviewModeNormal mode,
    Emitter<SessionPreviewState> emit,
  ) {
    final Session? session = _sessionsBloc.state.getSessionById(
      mode.sessionId,
    );
    final Group? group = _groupsBloc.state.getGroupById(session?.groupId);
    final String? courseName = _coursesBloc.state.getCourseNameById(
      group?.courseId,
    );
    if (session != null && group != null && courseName != null) {
      emit(state.copyWith(
        mode: mode,
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

  void _initializeQuickMode(
    SessionPreviewModeQuick mode,
    Emitter<SessionPreviewState> emit,
  ) {
    final Group? group = _groupsBloc.state.getGroupById(mode.groupId);
    final String? courseName = _coursesBloc.state.getCourseNameById(
      group?.courseId,
    );
    if (group != null && courseName != null) {
      emit(state.copyWith(
        mode: mode,
        group: group,
        courseName: courseName,
        flashcardsType: FlashcardsType.all,
        areQuestionsAndAnswersSwapped: false,
      ));
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

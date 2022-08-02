import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:fiszkomaniak/domain/use_cases/courses/get_course_use_case.dart';
import 'package:fiszkomaniak/domain/use_cases/groups/get_group_use_case.dart';
import 'package:fiszkomaniak/domain/use_cases/sessions/get_session_use_case.dart';
import 'package:fiszkomaniak/domain/use_cases/sessions/remove_session_use_case.dart';
import 'package:fiszkomaniak/features/session_preview/session_preview_dialogs.dart';
import 'package:fiszkomaniak/features/session_preview/bloc/session_preview_mode.dart';
import 'package:fiszkomaniak/domain/entities/group.dart';
import 'package:fiszkomaniak/models/bloc_status.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../models/date_model.dart';
import '../../../domain/entities/session.dart';
import '../../../utils/group_utils.dart';

part 'session_preview_event.dart';

part 'session_preview_state.dart';

class SessionPreviewBloc
    extends Bloc<SessionPreviewEvent, SessionPreviewState> {
  late final GetSessionUseCase _getSessionUseCase;
  late final GetGroupUseCase _getGroupUseCase;
  late final GetCourseUseCase _getCourseUseCase;
  late final RemoveSessionUseCase _removeSessionUseCase;
  late final SessionPreviewDialogs _sessionPreviewDialogs;
  StreamSubscription<Session>? _sessionListener;

  SessionPreviewBloc({
    required GetSessionUseCase getSessionUseCase,
    required GetGroupUseCase getGroupUseCase,
    required GetCourseUseCase getCourseUseCase,
    required RemoveSessionUseCase removeSessionUseCase,
    required SessionPreviewDialogs sessionPreviewDialogs,
    BlocStatus status = const BlocStatusInitial(),
    SessionPreviewMode? mode,
    Session? session,
    Group? group,
    String? courseName,
    Duration? duration,
    FlashcardsType flashcardsType = FlashcardsType.all,
    bool areQuestionsAndAnswersSwapped = false,
  }) : super(
          SessionPreviewState(
            status: status,
            mode: mode,
            session: session,
            group: group,
            courseName: courseName,
            duration: duration,
            flashcardsType: flashcardsType,
            areQuestionsAndAnswersSwapped: areQuestionsAndAnswersSwapped,
          ),
        ) {
    _getSessionUseCase = getSessionUseCase;
    _getGroupUseCase = getGroupUseCase;
    _getCourseUseCase = getCourseUseCase;
    _removeSessionUseCase = removeSessionUseCase;
    _sessionPreviewDialogs = sessionPreviewDialogs;
    on<SessionPreviewEventInitialize>(_initialize);
    on<SessionPreviewEventSessionUpdated>(_sessionUpdated);
    on<SessionPreviewEventDurationChanged>(_durationChanged);
    on<SessionPreviewEventResetDuration>(_resetDuration);
    on<SessionPreviewEventFlashcardsTypeChanged>(_flashcardsTypeChanged);
    on<SessionPreviewEventSwapQuestionsAndAnswers>(_swapQuestionsAndAnswers);
    on<SessionPreviewEventRemoveSession>(_removeSession);
  }

  @override
  Future<void> close() {
    _sessionListener?.cancel();
    return super.close();
  }

  Future<void> _initialize(
    SessionPreviewEventInitialize event,
    Emitter<SessionPreviewState> emit,
  ) async {
    final SessionPreviewMode mode = event.mode;
    emit(state.copyWith(status: const BlocStatusLoading()));
    if (mode is SessionPreviewModeNormal) {
      await _initializeNormalMode(mode, emit);
    } else if (mode is SessionPreviewModeQuick) {
      await _initializeQuickMode(mode, emit);
    }
  }

  Future<void> _sessionUpdated(
    SessionPreviewEventSessionUpdated event,
    Emitter<SessionPreviewState> emit,
  ) async {
    final Group group = await _getGroup(event.session.groupId);
    final String courseName = await _getCourseName(group.courseId);
    emit(state.copyWith(
      session: event.session,
      group: group,
      courseName: courseName,
      duration: event.session.duration,
      flashcardsType: event.session.flashcardsType,
      areQuestionsAndAnswersSwapped:
          event.session.areQuestionsAndAnswersSwapped,
    ));
  }

  void _durationChanged(
    SessionPreviewEventDurationChanged event,
    Emitter<SessionPreviewState> emit,
  ) {
    emit(state.copyWith(
      duration: event.duration,
    ));
  }

  void _resetDuration(
    SessionPreviewEventResetDuration event,
    Emitter<SessionPreviewState> emit,
  ) {
    emit(state.copyWithDurationAsNull());
  }

  void _flashcardsTypeChanged(
    SessionPreviewEventFlashcardsTypeChanged event,
    Emitter<SessionPreviewState> emit,
  ) {
    emit(state.copyWith(
      flashcardsType: event.flashcardsType,
    ));
  }

  void _swapQuestionsAndAnswers(
    SessionPreviewEventSwapQuestionsAndAnswers event,
    Emitter<SessionPreviewState> emit,
  ) {
    emit(state.copyWith(
      areQuestionsAndAnswersSwapped: !state.areQuestionsAndAnswersSwapped,
    ));
  }

  Future<void> _removeSession(
    SessionPreviewEventRemoveSession event,
    Emitter<SessionPreviewState> emit,
  ) async {
    final Session? session = state.session;
    if (session != null && await _hasSessionRemovalBeenConfirmed()) {
      emit(state.copyWith(status: const BlocStatusLoading()));
      await _removeSessionUseCase.execute(sessionId: session.id);
      emit(state.copyWith(
        status: const BlocStatusComplete<SessionPreviewInfoType>(
          info: SessionPreviewInfoType.sessionHasBeenDeleted,
        ),
      ));
    }
  }

  Future<void> _initializeNormalMode(
    SessionPreviewModeNormal mode,
    Emitter<SessionPreviewState> emit,
  ) async {
    _setSessionListener(mode.sessionId);
    emit(state.copyWith(
      mode: mode,
    ));
  }

  Future<void> _initializeQuickMode(
    SessionPreviewModeQuick mode,
    Emitter<SessionPreviewState> emit,
  ) async {
    final Group group = await _getGroup(mode.groupId);
    final String courseName = await _getCourseName(group.courseId);
    emit(state.copyWith(
      mode: mode,
      group: group,
      courseName: courseName,
    ));
  }

  void _setSessionListener(String sessionId) {
    _sessionListener = _getSessionUseCase.execute(sessionId: sessionId).listen(
          (session) => add(
            SessionPreviewEventSessionUpdated(session: session),
          ),
        );
  }

  Future<Group> _getGroup(String groupId) async {
    return _getGroupUseCase.execute(groupId: groupId).first;
  }

  Future<String> _getCourseName(String courseId) async {
    return _getCourseUseCase
        .execute(courseId: courseId)
        .map((course) => course.name)
        .first;
  }

  Future<bool> _hasSessionRemovalBeenConfirmed() async {
    return await _sessionPreviewDialogs.askForDeleteConfirmation();
  }
}

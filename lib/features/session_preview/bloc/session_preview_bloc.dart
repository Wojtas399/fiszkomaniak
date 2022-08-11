import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../domain/entities/course.dart';
import '../../../domain/entities/group.dart';
import '../../../domain/entities/session.dart';
import '../../../domain/use_cases/courses/get_course_use_case.dart';
import '../../../domain/use_cases/groups/get_group_use_case.dart';
import '../../../domain/use_cases/sessions/get_session_use_case.dart';
import '../../../domain/use_cases/sessions/delete_session_use_case.dart';
import '../../../models/bloc_status.dart';
import '../../../models/date_model.dart';
import '../../../utils/group_utils.dart';
import 'session_preview_mode.dart';

part 'session_preview_event.dart';

part 'session_preview_state.dart';

class SessionPreviewBloc
    extends Bloc<SessionPreviewEvent, SessionPreviewState> {
  late final GetSessionUseCase _getSessionUseCase;
  late final GetGroupUseCase _getGroupUseCase;
  late final GetCourseUseCase _getCourseUseCase;
  late final DeleteSessionUseCase _deleteSessionUseCase;
  StreamSubscription<Session>? _sessionListener;

  SessionPreviewBloc({
    required GetSessionUseCase getSessionUseCase,
    required GetGroupUseCase getGroupUseCase,
    required GetCourseUseCase getCourseUseCase,
    required DeleteSessionUseCase deleteSessionUseCase,
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
    _deleteSessionUseCase = deleteSessionUseCase;
    on<SessionPreviewEventInitialize>(_initialize);
    on<SessionPreviewEventSessionUpdated>(_sessionUpdated);
    on<SessionPreviewEventDurationChanged>(_durationChanged);
    on<SessionPreviewEventResetDuration>(_resetDuration);
    on<SessionPreviewEventFlashcardsTypeChanged>(_flashcardsTypeChanged);
    on<SessionPreviewEventSwapQuestionsAndAnswers>(_swapQuestionsAndAnswers);
    on<SessionPreviewEventDeleteSession>(_deleteSession);
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
    emit(state.copyWith(
      status: const BlocStatusLoading(),
    ));
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
    emit(state.copyWith(
      durationAsNull: true,
    ));
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

  Future<void> _deleteSession(
    SessionPreviewEventDeleteSession event,
    Emitter<SessionPreviewState> emit,
  ) async {
    final String? sessionId = state.session?.id;
    if (sessionId != null) {
      emit(state.copyWith(status: const BlocStatusLoading()));
      await _deleteSessionUseCase.execute(sessionId: sessionId);
      emit(state.copyWithInfo(
        SessionPreviewInfo.sessionHasBeenDeleted,
      ));
    }
  }

  Future<void> _initializeNormalMode(
    SessionPreviewModeNormal mode,
    Emitter<SessionPreviewState> emit,
  ) async {
    _setSessionListener(mode.sessionId);
    emit(state.copyWith(
      status: const BlocStatusComplete(),
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
      status: const BlocStatusComplete(),
      mode: mode,
      group: group,
      courseName: courseName,
    ));
  }

  void _setSessionListener(String sessionId) {
    _sessionListener ??=
        _getSessionUseCase.execute(sessionId: sessionId).listen(
              (Session session) => add(
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
        .map((Course course) => course.name)
        .first;
  }
}

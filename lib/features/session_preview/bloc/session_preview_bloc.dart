import 'dart:async';

import 'package:fiszkomaniak/core/courses/courses_bloc.dart';
import 'package:fiszkomaniak/core/groups/groups_bloc.dart';
import 'package:fiszkomaniak/core/sessions/sessions_bloc.dart';
import 'package:fiszkomaniak/core/sessions/sessions_event.dart';
import 'package:fiszkomaniak/features/session_preview/bloc/session_preview_dialogs.dart';
import 'package:fiszkomaniak/features/session_preview/bloc/session_preview_event.dart';
import 'package:fiszkomaniak/features/session_preview/bloc/session_preview_state.dart';
import 'package:fiszkomaniak/models/group_model.dart';
import 'package:flutter/material.dart';
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
    on<SessionPreviewEventTimeChanged>(_timeChanged);
    on<SessionPreviewEventDurationChanged>(_durationChanged);
    on<SessionPreviewEventNotificationTimeChanged>(_notificationTimeChanged);
    on<SessionPreviewEventFlashcardsTypeChanged>(_flashcardsTypeChanged);
    on<SessionPreviewEventSwapQuestionsAndAnswers>(_swapQuestionsAndAnswers);
    on<SessionPreviewEventResetChanges>(_resetChanges);
    on<SessionPreviewEventSaveChanges>(_saveChanges);
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
        time: session.time,
        duration: session.duration,
        notificationTime: session.notificationTime,
        flashcardsType: session.flashcardsType,
        areQuestionsAndAnswersSwapped: session.areQuestionsAndAnswersSwapped,
      ));
    }
    _setSessionsStateListener();
  }

  void _timeChanged(
    SessionPreviewEventTimeChanged event,
    Emitter<SessionPreviewState> emit,
  ) {
    emit(state.copyWith(
      time: event.time,
      duration: state.duration,
      notificationTime: state.notificationTime,
    ));
  }

  void _durationChanged(
    SessionPreviewEventDurationChanged event,
    Emitter<SessionPreviewState> emit,
  ) {
    emit(state.copyWith(
      duration: event.duration,
      notificationTime: state.notificationTime,
    ));
  }

  void _notificationTimeChanged(
    SessionPreviewEventNotificationTimeChanged event,
    Emitter<SessionPreviewState> emit,
  ) {
    emit(state.copyWith(
      notificationTime: event.notificationTime,
      duration: state.duration,
    ));
  }

  void _flashcardsTypeChanged(
    SessionPreviewEventFlashcardsTypeChanged event,
    Emitter<SessionPreviewState> emit,
  ) {
    emit(state.copyWith(
      flashcardsType: event.flashcardsType,
      duration: state.duration,
      notificationTime: state.notificationTime,
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
        notificationTime: state.notificationTime,
      ));
    }
  }

  void _resetChanges(
    SessionPreviewEventResetChanges event,
    Emitter<SessionPreviewState> emit,
  ) {
    emit(state.copyWith(
      time: state.session?.time,
      duration: state.session?.duration,
      notificationTime: state.session?.notificationTime,
      flashcardsType: state.session?.flashcardsType,
      areQuestionsAndAnswersSwapped:
          state.session?.areQuestionsAndAnswersSwapped,
    ));
  }

  Future<void> _saveChanges(
    SessionPreviewEventSaveChanges event,
    Emitter<SessionPreviewState> emit,
  ) async {
    if (state.mode == SessionMode.normal) {
      if (_isTodayTimeIncorrect()) {
        await _sessionPreviewDialogs.showMessageAboutWrongTimeFromToday();
      } else {
        //TODO
      }
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

  bool _isTodayTimeIncorrect() {
    final DateTime? date = state.session?.date;
    final DateTime nowDate = DateTime.now();
    final TimeOfDay? time = state.time;
    final TimeOfDay nowTime = TimeOfDay.now();
    return date?.year == nowDate.year &&
        date?.month == nowDate.month &&
        date?.day == nowDate.day &&
        time != null &&
        time.hour <= nowTime.hour &&
        time.minute < nowTime.minute;
  }

  @override
  Future<void> close() {
    _sessionsStateSubscription?.cancel();
    return super.close();
  }
}

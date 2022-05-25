import 'package:fiszkomaniak/core/courses/courses_bloc.dart';
import 'package:fiszkomaniak/core/groups/groups_bloc.dart';
import 'package:fiszkomaniak/core/sessions/sessions_bloc.dart';
import 'package:fiszkomaniak/features/session_creator/bloc/session_creator_event.dart';
import 'package:fiszkomaniak/features/session_creator/bloc/session_creator_mode.dart';
import 'package:fiszkomaniak/features/session_creator/bloc/session_creator_state.dart';
import 'package:fiszkomaniak/features/session_creator/bloc/session_creator_status.dart';
import 'package:fiszkomaniak/models/group_model.dart';
import 'package:fiszkomaniak/models/session_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../models/course_model.dart';
import '../../../utils/time_utils.dart';

class SessionCreatorBloc
    extends Bloc<SessionCreatorEvent, SessionCreatorState> {
  late final CoursesBloc _coursesBloc;
  late final GroupsBloc _groupsBloc;
  late final SessionsBloc _sessionsBloc;

  SessionCreatorBloc({
    required CoursesBloc coursesBloc,
    required GroupsBloc groupsBloc,
    required SessionsBloc sessionsBloc,
  }) : super(const SessionCreatorState()) {
    _coursesBloc = coursesBloc;
    _groupsBloc = groupsBloc;
    _sessionsBloc = sessionsBloc;
    on<SessionCreatorEventInitialize>(_initialize);
    on<SessionCreatorEventCourseSelected>(_courseSelected);
    on<SessionCreatorEventGroupSelected>(_groupSelected);
    on<SessionCreatorEventFlashcardsTypeSelected>(_flashcardsTypeSelected);
    on<SessionCreatorEventSwapQuestionsWithAnswers>(_swapQuestionsWithAnswers);
    on<SessionCreatorEventDateSelected>(_dateSelected);
    on<SessionCreatorEventTimeSelected>(_timeSelected);
    on<SessionCreatorEventDurationSelected>(_durationSelected);
    on<SessionCreatorEventNotificationTimeSelected>(_notificationTimeSelected);
    on<SessionCreatorEventCleanDurationTime>(_cleanDurationTime);
    on<SessionCreatorEventCleanNotificationTime>(_cleanNotificationTime);
    on<SessionCreatorEventSubmit>(_submit);
  }

  void _initialize(
    SessionCreatorEventInitialize event,
    Emitter<SessionCreatorState> emit,
  ) {
    final SessionCreatorMode mode = event.mode;
    if (mode is SessionCreatorCreateMode) {
      _initializeCreateMode(emit);
    } else if (mode is SessionCreatorEditMode) {
      _initializeEditMode(mode, emit);
    }
  }

  void _courseSelected(
    SessionCreatorEventCourseSelected event,
    Emitter<SessionCreatorState> emit,
  ) {
    final Course? course = _coursesBloc.state.getCourseById(event.courseId);
    if (course != null) {
      final List<Group> groupsFromCourse =
          _groupsBloc.state.getGroupsByCourseId(event.courseId);
      if (state.selectedCourse != course && state.selectedCourse != null) {
        emit(state.reset(selectedGroup: true));
      }
      emit(state.copyWith(
        selectedCourse: course,
        groups: groupsFromCourse.where(_areThereFlashcardsInGroup).toList(),
      ));
    }
  }

  void _groupSelected(
    SessionCreatorEventGroupSelected event,
    Emitter<SessionCreatorState> emit,
  ) {
    final Group? group = _groupsBloc.state.getGroupById(event.groupId);
    if (group != null) {
      emit(state.copyWith(selectedGroup: group));
    }
  }

  void _flashcardsTypeSelected(
    SessionCreatorEventFlashcardsTypeSelected event,
    Emitter<SessionCreatorState> emit,
  ) {
    emit(state.copyWith(flashcardsType: event.type));
  }

  void _swapQuestionsWithAnswers(
    SessionCreatorEventSwapQuestionsWithAnswers event,
    Emitter<SessionCreatorState> emit,
  ) {
    if (state.selectedGroup != null) {
      emit(state.copyWith(
        areQuestionsAndAnswersSwapped: !state.areQuestionsAndAnswersSwapped,
      ));
    }
  }

  void _dateSelected(
    SessionCreatorEventDateSelected event,
    Emitter<SessionCreatorState> emit,
  ) {
    emit(state.copyWith(date: event.date));
  }

  Future<void> _timeSelected(
    SessionCreatorEventTimeSelected event,
    Emitter<SessionCreatorState> emit,
  ) async {
    final DateTime? date = state.date;
    final TimeOfDay? notificationTime = state.notificationTime;
    if (date != null && TimeUtils.isPastTime(event.time, date)) {
      emit(state.copyWith(status: SessionCreatorStatusTimeFromThePast()));
    } else if (notificationTime != null &&
        TimeUtils.isTime1EarlierThanTime2(
          time1: event.time,
          time2: notificationTime,
        )) {
      emit(state.copyWith(
        status: SessionCreatorStatusStartTimeEarlierThanNotificationTime(),
      ));
    } else {
      emit(state.copyWith(time: event.time));
    }
  }

  void _durationSelected(
    SessionCreatorEventDurationSelected event,
    Emitter<SessionCreatorState> emit,
  ) {
    emit(state.copyWith(duration: event.duration));
  }

  Future<void> _notificationTimeSelected(
    SessionCreatorEventNotificationTimeSelected event,
    Emitter<SessionCreatorState> emit,
  ) async {
    final DateTime? date = state.date;
    final TimeOfDay? startTime = state.time;
    if (date != null && TimeUtils.isPastTime(event.notificationTime, date)) {
      emit(state.copyWith(status: SessionCreatorStatusTimeFromThePast()));
    } else if (startTime != null &&
        TimeUtils.isTime1EarlierThanTime2(
          time1: startTime,
          time2: event.notificationTime,
        )) {
      emit(state.copyWith(
        status: SessionCreatorStatusNotificationTimeLaterThanStartTime(),
      ));
    } else {
      emit(state.copyWith(notificationTime: event.notificationTime));
    }
  }

  void _cleanDurationTime(
    SessionCreatorEventCleanDurationTime event,
    Emitter<SessionCreatorState> emit,
  ) {
    emit(state.reset(duration: true));
  }

  void _cleanNotificationTime(
    SessionCreatorEventCleanNotificationTime event,
    Emitter<SessionCreatorState> emit,
  ) {
    emit(state.reset(notificationTime: true));
  }

  void _submit(
    SessionCreatorEventSubmit event,
    Emitter<SessionCreatorState> emit,
  ) {
    final SessionCreatorMode mode = state.mode;
    if (mode is SessionCreatorCreateMode) {
      _submitCreateMode();
    } else if (mode is SessionCreatorEditMode) {
      _submitEditMode(mode);
    }
  }

  void _initializeCreateMode(Emitter<SessionCreatorState> emit) {
    emit(state.copyWith(courses: _coursesBloc.state.allCourses));
  }

  void _initializeEditMode(
    SessionCreatorEditMode createMode,
    Emitter<SessionCreatorState> emit,
  ) {
    final Session session = createMode.session;
    final Group? group = _groupsBloc.state.getGroupById(session.groupId);
    final Course? course = _coursesBloc.state.getCourseById(group?.courseId);
    final List<Group> groupsFromCourse = _groupsBloc.state.getGroupsByCourseId(
      group?.courseId,
    );
    emit(state.copyWith(
      mode: createMode,
      courses: _coursesBloc.state.allCourses,
      groups: groupsFromCourse,
      selectedCourse: course,
      selectedGroup: group,
      flashcardsType: session.flashcardsType,
      areQuestionsAndAnswersSwapped: session.areQuestionsAndAnswersSwapped,
      date: session.date,
      time: session.time,
      duration: session.duration,
      notificationTime: session.notificationTime,
    ));
  }

  bool _areThereFlashcardsInGroup(Group group) {
    return group.flashcards.isNotEmpty;
  }

  void _submitCreateMode() {
    final String? groupId = state.selectedGroup?.id;
    final DateTime? date = state.date;
    final TimeOfDay? time = state.time;
    if (groupId != null && date != null && time != null) {
      _sessionsBloc.add(
        SessionsEventAddSession(
          session: Session(
            id: '',
            groupId: groupId,
            flashcardsType: state.flashcardsType,
            areQuestionsAndAnswersSwapped: state.areQuestionsAndAnswersSwapped,
            date: date,
            time: time,
            duration: state.duration,
            notificationTime: state.notificationTime,
          ),
        ),
      );
    }
  }

  void _submitEditMode(SessionCreatorEditMode mode) {
    _sessionsBloc.add(
      SessionsEventUpdateSession(
        sessionId: mode.session.id,
        groupId: state.selectedGroup?.id,
        date: state.date,
        time: state.time,
        duration: state.duration,
        notificationTime: state.notificationTime,
        flashcardsType: state.flashcardsType,
        areQuestionsAndFlashcardsSwapped: state.areQuestionsAndAnswersSwapped,
      ),
    );
  }
}

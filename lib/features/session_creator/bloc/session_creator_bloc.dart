import 'package:equatable/equatable.dart';
import 'package:fiszkomaniak/core/sessions/sessions_bloc.dart';
import 'package:fiszkomaniak/features/session_creator/bloc/session_creator_mode.dart';
import 'package:fiszkomaniak/interfaces/courses_interface.dart';
import 'package:fiszkomaniak/models/date_model.dart';
import 'package:fiszkomaniak/models/group_model.dart';
import 'package:fiszkomaniak/models/session_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/course.dart';
import '../../../models/time_model.dart';
import '../../../utils/group_utils.dart';
import '../../../utils/time_utils.dart';

part 'session_creator_event.dart';

part 'session_creator_state.dart';

part 'session_creator_status.dart';

class SessionCreatorBloc
    extends Bloc<SessionCreatorEvent, SessionCreatorState> {
  late final CoursesInterface _coursesInterface;
  late final SessionsBloc _sessionsBloc;

  SessionCreatorBloc({
    required CoursesInterface coursesInterface,
    required SessionsBloc sessionsBloc,
  }) : super(const SessionCreatorState()) {
    _coursesInterface = coursesInterface;
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

  Future<void> _courseSelected(
    SessionCreatorEventCourseSelected event,
    Emitter<SessionCreatorState> emit,
  ) async {
    final Course course =
        await _coursesInterface.getCourseById(event.courseId).first;
    // final List<Group> groupsFromCourse =
    //     _groupsBloc.state.getGroupsByCourseId(event.courseId);
    if (state.selectedCourse != course && state.selectedCourse != null) {
      emit(state.reset(selectedGroup: true));
    }
    emit(state.copyWith(
      selectedCourse: course,
      // groups: groupsFromCourse.where(_areThereFlashcardsInGroup).toList(),
    ));
  }

  void _groupSelected(
    SessionCreatorEventGroupSelected event,
    Emitter<SessionCreatorState> emit,
  ) {
    // final Group? group = _groupsBloc.state.getGroupById(event.groupId);
    // if (group != null) {
    //   emit(state.copyWith(selectedGroup: group));
    // }
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
    final Date? date = state.date;
    final Time? notificationTime = state.notificationTime;
    if (date != null && TimeUtils.isPastTime(event.time, date)) {
      emit(state.copyWith(status: SessionCreatorStatusTimeFromThePast()));
    } else if (notificationTime != null &&
        TimeUtils.isTime1EarlierThanTime2(
          time1: event.time,
          time2: notificationTime,
        )) {
      emit(
        state.copyWith(
          status: SessionCreatorStatusStartTimeEarlierThanNotificationTime(),
        ),
      );
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
    final Date? date = state.date;
    final Time? time = state.time;
    if (date != null && TimeUtils.isPastTime(event.notificationTime, date)) {
      emit(state.copyWith(status: SessionCreatorStatusTimeFromThePast()));
    } else if (time != null &&
        TimeUtils.isTime1EarlierThanTime2(
          time1: time,
          time2: event.notificationTime,
        )) {
      emit(
        state.copyWith(
          status: SessionCreatorStatusNotificationTimeLaterThanStartTime(),
        ),
      );
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

  Future<void> _initializeCreateMode(Emitter<SessionCreatorState> emit) async {
    emit(state.copyWith(courses: await _coursesInterface.allCourses$.first));
  }

  Future<void> _initializeEditMode(
    SessionCreatorEditMode createMode,
    Emitter<SessionCreatorState> emit,
  ) async {
    final Session session = createMode.session;
    // final Group? group = _groupsBloc.state.getGroupById(session.groupId);
    // final Course course =
    //     await _coursesInterface.getCourseById(group?.courseId ?? '').first;
    // final List<Group> groupsFromCourse = _groupsBloc.state.getGroupsByCourseId(
    //   group?.courseId,
    // );
    emit(state.copyWith(
      mode: createMode,
      courses: await _coursesInterface.allCourses$.first,
      // groups: groupsFromCourse,
      // selectedCourse: course,
      // selectedGroup: group,
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
    final Date? date = state.date;
    final Time? time = state.time;
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
        flashcardsType: state.flashcardsType,
        areQuestionsAndFlashcardsSwapped: state.areQuestionsAndAnswersSwapped,
        notificationTime: state.notificationTime,
      ),
    );
  }
}

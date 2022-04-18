import 'package:fiszkomaniak/core/courses/courses_bloc.dart';
import 'package:fiszkomaniak/core/flashcards/flashcards_bloc.dart';
import 'package:fiszkomaniak/core/groups/groups_bloc.dart';
import 'package:fiszkomaniak/features/session_creator/bloc/session_creator_event.dart';
import 'package:fiszkomaniak/features/session_creator/bloc/session_creator_state.dart';
import 'package:fiszkomaniak/models/group_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../models/course_model.dart';

class SessionCreatorBloc
    extends Bloc<SessionCreatorEvent, SessionCreatorState> {
  late final CoursesBloc _coursesBloc;
  late final GroupsBloc _groupsBloc;
  late final FlashcardsBloc _flashcardsBloc;

  SessionCreatorBloc({
    required CoursesBloc coursesBloc,
    required GroupsBloc groupsBloc,
    required FlashcardsBloc flashcardsBloc,
  }) : super(const SessionCreatorState()) {
    _coursesBloc = coursesBloc;
    _groupsBloc = groupsBloc;
    _flashcardsBloc = flashcardsBloc;
    on<SessionCreatorEventInitialize>(_initialize);
    on<SessionCreatorEventCourseSelected>(_courseSelected);
    on<SessionCreatorEventGroupSelected>(_groupSelected);
    on<SessionCreatorEventFlashcardsTypeSelected>(_flashcardsTypeSelected);
    on<SessionCreatorEventSwapQuestionsWithAnswers>(_swapQuestionsWithAnswers);
    on<SessionCreatorEventDateSelected>(_dateSelected);
    on<SessionCreatorEventTimeSelected>(_timeSelected);
    on<SessionCreatorEventDurationSelected>(_durationSelected);
    on<SessionCreatorEventNotificationTimeSelected>(_notificationTimeSelected);
    on<SessionCreatorEventCleanNotificationTime>(_cleanNotificationTime);
  }

  void _initialize(
    SessionCreatorEventInitialize event,
    Emitter<SessionCreatorState> emit,
  ) {
    emit(state.copyWith(courses: _coursesBloc.state.allCourses));
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
        reversedQuestionsWithAnswers: !state.reversedQuestionsWithAnswers,
      ));
    }
  }

  void _dateSelected(
    SessionCreatorEventDateSelected event,
    Emitter<SessionCreatorState> emit,
  ) {
    emit(state.copyWith(date: event.date));
  }

  void _timeSelected(
    SessionCreatorEventTimeSelected event,
    Emitter<SessionCreatorState> emit,
  ) {
    emit(state.copyWith(time: event.time));
  }

  void _durationSelected(
    SessionCreatorEventDurationSelected event,
    Emitter<SessionCreatorState> emit,
  ) {
    emit(state.copyWith(duration: event.duration));
  }

  void _notificationTimeSelected(
    SessionCreatorEventNotificationTimeSelected event,
    Emitter<SessionCreatorState> emit,
  ) {
    emit(state.copyWith(notificationTime: event.notificationTime));
  }

  void _cleanNotificationTime(
    SessionCreatorEventCleanNotificationTime event,
    Emitter<SessionCreatorState> emit,
  ) {
    emit(state.reset(notificationTime: true));
  }

  bool _areThereFlashcardsInGroup(Group group) {
    return _flashcardsBloc.state.getFlashcardsByGroupId(group.id).isNotEmpty;
  }
}

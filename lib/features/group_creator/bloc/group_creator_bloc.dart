import 'package:fiszkomaniak/core/courses/courses_bloc.dart';
import 'package:fiszkomaniak/core/groups/groups_bloc.dart';
import 'package:fiszkomaniak/core/groups/groups_event.dart';
import 'package:fiszkomaniak/features/group_creator/bloc/group_creator_event.dart';
import 'package:fiszkomaniak/features/group_creator/bloc/group_creator_state.dart';
import 'package:fiszkomaniak/models/course_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GroupCreatorBloc extends Bloc<GroupCreatorEvent, GroupCreatorState> {
  late final CoursesBloc _coursesBloc;
  late final GroupsBloc _groupsBloc;

  GroupCreatorBloc({
    required CoursesBloc coursesBloc,
    required GroupsBloc groupsBloc,
  }) : super(const GroupCreatorState()) {
    _coursesBloc = coursesBloc;
    _groupsBloc = groupsBloc;
    on<GroupCreatorEventInitialize>(_initialize);
    on<GroupCreatorEventCourseChanged>(_onCourseChanged);
    on<GroupCreatorEventGroupNameChanged>(_onGroupNameChanged);
    on<GroupCreatorEventNameForQuestionsChanged>(_onNameForQuestionsChanged);
    on<GroupCreatorEventNameForAnswersChanged>(_onNameForAnswersChanged);
    on<GroupCreatorEventSubmit>(_submit);
  }

  void _initialize(
    GroupCreatorEventInitialize event,
    Emitter<GroupCreatorState> emit,
  ) {
    final List<Course> allCourses = _coursesBloc.state.allCourses;
    emit(state.copyWith(
      selectedCourse: allCourses[0],
      allCourses: allCourses,
    ));
  }

  void _onCourseChanged(
    GroupCreatorEventCourseChanged event,
    Emitter<GroupCreatorState> emit,
  ) {
    emit(state.copyWith(selectedCourse: event.course));
  }

  void _onGroupNameChanged(
    GroupCreatorEventGroupNameChanged event,
    Emitter<GroupCreatorState> emit,
  ) {
    emit(state.copyWith(groupName: event.groupName));
  }

  void _onNameForQuestionsChanged(
    GroupCreatorEventNameForQuestionsChanged event,
    Emitter<GroupCreatorState> emit,
  ) {
    emit(state.copyWith(nameForQuestions: event.nameForQuestions));
  }

  void _onNameForAnswersChanged(
    GroupCreatorEventNameForAnswersChanged event,
    Emitter<GroupCreatorState> emit,
  ) {
    emit(state.copyWith(nameForAnswers: event.nameForAnswers));
  }

  void _submit(
    GroupCreatorEventSubmit event,
    Emitter<GroupCreatorState> emit,
  ) {
    final Course? selectedCourse = state.selectedCourse;
    if (selectedCourse != null) {
      _groupsBloc.add(GroupsEventAddGroup(
        name: state.groupName,
        courseId: selectedCourse.id,
        nameForQuestions: state.nameForQuestions,
        nameForAnswers: state.nameForAnswers,
      ));
    }
  }
}

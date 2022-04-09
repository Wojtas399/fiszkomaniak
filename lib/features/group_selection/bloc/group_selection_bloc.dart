import 'package:fiszkomaniak/config/navigation.dart';
import 'package:fiszkomaniak/core/courses/courses_bloc.dart';
import 'package:fiszkomaniak/core/groups/groups_bloc.dart';
import 'package:fiszkomaniak/features/group_selection/bloc/group_selection_event.dart';
import 'package:fiszkomaniak/features/group_selection/bloc/group_selection_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GroupSelectionBloc
    extends Bloc<GroupSelectionEvent, GroupSelectionState> {
  late final CoursesBloc _coursesBloc;
  late final GroupsBloc _groupsBloc;

  GroupSelectionBloc({
    required CoursesBloc coursesBloc,
    required GroupsBloc groupsBloc,
  }) : super(GroupSelectionState()) {
    _coursesBloc = coursesBloc;
    _groupsBloc = groupsBloc;
    on<GroupSelectionEventInitialize>(_initialize);
    on<GroupSelectionEventCourseSelected>(_courseSelected);
    on<GroupSelectionEventGroupSelected>(_groupSelected);
    on<GroupSelectionEventButtonPressed>(_buttonPressed);
  }

  void _initialize(
    GroupSelectionEventInitialize event,
    Emitter<GroupSelectionState> emit,
  ) {
    emit(state.copyWith(
      allCourses: _coursesBloc.state.allCourses,
    ));
  }

  void _courseSelected(
    GroupSelectionEventCourseSelected event,
    Emitter<GroupSelectionState> emit,
  ) {
    emit(state.copyWith(
      selectedCourse: _coursesBloc.state.getCourseById(event.courseId),
      groupsFromCourse: _groupsBloc.state.getGroupsByCourseId(event.courseId),
    ));
  }

  void _groupSelected(
    GroupSelectionEventGroupSelected event,
    Emitter<GroupSelectionState> emit,
  ) {
    emit(state.copyWith(
      selectedGroup: _groupsBloc.state.getGroupById(event.groupId),
    ));
  }

  void _buttonPressed(
    GroupSelectionEventButtonPressed event,
    Emitter<GroupSelectionState> emit,
  ) {
    final String? selectedGroupId = state.selectedGroup?.id;
    if (selectedGroupId != null) {
      Navigation.navigateToFlashcardsEditor(selectedGroupId);
    }
  }
}

import 'dart:async';
import 'package:fiszkomaniak/config/navigation.dart';
import 'package:fiszkomaniak/core/courses/courses_bloc.dart';
import 'package:fiszkomaniak/core/groups/groups_bloc.dart';
import 'package:fiszkomaniak/features/group_selection/bloc/group_selection_event.dart';
import 'package:fiszkomaniak/features/group_selection/bloc/group_selection_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../models/group_model.dart';

class GroupSelectionBloc
    extends Bloc<GroupSelectionEvent, GroupSelectionState> {
  late final CoursesBloc _coursesBloc;
  late final GroupsBloc _groupsBloc;
  late final Navigation _navigation;
  StreamSubscription? _groupsStateSubscription;

  GroupSelectionBloc({
    required CoursesBloc coursesBloc,
    required GroupsBloc groupsBloc,
    required Navigation navigation,
  }) : super(GroupSelectionState()) {
    _coursesBloc = coursesBloc;
    _groupsBloc = groupsBloc;
    _navigation = navigation;
    on<GroupSelectionEventInitialize>(_initialize);
    on<GroupSelectionEventCourseSelected>(_courseSelected);
    on<GroupSelectionEventGroupSelected>(_groupSelected);
    on<GroupSelectionEventButtonPressed>(_buttonPressed);
    on<GroupSelectionEventGroupsStateUpdated>(_groupsStateUpdated);
  }

  void _initialize(
    GroupSelectionEventInitialize event,
    Emitter<GroupSelectionState> emit,
  ) {
    emit(state.copyWith(
      allCourses: _coursesBloc.state.allCourses,
    ));
    _setGroupsStateListener();
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
    final Group? group = _groupsBloc.state.getGroupById(event.groupId);
    if (group != null) {
      emit(state.copyWith(
        selectedGroup: _groupsBloc.state.getGroupById(event.groupId),
      ));
    }
  }

  void _buttonPressed(
    GroupSelectionEventButtonPressed event,
    Emitter<GroupSelectionState> emit,
  ) {
    _navigation.navigateToFlashcardsEditor(state.selectedGroup!.id);
  }

  void _groupsStateUpdated(
    GroupSelectionEventGroupsStateUpdated event,
    Emitter<GroupSelectionState> emit,
  ) {
    emit(state.copyWith(
      selectedGroup: event.newGroupsState.getGroupById(state.selectedGroup?.id),
    ));
  }

  void _setGroupsStateListener() {
    _groupsStateSubscription = _groupsBloc.stream.listen((state) {
      add(GroupSelectionEventGroupsStateUpdated(newGroupsState: state));
    });
  }

  @override
  Future<void> close() {
    _groupsStateSubscription?.cancel();
    return super.close();
  }
}

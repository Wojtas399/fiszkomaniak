import 'dart:async';
import 'package:fiszkomaniak/config/navigation.dart';
import 'package:fiszkomaniak/core/courses/courses_bloc.dart';
import 'package:fiszkomaniak/core/flashcards/flashcards_bloc.dart';
import 'package:fiszkomaniak/core/groups/groups_bloc.dart';
import 'package:fiszkomaniak/features/group_selection/bloc/group_selection_event.dart';
import 'package:fiszkomaniak/features/group_selection/bloc/group_selection_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../models/group_model.dart';

class GroupSelectionBloc
    extends Bloc<GroupSelectionEvent, GroupSelectionState> {
  late final CoursesBloc _coursesBloc;
  late final GroupsBloc _groupsBloc;
  late final FlashcardsBloc _flashcardsBloc;
  StreamSubscription? _flashcardsStateSubscription;

  GroupSelectionBloc({
    required CoursesBloc coursesBloc,
    required GroupsBloc groupsBloc,
    required FlashcardsBloc flashcardsBloc,
  }) : super(GroupSelectionState()) {
    _coursesBloc = coursesBloc;
    _groupsBloc = groupsBloc;
    _flashcardsBloc = flashcardsBloc;
    on<GroupSelectionEventInitialize>(_initialize);
    on<GroupSelectionEventCourseSelected>(_courseSelected);
    on<GroupSelectionEventGroupSelected>(_groupSelected);
    on<GroupSelectionEventButtonPressed>(_buttonPressed);
    on<GroupSelectionEventFlashcardsStateUpdated>(_flashcardsStateUpdated);
  }

  void _initialize(
    GroupSelectionEventInitialize event,
    Emitter<GroupSelectionState> emit,
  ) {
    emit(state.copyWith(
      allCourses: _coursesBloc.state.allCourses,
    ));
    _setFlashcardsStateSubscription();
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
        amountOfAllFlashcardsFromGroup: _flashcardsBloc.state
            .getAmountOfAllFlashcardsFromGroup(event.groupId),
        amountOfRememberedFlashcardsFromGroup: _flashcardsBloc.state
            .getAmountOfRememberedFlashcardsFromGroup(event.groupId),
      ));
    }
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

  void _flashcardsStateUpdated(
    GroupSelectionEventFlashcardsStateUpdated event,
    Emitter<GroupSelectionState> emit,
  ) {
    emit(state.copyWith(
      selectedGroup: state.selectedGroup,
      amountOfAllFlashcardsFromGroup: _flashcardsBloc.state
          .getAmountOfAllFlashcardsFromGroup(state.selectedGroup?.id),
      amountOfRememberedFlashcardsFromGroup: _flashcardsBloc.state
          .getAmountOfRememberedFlashcardsFromGroup(state.selectedGroup?.id),
    ));
  }

  void _setFlashcardsStateSubscription() {
    _flashcardsStateSubscription = _flashcardsBloc.stream.listen((_) {
      add(GroupSelectionEventFlashcardsStateUpdated());
    });
  }

  @override
  Future<void> close() {
    _flashcardsStateSubscription?.cancel();
    return super.close();
  }
}

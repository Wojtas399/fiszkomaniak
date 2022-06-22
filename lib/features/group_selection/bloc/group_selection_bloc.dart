import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:fiszkomaniak/config/navigation.dart';
import 'package:fiszkomaniak/features/flashcards_editor/flashcards_editor_mode.dart';
import 'package:fiszkomaniak/interfaces/courses_interface.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/course.dart';
import '../../../models/flashcard_model.dart';
import '../../../domain/entities/group.dart';

part 'group_selection_event.dart';

part 'group_selection_state.dart';

class GroupSelectionBloc
    extends Bloc<GroupSelectionEvent, GroupSelectionState> {
  late final CoursesInterface _coursesInterface;
  late final Navigation _navigation;
  StreamSubscription? _groupsStateSubscription;

  GroupSelectionBloc({
    required CoursesInterface coursesInterface,
    required Navigation navigation,
  }) : super(GroupSelectionState()) {
    _coursesInterface = coursesInterface;
    _navigation = navigation;
    on<GroupSelectionEventInitialize>(_initialize);
    on<GroupSelectionEventCourseSelected>(_courseSelected);
    on<GroupSelectionEventGroupSelected>(_groupSelected);
    on<GroupSelectionEventButtonPressed>(_buttonPressed);
    on<GroupSelectionEventGroupsStateUpdated>(_groupsStateUpdated);
  }

  Future<void> _initialize(
    GroupSelectionEventInitialize event,
    Emitter<GroupSelectionState> emit,
  ) async {
    emit(state.copyWith(
      allCourses: await _coursesInterface.allCourses$.first,
    ));
    _setGroupsStateListener();
  }

  Future<void> _courseSelected(
    GroupSelectionEventCourseSelected event,
    Emitter<GroupSelectionState> emit,
  ) async {
    emit(state.copyWith(
      selectedCourse:
          await _coursesInterface.getCourseById(event.courseId).first,
      // groupsFromCourse: _groupsBloc.state.getGroupsByCourseId(event.courseId),
    ));
  }

  void _groupSelected(
    GroupSelectionEventGroupSelected event,
    Emitter<GroupSelectionState> emit,
  ) {
    // final Group? group = _groupsBloc.state.getGroupById(event.groupId);
    // if (group != null) {
    //   emit(state.copyWith(
    //     selectedGroup: _groupsBloc.state.getGroupById(event.groupId),
    //   ));
    // }
  }

  void _buttonPressed(
    GroupSelectionEventButtonPressed event,
    Emitter<GroupSelectionState> emit,
  ) {
    final String? groupId = state.selectedGroup?.id;
    if (groupId != null) {
      _navigation.navigateToFlashcardsEditor(
        FlashcardsEditorAddMode(groupId: groupId),
      );
    }
  }

  void _groupsStateUpdated(
    GroupSelectionEventGroupsStateUpdated event,
    Emitter<GroupSelectionState> emit,
  ) {
    // emit(state.copyWith(
    //   selectedGroup: event.newGroupsState.getGroupById(state.selectedGroup?.id),
    // ));
  }

  void _setGroupsStateListener() {
    // _groupsStateSubscription = _groupsBloc.stream.listen((state) {
    //   add(GroupSelectionEventGroupsStateUpdated(newGroupsState: state));
    // });
  }

  @override
  Future<void> close() {
    _groupsStateSubscription?.cancel();
    return super.close();
  }
}

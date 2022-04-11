import 'package:fiszkomaniak/config/navigation.dart';
import 'package:fiszkomaniak/core/courses/courses_bloc.dart';
import 'package:fiszkomaniak/core/flashcards/flashcards_bloc.dart';
import 'package:fiszkomaniak/core/groups/groups_bloc.dart';
import 'package:fiszkomaniak/features/group_selection/bloc/group_selection_event.dart';
import 'package:fiszkomaniak/features/group_selection/bloc/group_selection_state.dart';
import 'package:fiszkomaniak/models/flashcard_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../models/group_model.dart';

class GroupSelectionBloc
    extends Bloc<GroupSelectionEvent, GroupSelectionState> {
  late final CoursesBloc _coursesBloc;
  late final GroupsBloc _groupsBloc;
  late final FlashcardsBloc _flashcardsBloc;

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
    final Group? group = _groupsBloc.state.getGroupById(event.groupId);
    if (group != null) {
      final List<Flashcard> flashcardsFromGroup =
          _flashcardsBloc.state.getFlashcardsFromGroup(group.id);
      int amountOfAllFlashcards = flashcardsFromGroup.length;
      int amountOfRememberedFlashcards = flashcardsFromGroup
          .where(
            (flashcard) => flashcard.status == FlashcardStatus.remembered,
          )
          .length;
      emit(state.copyWith(
        selectedGroup: _groupsBloc.state.getGroupById(event.groupId),
        amountOfAllFlashcardsFromGroup: amountOfAllFlashcards,
        amountOfRememberedFlashcardsFromGroup: amountOfRememberedFlashcards,
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
}

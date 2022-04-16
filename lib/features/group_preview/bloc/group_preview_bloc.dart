import 'dart:async';
import 'package:fiszkomaniak/core/courses/courses_bloc.dart';
import 'package:fiszkomaniak/core/flashcards/flashcards_bloc.dart';
import 'package:fiszkomaniak/core/flashcards/flashcards_event.dart';
import 'package:fiszkomaniak/core/groups/groups_bloc.dart';
import 'package:fiszkomaniak/features/group_preview/bloc/group_preview_dialogs.dart';
import 'package:fiszkomaniak/features/group_preview/bloc/group_preview_event.dart';
import 'package:fiszkomaniak/features/group_preview/bloc/group_preview_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../config/navigation.dart';
import '../../../core/groups/groups_event.dart';
import '../../../models/group_model.dart';
import '../../group_creator/bloc/group_creator_mode.dart';

class GroupPreviewBloc extends Bloc<GroupPreviewEvent, GroupPreviewState> {
  late final GroupsBloc _groupsBloc;
  late final CoursesBloc _coursesBloc;
  late final FlashcardsBloc _flashcardsBloc;
  late final GroupPreviewDialogs _groupPreviewDialogs;
  StreamSubscription? _groupsStateSubscription;
  StreamSubscription? _flashcardsStateSubscription;

  GroupPreviewBloc({
    required GroupsBloc groupsBloc,
    required CoursesBloc coursesBloc,
    required FlashcardsBloc flashcardsBloc,
    required GroupPreviewDialogs groupPreviewDialogs,
  }) : super(const GroupPreviewState()) {
    _groupsBloc = groupsBloc;
    _coursesBloc = coursesBloc;
    _flashcardsBloc = flashcardsBloc;
    _groupPreviewDialogs = groupPreviewDialogs;
    on<GroupPreviewEventInitialize>(_initialize);
    on<GroupPreviewEventEdit>(_edit);
    on<GroupPreviewEventAddFlashcards>(_addFlashcards);
    on<GroupPreviewEventRemove>(_remove);
    on<GroupPreviewEventGroupsStateUpdated>(_groupsStateUpdated);
    on<GroupPreviewEventFlashcardsStateUpdated>(_flashcardsStateUpdated);
  }

  void _initialize(
    GroupPreviewEventInitialize event,
    Emitter<GroupPreviewState> emit,
  ) {
    final Group? group = _groupsBloc.state.getGroupById(event.groupId);
    final String? courseName = _coursesBloc.state.getCourseNameById(
      group?.courseId,
    );
    if (group != null && courseName != null) {
      emit(state.copyWith(
        group: group,
        courseName: courseName,
        amountOfAllFlashcards: _flashcardsBloc.state
            .getAmountOfAllFlashcardsFromGroup(event.groupId),
        amountOfRememberedFlashcards: _flashcardsBloc.state
            .getAmountOfRememberedFlashcardsFromGroup(event.groupId),
      ));
    }
    _setGroupsStateListener();
    _setFlashcardsStateListener();
  }

  void _edit(
    GroupPreviewEventEdit event,
    Emitter<GroupPreviewState> emit,
  ) {
    final Group? group = state.group;
    if (group != null) {
      Navigation.navigateToGroupCreator(GroupCreatorEditMode(group: group));
    }
  }

  void _addFlashcards(
    GroupPreviewEventAddFlashcards event,
    Emitter<GroupPreviewState> emit,
  ) {
    final String? groupId = state.group?.id;
    if (groupId != null) {
      Navigation.navigateToFlashcardsEditor(groupId);
    }
  }

  Future<void> _remove(
    GroupPreviewEventRemove event,
    Emitter<GroupPreviewState> emit,
  ) async {
    final String? groupId = state.group?.id;
    if (groupId != null) {
      final bool? confirmation =
          await _groupPreviewDialogs.askForDeleteConfirmation();
      if (confirmation == true) {
        _groupsBloc.add(GroupsEventRemoveGroup(groupId: groupId));
        _flashcardsBloc.add(
          FlashcardsEventRemoveFlashcardsFromGroups(groupsIds: [groupId]),
        );
      }
    }
  }

  void _groupsStateUpdated(
    GroupPreviewEventGroupsStateUpdated event,
    Emitter<GroupPreviewState> emit,
  ) {
    final Group? group = _groupsBloc.state.getGroupById(state.group?.id);
    if (group != null) {
      emit(state.copyWith(group: group));
    }
  }

  void _flashcardsStateUpdated(
    GroupPreviewEventFlashcardsStateUpdated event,
    Emitter<GroupPreviewState> emit,
  ) {
    emit(state.copyWith(
      amountOfAllFlashcards: _flashcardsBloc.state
          .getAmountOfAllFlashcardsFromGroup(state.group?.id),
      amountOfRememberedFlashcards: _flashcardsBloc.state
          .getAmountOfRememberedFlashcardsFromGroup(state.group?.id),
    ));
  }

  void _setGroupsStateListener() {
    _groupsStateSubscription = _groupsBloc.stream.listen((_) {
      add(GroupPreviewEventGroupsStateUpdated());
    });
  }

  void _setFlashcardsStateListener() {
    _flashcardsStateSubscription = _flashcardsBloc.stream.listen((_) {
      add(GroupPreviewEventFlashcardsStateUpdated());
    });
  }

  @override
  Future<void> close() {
    _groupsStateSubscription?.cancel();
    _flashcardsStateSubscription?.cancel();
    return super.close();
  }
}

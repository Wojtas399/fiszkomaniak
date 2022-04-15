import 'package:fiszkomaniak/core/flashcards/flashcards_bloc.dart';
import 'package:fiszkomaniak/core/groups/groups_bloc.dart';
import 'package:fiszkomaniak/features/group_flashcards_preview/bloc/group_flashcards_preview_event.dart';
import 'package:fiszkomaniak/features/group_flashcards_preview/bloc/group_flashcards_preview_state.dart';
import 'package:fiszkomaniak/models/flashcard_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GroupFlashcardsPreviewBloc
    extends Bloc<GroupFlashcardsPreviewEvent, GroupFlashcardsPreviewState> {
  late final GroupsBloc _groupsBloc;
  late final FlashcardsBloc _flashcardsBloc;

  GroupFlashcardsPreviewBloc({
    required GroupsBloc groupsBloc,
    required FlashcardsBloc flashcardsBloc,
  }) : super(const GroupFlashcardsPreviewState()) {
    _groupsBloc = groupsBloc;
    _flashcardsBloc = flashcardsBloc;
    on<GroupFlashcardsPreviewEventInitialize>(_initialize);
    on<GroupFlashcardsPreviewEventSearchValueChanged>(_searchValueChanged);
  }

  void _initialize(
    GroupFlashcardsPreviewEventInitialize event,
    Emitter<GroupFlashcardsPreviewState> emit,
  ) {
    final String? groupName = _groupsBloc.state.getGroupNameById(event.groupId);
    final List<Flashcard> flashcardsFromGroup =
        _flashcardsBloc.state.getFlashcardsFromGroup(event.groupId);
    if (groupName != null) {
      emit(state.copyWith(
        groupId: event.groupId,
        groupName: groupName,
        flashcardsFromGroup: flashcardsFromGroup,
      ));
    }
  }

  void _searchValueChanged(
    GroupFlashcardsPreviewEventSearchValueChanged event,
    Emitter<GroupFlashcardsPreviewState> emit,
  ) {
    emit(state.copyWith(searchValue: event.searchValue));
  }
}

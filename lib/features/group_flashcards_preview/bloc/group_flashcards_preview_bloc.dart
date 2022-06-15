import 'dart:async';
import 'package:fiszkomaniak/config/navigation.dart';
import 'package:fiszkomaniak/features/group_flashcards_preview/bloc/group_flashcards_preview_event.dart';
import 'package:fiszkomaniak/features/group_flashcards_preview/bloc/group_flashcards_preview_state.dart';
import 'package:fiszkomaniak/models/flashcard_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GroupFlashcardsPreviewBloc
    extends Bloc<GroupFlashcardsPreviewEvent, GroupFlashcardsPreviewState> {
  late final Navigation _navigation;
  StreamSubscription? _flashcardsStateSubscription;

  GroupFlashcardsPreviewBloc({
    required Navigation navigation,
  }) : super(const GroupFlashcardsPreviewState()) {
    _navigation = navigation;
    on<GroupFlashcardsPreviewEventInitialize>(_initialize);
    on<GroupFlashcardsPreviewEventSearchValueChanged>(_searchValueChanged);
    on<GroupFlashcardsPreviewEventShowFlashcardDetails>(_showFlashcardDetails);
    on<GroupFlashcardsPreviewEventFlashcardsStateUpdated>(
      _flashcardsStateUpdated,
    );
  }

  void _initialize(
    GroupFlashcardsPreviewEventInitialize event,
    Emitter<GroupFlashcardsPreviewState> emit,
  ) {
    // final String? groupName = _groupsBloc.state.getGroupNameById(event.groupId);
    // final List<Flashcard> flashcardsFromGroup =
    //     _flashcardsBloc.state.getFlashcardsFromGroup(event.groupId);
    // if (groupName != null) {
    //   emit(state.copyWith(
    //     groupId: event.groupId,
    //     groupName: groupName,
    //     flashcardsFromGroup: flashcardsFromGroup,
    //   ));
    // }
    // _setFlashcardsStateSubscription();
  }

  void _searchValueChanged(
    GroupFlashcardsPreviewEventSearchValueChanged event,
    Emitter<GroupFlashcardsPreviewState> emit,
  ) {
    emit(state.copyWith(searchValue: event.searchValue));
  }

  void _showFlashcardDetails(
    GroupFlashcardsPreviewEventShowFlashcardDetails event,
    Emitter<GroupFlashcardsPreviewState> emit,
  ) {
    final String? groupId = state.groupId;
    if (groupId != null) {
      _navigation.navigateToFlashcardPreview(groupId, event.flashcardIndex);
    }
  }

  void _flashcardsStateUpdated(
    GroupFlashcardsPreviewEventFlashcardsStateUpdated event,
    Emitter<GroupFlashcardsPreviewState> emit,
  ) {
    // final List<Flashcard> flashcardsFromGroup =
    //     _flashcardsBloc.state.getFlashcardsFromGroup(state.groupId);
    // emit(state.copyWith(flashcardsFromGroup: flashcardsFromGroup));
  }

  void _setFlashcardsStateSubscription() {
    // _flashcardsStateSubscription = _flashcardsBloc.stream.listen((_) {
    //   add(GroupFlashcardsPreviewEventFlashcardsStateUpdated());
    // });
  }

  @override
  Future<void> close() {
    _flashcardsStateSubscription?.cancel();
    return super.close();
  }
}

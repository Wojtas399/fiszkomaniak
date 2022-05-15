import 'package:equatable/equatable.dart';
import 'package:fiszkomaniak/core/flashcards/flashcards_status.dart';
import 'package:fiszkomaniak/core/groups/groups_state.dart';
import 'package:fiszkomaniak/models/flashcard_model.dart';

class FlashcardsState extends Equatable {
  final GroupsState groupsState;
  final FlashcardsStatus status;

  const FlashcardsState({
    this.groupsState = const GroupsState(),
    this.status = const FlashcardsStatusInitial(),
  });

  FlashcardsState copyWith({
    GroupsState? groupsState,
    FlashcardsStatus? status,
  }) {
    return FlashcardsState(
      groupsState: groupsState ?? this.groupsState,
      status: status ?? FlashcardsStatusLoaded(),
    );
  }

  int get amountOfAllFlashcards => groupsState.allGroups
      .map((group) => group.flashcards.length)
      .reduce((sumOfAllFlashcards, amountOfFlashcardsInGroup) =>
          sumOfAllFlashcards + amountOfFlashcardsInGroup);

  List<Flashcard> getFlashcardsFromGroup(String? groupId) {
    return groupsState.getGroupById(groupId)?.flashcards.toList() ?? [];
  }

  int getAmountOfAllFlashcardsFromGroup(String? groupId) {
    return getFlashcardsFromGroup(groupId).length;
  }

  int getAmountOfRememberedFlashcardsFromGroup(String? groupId) {
    return getFlashcardsFromGroup(groupId)
        .where((flashcard) => flashcard.status == FlashcardStatus.remembered)
        .length;
  }

  Flashcard? getFlashcardFromGroup(String? groupId, int? flashcardIndex) {
    if (flashcardIndex == null) {
      return null;
    }
    return groupsState.getGroupById(groupId)?.flashcards[flashcardIndex];
  }

  @override
  List<Object> get props => [
        groupsState,
        status,
      ];
}

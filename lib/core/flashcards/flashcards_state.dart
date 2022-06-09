part of 'flashcards_bloc.dart';

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

  int get amountOfAllFlashcards {
    return groupsState.allGroups.isNotEmpty
        ? groupsState.allGroups
            .map((group) => group.flashcards.length)
            .reduce(_sumFlashcardsFromGroups)
        : 0;
  }

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

  int _sumFlashcardsFromGroups(
    int amountOfAllFlashcards,
    int amountOfFlashcardsFromGroup,
  ) {
    return amountOfAllFlashcards + amountOfFlashcardsFromGroup;
  }

  @override
  List<Object> get props => [
        groupsState,
        status,
      ];
}

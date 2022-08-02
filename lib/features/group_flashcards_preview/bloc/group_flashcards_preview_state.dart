part of 'group_flashcards_preview_bloc.dart';

class GroupFlashcardsPreviewState extends Equatable {
  final String groupId;
  final String groupName;
  final List<Flashcard> flashcardsFromGroup;
  final String searchValue;

  const GroupFlashcardsPreviewState({
    required this.groupId,
    required this.groupName,
    required this.flashcardsFromGroup,
    required this.searchValue,
  });

  @override
  List<Object> get props => [
        groupId,
        groupName,
        flashcardsFromGroup,
        searchValue,
      ];

  bool get doesGroupHaveFlashcards => flashcardsFromGroup.isNotEmpty;

  List<Flashcard> get matchingFlashcards =>
      flashcardsFromGroup.where(_checkIfMatchesToSearchValue).toList();

  GroupFlashcardsPreviewState copyWith({
    String? groupId,
    String? groupName,
    List<Flashcard>? flashcardsFromGroup,
    String? searchValue,
  }) {
    return GroupFlashcardsPreviewState(
      groupId: groupId ?? this.groupId,
      groupName: groupName ?? this.groupName,
      flashcardsFromGroup: flashcardsFromGroup ?? this.flashcardsFromGroup,
      searchValue: searchValue ?? this.searchValue,
    );
  }

  bool _checkIfMatchesToSearchValue(Flashcard flashcard) {
    final String question = flashcard.question.toLowerCase();
    final String answer = flashcard.answer.toLowerCase();
    final String searchValue = this.searchValue.toLowerCase();
    return question.contains(searchValue) || answer.contains(searchValue);
  }
}

import 'package:equatable/equatable.dart';
import 'package:fiszkomaniak/domain/entities/flashcard.dart';

class GroupFlashcardsPreviewState extends Equatable {
  final String? groupId;
  final String? groupName;
  final List<Flashcard> flashcardsFromGroup;
  final String searchValue;

  List<Flashcard> get matchingFlashcards =>
      flashcardsFromGroup.where(_checkIfMatchesToSearchValue).toList();

  const GroupFlashcardsPreviewState({
    this.groupId,
    this.groupName,
    this.flashcardsFromGroup = const [],
    this.searchValue = '',
  });

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

  @override
  List<Object> get props => [
        groupId ?? '',
        groupName ?? '',
        flashcardsFromGroup,
        searchValue,
      ];

  bool _checkIfMatchesToSearchValue(Flashcard flashcard) {
    return flashcard.question
            .toLowerCase()
            .contains(searchValue.toLowerCase()) ||
        flashcard.answer.toLowerCase().contains(searchValue.toLowerCase());
  }
}

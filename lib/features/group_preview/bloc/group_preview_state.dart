import 'package:equatable/equatable.dart';
import 'package:fiszkomaniak/models/flashcard_model.dart';
import 'package:fiszkomaniak/models/group_model.dart';

class GroupPreviewState extends Equatable {
  final Group? group;
  final String courseName;

  int get amountOfAllFlashcards => group?.flashcards.length ?? 0;

  int get amountOfRememberedFlashcards =>
      group?.flashcards
          .where((flashcard) => flashcard.status == FlashcardStatus.remembered)
          .length ??
      0;

  const GroupPreviewState({
    this.group,
    this.courseName = '',
  });

  GroupPreviewState copyWith({
    Group? group,
    String? courseName,
  }) {
    return GroupPreviewState(
      group: group ?? this.group,
      courseName: courseName ?? this.courseName,
    );
  }

  @override
  List<Object> get props => [
        group ?? createGroup(),
        courseName,
      ];
}

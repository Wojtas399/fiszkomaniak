import 'package:equatable/equatable.dart';
import 'package:fiszkomaniak/models/flashcard_model.dart';
import 'package:fiszkomaniak/models/group_model.dart';

class FlashcardPreviewState extends Equatable {
  final Flashcard? flashcard;
  final Group? group;
  final String courseName;

  const FlashcardPreviewState({
    this.flashcard,
    this.group,
    this.courseName = '',
  });

  FlashcardPreviewState copyWith({
    Flashcard? flashcard,
    Group? group,
    String? courseName,
  }) {
    return FlashcardPreviewState(
      flashcard: flashcard ?? this.flashcard,
      group: group ?? this.group,
      courseName: courseName ?? this.courseName,
    );
  }

  @override
  List<Object> get props => [
        flashcard ?? createFlashcard(),
        group ?? createGroup(),
        courseName,
      ];
}

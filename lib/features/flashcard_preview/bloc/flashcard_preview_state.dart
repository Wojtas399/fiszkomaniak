import 'package:equatable/equatable.dart';
import 'package:fiszkomaniak/features/flashcard_preview/bloc/flashcard_preview_status.dart';
import 'package:fiszkomaniak/models/flashcard_model.dart';
import 'package:fiszkomaniak/models/group_model.dart';

class FlashcardPreviewState extends Equatable {
  final Flashcard? flashcard;
  final Group? group;
  final String courseName;
  final String? newQuestion;
  final String? newAnswer;
  final FlashcardPreviewStatus status;

  bool get displaySaveConfirmation =>
      (newQuestion != null && newQuestion != flashcard?.question) ||
      (newAnswer != null && newAnswer != flashcard?.answer);

  const FlashcardPreviewState({
    this.flashcard,
    this.group,
    this.courseName = '',
    this.newQuestion,
    this.newAnswer,
    this.status = const FlashcardPreviewStatusInitial(),
  });

  FlashcardPreviewState copyWith({
    Flashcard? flashcard,
    Group? group,
    String? courseName,
    String? newQuestion,
    String? newAnswer,
    FlashcardPreviewStatus? status,
  }) {
    return FlashcardPreviewState(
      flashcard: flashcard ?? this.flashcard,
      group: group ?? this.group,
      courseName: courseName ?? this.courseName,
      newQuestion: newQuestion ?? this.newQuestion,
      newAnswer: newAnswer ?? this.newAnswer,
      status: status ?? FlashcardPreviewStatusLoaded(),
    );
  }

  @override
  List<Object> get props => [
        flashcard ?? createFlashcard(),
        group ?? createGroup(),
        courseName,
        newQuestion ?? '',
        newAnswer ?? '',
        status,
      ];
}

class FlashcardPreviewParams {
  final String groupId;
  final int flashcardIndex;

  FlashcardPreviewParams({
    required this.groupId,
    required this.flashcardIndex,
  });
}

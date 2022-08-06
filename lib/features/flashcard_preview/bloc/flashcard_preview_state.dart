part of 'flashcard_preview_bloc.dart';

class FlashcardPreviewState extends Equatable {
  final BlocStatus status;
  final Flashcard? flashcard;
  final Group? group;
  final String courseName;
  final String question;
  final String answer;

  const FlashcardPreviewState({
    required this.status,
    required this.flashcard,
    required this.group,
    required this.courseName,
    required this.question,
    required this.answer,
  });

  @override
  List<Object> get props => [
        status,
        flashcard ?? createFlashcard(),
        group ?? createGroup(),
        courseName,
        question,
        answer,
      ];

  bool get haveQuestionOrAnswerBeenChanged =>
      (question != flashcard?.question) || (answer != flashcard?.answer);

  FlashcardPreviewState copyWith({
    BlocStatus? status,
    Flashcard? flashcard,
    Group? group,
    String? courseName,
    String? question,
    String? answer,
  }) {
    return FlashcardPreviewState(
      status: status ?? const BlocStatusInProgress(),
      flashcard: flashcard ?? this.flashcard,
      group: group ?? this.group,
      courseName: courseName ?? this.courseName,
      question: question ?? this.question,
      answer: answer ?? this.answer,
    );
  }

  FlashcardPreviewState copyWithInfo(FlashcardPreviewInfo info) {
    return copyWith(
      status: BlocStatusComplete<FlashcardPreviewInfo>(info: info),
    );
  }

  FlashcardPreviewState copyWithError(FlashcardPreviewError error) {
    return copyWith(
      status: BlocStatusError<FlashcardPreviewError>(errorType: error),
    );
  }
}

enum FlashcardPreviewInfo {
  questionAndAnswerHaveBeenInitialized,
  questionAndAnswerHaveBeenReset,
  flashcardHasBeenUpdated,
  flashcardHasBeenDeleted,
}

enum FlashcardPreviewError {
  flashcardIsIncomplete,
}

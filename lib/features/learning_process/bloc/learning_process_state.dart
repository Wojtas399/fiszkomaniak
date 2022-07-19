part of 'learning_process_bloc.dart';

class LearningProcessState extends Equatable {
  final BlocStatus status;
  final String? sessionId;
  final String courseName;
  final Group? group;
  final Duration? duration;
  final bool areQuestionsAndAnswersSwapped;
  final List<int> indexesOfRememberedFlashcards;
  final List<int> indexesOfNotRememberedFlashcards;
  final int indexOfDisplayedFlashcard;
  final FlashcardsType? flashcardsType;
  final int amountOfFlashcardsInStack;

  const LearningProcessState({
    required this.status,
    required this.sessionId,
    required this.courseName,
    required this.group,
    required this.duration,
    required this.areQuestionsAndAnswersSwapped,
    required this.indexesOfRememberedFlashcards,
    required this.indexesOfNotRememberedFlashcards,
    required this.indexOfDisplayedFlashcard,
    required this.flashcardsType,
    required this.amountOfFlashcardsInStack,
  });

  @override
  List<Object> get props => [
        status,
        sessionId ?? '',
        courseName,
        group ?? '',
        duration ?? '',
        areQuestionsAndAnswersSwapped,
        indexesOfRememberedFlashcards,
        indexesOfNotRememberedFlashcards,
        indexOfDisplayedFlashcard,
        flashcardsType ?? '',
        amountOfFlashcardsInStack,
      ];

  List<StackFlashcard> get stackFlashcards {
    final FlashcardsType? flashcardsType = this.flashcardsType;
    if (flashcardsType == null) {
      return [];
    }
    final List<Flashcard> flashcards = (group?.flashcards ?? [])
        .where(
          (flashcard) => doesFlashcardBelongToFlashcardsType(
            flashcard,
            flashcardsType,
          ),
        )
        .toList();
    return _getBasicInfoOfFlashcards(flashcards);
  }

  int get amountOfAllFlashcards => group?.flashcards.length ?? 0;

  int get amountOfRememberedFlashcards => indexesOfRememberedFlashcards.length;

  String get nameForQuestions {
    final Group? group = this.group;
    if (group == null) {
      return '';
    }
    return areQuestionsAndAnswersSwapped
        ? group.nameForAnswers
        : group.nameForQuestions;
  }

  String get nameForAnswers {
    final Group? group = this.group;
    if (group == null) {
      return '';
    }
    return areQuestionsAndAnswersSwapped
        ? group.nameForQuestions
        : group.nameForAnswers;
  }

  bool get areAllFlashcardsRememberedOrNotRemembered =>
      _areAllFlashcardsRemembered() || _areAllFlashcardsNotRemembered();

  LearningProcessState copyWith({
    BlocStatus? status,
    String? sessionId,
    String? courseName,
    Group? group,
    Duration? duration,
    bool? areQuestionsAndAnswersSwapped,
    List<int>? indexesOfRememberedFlashcards,
    List<int>? indexesOfNotRememberedFlashcards,
    int? indexOfDisplayedFlashcard,
    FlashcardsType? flashcardsType,
    int? amountOfFlashcardsInStack,
    bool removedDuration = false,
  }) {
    return LearningProcessState(
      status: status ?? const BlocStatusComplete<LearningProcessInfoType>(),
      sessionId: sessionId ?? this.sessionId,
      courseName: courseName ?? this.courseName,
      group: group ?? this.group,
      duration: removedDuration ? null : duration ?? this.duration,
      areQuestionsAndAnswersSwapped:
          areQuestionsAndAnswersSwapped ?? this.areQuestionsAndAnswersSwapped,
      indexesOfRememberedFlashcards:
          indexesOfRememberedFlashcards ?? this.indexesOfRememberedFlashcards,
      indexesOfNotRememberedFlashcards: indexesOfNotRememberedFlashcards ??
          this.indexesOfNotRememberedFlashcards,
      indexOfDisplayedFlashcard:
          indexOfDisplayedFlashcard ?? this.indexOfDisplayedFlashcard,
      flashcardsType: flashcardsType ?? this.flashcardsType,
      amountOfFlashcardsInStack:
          amountOfFlashcardsInStack ?? this.amountOfFlashcardsInStack,
    );
  }

  bool doesFlashcardBelongToFlashcardsType(
    Flashcard flashcard,
    FlashcardsType type,
  ) {
    switch (type) {
      case FlashcardsType.all:
        return true;
      case FlashcardsType.remembered:
        return indexesOfRememberedFlashcards.contains(flashcard.index);
      case FlashcardsType.notRemembered:
        return indexesOfNotRememberedFlashcards.contains(flashcard.index);
    }
  }

  List<StackFlashcard> _getBasicInfoOfFlashcards(List<Flashcard> flashcards) {
    return flashcards
        .map(
          (flashcard) => StackFlashcard(
            index: flashcard.index,
            question: areQuestionsAndAnswersSwapped
                ? flashcard.answer
                : flashcard.question,
            answer: areQuestionsAndAnswersSwapped
                ? flashcard.question
                : flashcard.answer,
          ),
        )
        .toList();
  }

  bool _areAllFlashcardsNotRemembered() {
    final List<int> indexesOfFlashcards = _getIndexesOfFlashcards();
    if (indexesOfNotRememberedFlashcards.length != indexesOfFlashcards.length) {
      return false;
    }
    for (int flashcardIndex in indexesOfFlashcards) {
      if (!indexesOfNotRememberedFlashcards.contains(flashcardIndex)) {
        return false;
      }
    }
    return true;
  }

  bool _areAllFlashcardsRemembered() {
    final List<int> indexesOfFlashcards = _getIndexesOfFlashcards();
    if (indexesOfRememberedFlashcards.length != indexesOfFlashcards.length) {
      return false;
    }
    for (int flashcardIndex in indexesOfFlashcards) {
      if (!indexesOfRememberedFlashcards.contains(flashcardIndex)) {
        return false;
      }
    }
    return true;
  }

  List<int> _getIndexesOfFlashcards() {
    return (group?.flashcards ?? [])
        .map((flashcard) => flashcard.index)
        .toList();
  }
}

enum LearningProcessInfoType {
  initialDataHasBeenLoaded,
  flashcardsStackHasBeenReset,
  sessionHasBeenFinished,
  sessionHasBeenAborted,
}

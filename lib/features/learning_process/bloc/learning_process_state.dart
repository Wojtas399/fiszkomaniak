part of 'learning_process_bloc.dart';

class LearningProcessState extends Equatable {
  final BlocStatus status;
  final String? sessionId;
  final String courseName;
  final Group? group;
  final Duration? duration;
  final bool areQuestionsAndAnswersSwapped;
  final List<Flashcard> rememberedFlashcards;
  final List<Flashcard> notRememberedFlashcards;
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
    required this.rememberedFlashcards,
    required this.notRememberedFlashcards,
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
        rememberedFlashcards,
        notRememberedFlashcards,
        indexOfDisplayedFlashcard,
        flashcardsType ?? '',
        amountOfFlashcardsInStack,
      ];

  List<Flashcard> get flashcardsInStack {
    final FlashcardsType? flashcardsType = this.flashcardsType;
    if (flashcardsType == null) {
      return [];
    }
    return (group?.flashcards ?? [])
        .where(
          (flashcard) => doesFlashcardBelongToFlashcardsType(
            flashcard,
            flashcardsType,
          ),
        )
        .toList();
  }

  int get amountOfAllFlashcards => group?.flashcards.length ?? 0;

  int get amountOfRememberedFlashcards => rememberedFlashcards.length;

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
    List<Flashcard>? rememberedFlashcards,
    List<Flashcard>? notRememberedFlashcards,
    int? indexOfDisplayedFlashcard,
    FlashcardsType? flashcardsType,
    int? amountOfFlashcardsInStack,
    bool removedDuration = false,
  }) {
    return LearningProcessState(
      status: status ?? const BlocStatusInProgress(),
      sessionId: sessionId ?? this.sessionId,
      courseName: courseName ?? this.courseName,
      group: group ?? this.group,
      duration: removedDuration ? null : duration ?? this.duration,
      areQuestionsAndAnswersSwapped:
          areQuestionsAndAnswersSwapped ?? this.areQuestionsAndAnswersSwapped,
      rememberedFlashcards: rememberedFlashcards ?? this.rememberedFlashcards,
      notRememberedFlashcards:
          notRememberedFlashcards ?? this.notRememberedFlashcards,
      indexOfDisplayedFlashcard:
          indexOfDisplayedFlashcard ?? this.indexOfDisplayedFlashcard,
      flashcardsType: flashcardsType ?? this.flashcardsType,
      amountOfFlashcardsInStack:
          amountOfFlashcardsInStack ?? this.amountOfFlashcardsInStack,
    );
  }

  LearningProcessState copyWithInfo(LearningProcessInfo info) {
    return copyWith(
      status: BlocStatusComplete<LearningProcessInfo>(info: info),
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
        return rememberedFlashcards.contains(flashcard);
      case FlashcardsType.notRemembered:
        return notRememberedFlashcards.contains(flashcard);
    }
  }

  bool _areAllFlashcardsNotRemembered() {
    final List<Flashcard> originalFlashcards = group?.flashcards ?? [];
    if (notRememberedFlashcards.length != originalFlashcards.length) {
      return false;
    }
    for (final Flashcard flashcard in originalFlashcards) {
      if (!notRememberedFlashcards.contains(flashcard)) {
        return false;
      }
    }
    return true;
  }

  bool _areAllFlashcardsRemembered() {
    final List<Flashcard> originalFlashcards = group?.flashcards ?? [];
    if (rememberedFlashcards.length != originalFlashcards.length) {
      return false;
    }
    for (final Flashcard flashcard in originalFlashcards) {
      if (!rememberedFlashcards.contains(flashcard)) {
        return false;
      }
    }
    return true;
  }
}

enum LearningProcessInfo {
  initialDataHaveBeenSet,
  flashcardsStackHasBeenReset,
  sessionHasBeenFinished,
  sessionHasBeenAborted,
}

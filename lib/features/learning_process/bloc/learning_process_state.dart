import 'package:equatable/equatable.dart';
import 'package:fiszkomaniak/features/learning_process/bloc/learning_process_status.dart';
import 'package:fiszkomaniak/models/flashcard_model.dart';
import 'package:fiszkomaniak/models/group_model.dart';
import '../../../models/session_model.dart';
import '../../flashcards_stack/bloc/flashcards_stack_models.dart';

class LearningProcessState extends Equatable {
  final LearningProcessStatus status;
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
    this.status = const LearningProcessStatusInitial(),
    this.courseName = '',
    this.group,
    this.duration,
    this.areQuestionsAndAnswersSwapped = false,
    this.indexesOfRememberedFlashcards = const [],
    this.indexesOfNotRememberedFlashcards = const [],
    this.indexOfDisplayedFlashcard = 0,
    this.flashcardsType,
    this.amountOfFlashcardsInStack = 0,
  });

  List<Flashcard> get flashcards => group?.flashcards ?? [];

  List<FlashcardInfo> get flashcardsToLearn {
    final FlashcardsType? type = flashcardsType;
    if (type == null) {
      return [];
    }
    final List<Flashcard> flashcards = (group?.flashcards ?? [])
        .where(
          (flashcard) => doesFlashcardBelongToFlashcardsType(flashcard, type),
        )
        .toList();
    return _getBasicInfoOfFlashcards(flashcards);
  }

  int get amountOfAllFlashcards => flashcards.length;

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

  bool get areAllFlashcardsRememberedOrNotRemembered {
    return indexesOfNotRememberedFlashcards.length == amountOfAllFlashcards ||
        amountOfRememberedFlashcards == amountOfAllFlashcards;
  }

  LearningProcessState copyWith({
    LearningProcessStatus? status,
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
      status: status ?? this.status,
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

  List<FlashcardInfo> _getBasicInfoOfFlashcards(List<Flashcard> flashcards) {
    return flashcards
        .map(
          (flashcard) => FlashcardInfo(
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

  @override
  List<Object> get props => [
        status,
        courseName,
        group ?? '',
        duration ?? '',
        areQuestionsAndAnswersSwapped,
        indexesOfRememberedFlashcards,
        indexOfDisplayedFlashcard,
        flashcardsType ?? '',
      ];
}

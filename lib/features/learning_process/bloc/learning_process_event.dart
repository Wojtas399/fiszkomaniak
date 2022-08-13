part of 'learning_process_bloc.dart';

abstract class LearningProcessEvent {}

class LearningProcessEventInitialize extends LearningProcessEvent {
  final String? sessionId;
  final String groupId;
  final Duration? duration;
  final FlashcardsType flashcardsType;
  final bool areQuestionsAndAnswersSwapped;

  LearningProcessEventInitialize({
    required this.sessionId,
    required this.groupId,
    required this.duration,
    required this.flashcardsType,
    required this.areQuestionsAndAnswersSwapped,
  });
}

class LearningProcessEventRememberedFlashcard extends LearningProcessEvent {
  final int flashcardIndex;

  LearningProcessEventRememberedFlashcard({required this.flashcardIndex});
}

class LearningProcessEventForgottenFlashcard extends LearningProcessEvent {
  final int flashcardIndex;

  LearningProcessEventForgottenFlashcard({required this.flashcardIndex});
}

class LearningProcessEventReset extends LearningProcessEvent {
  final FlashcardsType newFlashcardsType;

  LearningProcessEventReset({required this.newFlashcardsType});
}

class LearningProcessEventRemoveDuration extends LearningProcessEvent {}

class LearningProcessEventSessionFinished extends LearningProcessEvent {}

class LearningProcessEventSessionAborted extends LearningProcessEvent {
  final bool doesUserWantToSaveProgress;

  LearningProcessEventSessionAborted({
    required this.doesUserWantToSaveProgress,
  });
}

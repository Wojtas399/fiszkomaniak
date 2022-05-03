import 'package:fiszkomaniak/features/learning_process/bloc/learning_process_state.dart';

abstract class LearningProcessEvent {}

class LearningProcessEventInitialize extends LearningProcessEvent {
  final LearningProcessData data;

  LearningProcessEventInitialize({required this.data});
}

class LearningProcessEventRememberedFlashcard extends LearningProcessEvent {
  final int flashcardIndex;

  LearningProcessEventRememberedFlashcard({required this.flashcardIndex});
}

class LearningProcessEventForgottenFlashcard extends LearningProcessEvent {
  final int flashcardIndex;

  LearningProcessEventForgottenFlashcard({required this.flashcardIndex});
}

class LearningProcessEventReset extends LearningProcessEvent {}

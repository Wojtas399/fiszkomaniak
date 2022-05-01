import 'package:fiszkomaniak/features/learning_process/bloc/learning_process_state.dart';

abstract class LearningProcessEvent {}

class LearningProcessEventInitialize extends LearningProcessEvent {
  final LearningProcessData data;

  LearningProcessEventInitialize({required this.data});
}

class LearningProcessEventRememberedFlashcard extends LearningProcessEvent {
  final String flashcardId;

  LearningProcessEventRememberedFlashcard({required this.flashcardId});
}

class LearningProcessEventForgottenFlashcard extends LearningProcessEvent {
  final String flashcardId;

  LearningProcessEventForgottenFlashcard({required this.flashcardId});
}

class LearningProcessEventReset extends LearningProcessEvent {}

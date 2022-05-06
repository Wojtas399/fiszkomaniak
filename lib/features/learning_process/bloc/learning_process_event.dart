import 'package:fiszkomaniak/models/session_model.dart';
import '../learning_process_data.dart';

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

class LearningProcessEventReset extends LearningProcessEvent {
  final FlashcardsType newFlashcardsType;

  LearningProcessEventReset({required this.newFlashcardsType});
}

class LearningProcessEventExit extends LearningProcessEvent {}

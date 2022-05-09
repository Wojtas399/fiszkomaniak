import 'package:fiszkomaniak/features/session_preview/bloc/session_preview_mode.dart';
import 'package:fiszkomaniak/models/session_model.dart';

abstract class SessionPreviewEvent {}

class SessionPreviewEventInitialize extends SessionPreviewEvent {
  final SessionPreviewMode mode;

  SessionPreviewEventInitialize({required this.mode});
}

class SessionPreviewEventDurationChanged extends SessionPreviewEvent {
  final Duration? duration;

  SessionPreviewEventDurationChanged({required this.duration});
}

class SessionPreviewEventFlashcardsTypeChanged extends SessionPreviewEvent {
  final FlashcardsType flashcardsType;

  SessionPreviewEventFlashcardsTypeChanged({required this.flashcardsType});
}

class SessionPreviewEventSwapQuestionsAndAnswers extends SessionPreviewEvent {}

class SessionPreviewEventEditSession extends SessionPreviewEvent {}

class SessionPreviewEventDeleteSession extends SessionPreviewEvent {}

class SessionPreviewEventStartLearning extends SessionPreviewEvent {}

class SessionPreviewEventSessionsStateUpdated extends SessionPreviewEvent {}

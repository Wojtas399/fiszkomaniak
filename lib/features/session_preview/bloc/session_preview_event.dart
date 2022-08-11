part of 'session_preview_bloc.dart';

abstract class SessionPreviewEvent {}

class SessionPreviewEventInitialize extends SessionPreviewEvent {
  final SessionPreviewMode mode;

  SessionPreviewEventInitialize({required this.mode});
}

class SessionPreviewEventSessionUpdated extends SessionPreviewEvent {
  final Session session;

  SessionPreviewEventSessionUpdated({required this.session});
}

class SessionPreviewEventDurationChanged extends SessionPreviewEvent {
  final Duration duration;

  SessionPreviewEventDurationChanged({required this.duration});
}

class SessionPreviewEventResetDuration extends SessionPreviewEvent {}

class SessionPreviewEventFlashcardsTypeChanged extends SessionPreviewEvent {
  final FlashcardsType flashcardsType;

  SessionPreviewEventFlashcardsTypeChanged({required this.flashcardsType});
}

class SessionPreviewEventSwapQuestionsAndAnswers extends SessionPreviewEvent {}

class SessionPreviewEventDeleteSession extends SessionPreviewEvent {}

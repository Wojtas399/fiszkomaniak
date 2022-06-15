part of 'session_preview_bloc.dart';

abstract class SessionPreviewEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class SessionPreviewEventInitialize extends SessionPreviewEvent {
  final SessionPreviewMode mode;

  SessionPreviewEventInitialize({required this.mode});

  @override
  List<Object> get props => [mode];
}

class SessionPreviewEventDurationChanged extends SessionPreviewEvent {
  final Duration? duration;

  SessionPreviewEventDurationChanged({required this.duration});

  @override
  List<Object> get props => [duration ?? ''];
}

class SessionPreviewEventFlashcardsTypeChanged extends SessionPreviewEvent {
  final FlashcardsType flashcardsType;

  SessionPreviewEventFlashcardsTypeChanged({required this.flashcardsType});

  @override
  List<Object> get props => [flashcardsType];
}

class SessionPreviewEventSwapQuestionsAndAnswers extends SessionPreviewEvent {}

class SessionPreviewEventEditSession extends SessionPreviewEvent {}

class SessionPreviewEventDeleteSession extends SessionPreviewEvent {}

class SessionPreviewEventStartLearning extends SessionPreviewEvent {}

class SessionPreviewEventSessionsStateUpdated extends SessionPreviewEvent {}

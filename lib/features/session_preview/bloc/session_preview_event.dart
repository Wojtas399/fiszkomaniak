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

class SessionPreviewEventSessionUpdated extends SessionPreviewEvent {
  final Session session;

  SessionPreviewEventSessionUpdated({required this.session});

  @override
  List<Object> get props => [session];
}

class SessionPreviewEventDurationChanged extends SessionPreviewEvent {
  final Duration duration;

  SessionPreviewEventDurationChanged({required this.duration});

  @override
  List<Object> get props => [duration];
}

class SessionPreviewEventResetDuration extends SessionPreviewEvent {}

class SessionPreviewEventFlashcardsTypeChanged extends SessionPreviewEvent {
  final FlashcardsType flashcardsType;

  SessionPreviewEventFlashcardsTypeChanged({required this.flashcardsType});

  @override
  List<Object> get props => [flashcardsType];
}

class SessionPreviewEventSwapQuestionsAndAnswers extends SessionPreviewEvent {}

class SessionPreviewEventRemoveSession extends SessionPreviewEvent {}

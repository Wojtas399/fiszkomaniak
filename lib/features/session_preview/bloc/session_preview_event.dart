import 'package:fiszkomaniak/features/session_preview/bloc/session_preview_state.dart';
import 'package:fiszkomaniak/models/session_model.dart';
import 'package:flutter/material.dart';

abstract class SessionPreviewEvent {}

class SessionPreviewEventInitialize extends SessionPreviewEvent {
  final String sessionId;
  final SessionMode? mode;

  SessionPreviewEventInitialize({required this.sessionId, this.mode});
}

class SessionPreviewEventTimeChanged extends SessionPreviewEvent {
  final TimeOfDay time;

  SessionPreviewEventTimeChanged({required this.time});
}

class SessionPreviewEventDurationChanged extends SessionPreviewEvent {
  final TimeOfDay? duration;

  SessionPreviewEventDurationChanged({required this.duration});
}

class SessionPreviewEventNotificationTimeChanged extends SessionPreviewEvent {
  final TimeOfDay? notificationTime;

  SessionPreviewEventNotificationTimeChanged({required this.notificationTime});
}

class SessionPreviewEventFlashcardsTypeChanged extends SessionPreviewEvent {
  final FlashcardsType flashcardsType;

  SessionPreviewEventFlashcardsTypeChanged({required this.flashcardsType});
}

class SessionPreviewEventSwapQuestionsAndAnswers extends SessionPreviewEvent {}

class SessionPreviewEventResetChanges extends SessionPreviewEvent {}

class SessionPreviewEventSaveChanges extends SessionPreviewEvent {}

class SessionPreviewEventDeleteSession extends SessionPreviewEvent {}

class SessionPreviewEventStartLearning extends SessionPreviewEvent {}

class SessionPreviewEventSessionsStateUpdated extends SessionPreviewEvent {}

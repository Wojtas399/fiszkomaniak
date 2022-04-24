import 'package:fiszkomaniak/features/session_creator/bloc/session_creator_mode.dart';
import 'package:flutter/material.dart';
import '../../../models/session_model.dart';

abstract class SessionCreatorEvent {}

class SessionCreatorEventInitialize extends SessionCreatorEvent {
  final SessionCreatorMode mode;

  SessionCreatorEventInitialize({required this.mode});
}

class SessionCreatorEventCourseSelected extends SessionCreatorEvent {
  final String courseId;

  SessionCreatorEventCourseSelected({required this.courseId});
}

class SessionCreatorEventGroupSelected extends SessionCreatorEvent {
  final String groupId;

  SessionCreatorEventGroupSelected({required this.groupId});
}

class SessionCreatorEventFlashcardsTypeSelected extends SessionCreatorEvent {
  final FlashcardsType type;

  SessionCreatorEventFlashcardsTypeSelected({required this.type});
}

class SessionCreatorEventSwapQuestionsWithAnswers extends SessionCreatorEvent {}

class SessionCreatorEventDateSelected extends SessionCreatorEvent {
  final DateTime date;

  SessionCreatorEventDateSelected({required this.date});
}

class SessionCreatorEventTimeSelected extends SessionCreatorEvent {
  final TimeOfDay time;

  SessionCreatorEventTimeSelected({required this.time});
}

class SessionCreatorEventDurationSelected extends SessionCreatorEvent {
  final TimeOfDay duration;

  SessionCreatorEventDurationSelected({required this.duration});
}

class SessionCreatorEventNotificationTimeSelected extends SessionCreatorEvent {
  final TimeOfDay notificationTime;

  SessionCreatorEventNotificationTimeSelected({required this.notificationTime});
}

class SessionCreatorEventCleanDurationTime extends SessionCreatorEvent {}

class SessionCreatorEventCleanNotificationTime extends SessionCreatorEvent {}

class SessionCreatorEventSubmit extends SessionCreatorEvent {}

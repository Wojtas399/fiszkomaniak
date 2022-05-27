import 'package:fiszkomaniak/features/session_creator/bloc/session_creator_mode.dart';
import 'package:fiszkomaniak/models/time_model.dart';
import '../../../models/date_model.dart';
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
  final Date date;

  SessionCreatorEventDateSelected({required this.date});
}

class SessionCreatorEventTimeSelected extends SessionCreatorEvent {
  final Time time;

  SessionCreatorEventTimeSelected({required this.time});
}

class SessionCreatorEventDurationSelected extends SessionCreatorEvent {
  final Duration duration;

  SessionCreatorEventDurationSelected({required this.duration});
}

class SessionCreatorEventNotificationTimeSelected extends SessionCreatorEvent {
  final Time notificationTime;

  SessionCreatorEventNotificationTimeSelected({required this.notificationTime});
}

class SessionCreatorEventCleanDurationTime extends SessionCreatorEvent {}

class SessionCreatorEventCleanNotificationTime extends SessionCreatorEvent {}

class SessionCreatorEventSubmit extends SessionCreatorEvent {}

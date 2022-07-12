part of 'session_creator_bloc.dart';

abstract class SessionCreatorEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class SessionCreatorEventInitialize extends SessionCreatorEvent {
  final SessionCreatorMode mode;

  SessionCreatorEventInitialize({required this.mode});

  @override
  List<Object> get props => [mode];
}

class SessionCreatorEventCourseSelected extends SessionCreatorEvent {
  final String courseId;

  SessionCreatorEventCourseSelected({required this.courseId});

  @override
  List<Object> get props => [courseId];
}

class SessionCreatorEventGroupSelected extends SessionCreatorEvent {
  final String groupId;

  SessionCreatorEventGroupSelected({required this.groupId});

  @override
  List<Object> get props => [groupId];
}

class SessionCreatorEventFlashcardsTypeSelected extends SessionCreatorEvent {
  final FlashcardsType type;

  SessionCreatorEventFlashcardsTypeSelected({required this.type});

  @override
  List<Object> get props => [type];
}

class SessionCreatorEventSwapQuestionsWithAnswers extends SessionCreatorEvent {}

class SessionCreatorEventDateSelected extends SessionCreatorEvent {
  final Date date;

  SessionCreatorEventDateSelected({required this.date});

  @override
  List<Object> get props => [date];
}

class SessionCreatorEventStartTimeSelected extends SessionCreatorEvent {
  final Time startTime;

  SessionCreatorEventStartTimeSelected({required this.startTime});

  @override
  List<Object> get props => [startTime];
}

class SessionCreatorEventDurationSelected extends SessionCreatorEvent {
  final Duration duration;

  SessionCreatorEventDurationSelected({required this.duration});

  @override
  List<Object> get props => [duration];
}

class SessionCreatorEventNotificationTimeSelected extends SessionCreatorEvent {
  final Time notificationTime;

  SessionCreatorEventNotificationTimeSelected({required this.notificationTime});

  @override
  List<Object> get props => [notificationTime];
}

class SessionCreatorEventCleanDurationTime extends SessionCreatorEvent {}

class SessionCreatorEventCleanNotificationTime extends SessionCreatorEvent {}

class SessionCreatorEventSubmit extends SessionCreatorEvent {}

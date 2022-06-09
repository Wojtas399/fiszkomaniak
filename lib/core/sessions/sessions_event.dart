part of 'sessions_bloc.dart';

abstract class SessionsEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class SessionsEventInitialize extends SessionsEvent {}

class SessionsEventSessionsChanged extends SessionsEvent {
  final List<Session> addedSessions;
  final List<Session> updatedSessions;
  final List<Session> deletedSessions;

  SessionsEventSessionsChanged({
    required this.addedSessions,
    required this.updatedSessions,
    required this.deletedSessions,
  });

  @override
  List<Object> get props => [
        addedSessions,
        updatedSessions,
        deletedSessions,
      ];
}

class SessionsEventAddSession extends SessionsEvent {
  final Session session;

  SessionsEventAddSession({required this.session});

  @override
  List<Object> get props => [session];
}

class SessionsEventUpdateSession extends SessionsEvent {
  final String sessionId;
  final String? groupId;
  final Date? date;
  final Time? time;
  final Duration? duration;
  final Time? notificationTime;
  final FlashcardsType? flashcardsType;
  final bool? areQuestionsAndFlashcardsSwapped;

  SessionsEventUpdateSession({
    required this.sessionId,
    this.groupId,
    this.date,
    this.time,
    this.duration,
    this.notificationTime,
    this.flashcardsType,
    this.areQuestionsAndFlashcardsSwapped,
  });

  @override
  List<Object> get props => [
        sessionId,
        groupId ?? '',
        date ?? '',
        time ?? '',
        duration ?? '',
        notificationTime ?? '',
        flashcardsType ?? '',
        areQuestionsAndFlashcardsSwapped ?? '',
      ];
}

class SessionsEventRemoveSession extends SessionsEvent {
  final String sessionId;
  final bool removeAfterLearningProcess;

  SessionsEventRemoveSession({
    required this.sessionId,
    this.removeAfterLearningProcess = false,
  });

  @override
  List<Object> get props => [
        sessionId,
        removeAfterLearningProcess,
      ];
}

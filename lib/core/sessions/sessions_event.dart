import 'package:equatable/equatable.dart';
import 'package:fiszkomaniak/models/session_model.dart';
import 'package:flutter/material.dart';

abstract class SessionsEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class SessionsEventInitialize extends SessionsEvent {}

class SessionsEventSessionAdded extends SessionsEvent {
  final Session session;

  SessionsEventSessionAdded({required this.session});
}

class SessionsEventSessionUpdated extends SessionsEvent {
  final Session session;

  SessionsEventSessionUpdated({required this.session});
}

class SessionsEventSessionRemoved extends SessionsEvent {
  final String sessionId;

  SessionsEventSessionRemoved({required this.sessionId});
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
  final DateTime? date;
  final TimeOfDay? time;
  final TimeOfDay? duration;
  final TimeOfDay? notificationTime;
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

  SessionsEventRemoveSession({required this.sessionId});

  @override
  List<Object> get props => [sessionId];
}

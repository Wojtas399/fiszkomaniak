import 'package:equatable/equatable.dart';
import 'package:fiszkomaniak/models/session_model.dart';

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
}

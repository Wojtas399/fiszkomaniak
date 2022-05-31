part of 'sessions_bloc.dart';

abstract class SessionsStatus extends Equatable {
  const SessionsStatus();

  @override
  List<Object> get props => [];
}

class SessionsStatusInitial extends SessionsStatus {
  const SessionsStatusInitial();
}

class SessionsStatusLoaded extends SessionsStatus {}

class SessionsStatusLoading extends SessionsStatus {}

class SessionsStatusSessionAdded extends SessionsStatus {
  final String sessionId;

  const SessionsStatusSessionAdded({required this.sessionId});

  @override
  List<Object> get props => [sessionId];
}

class SessionsStatusSessionUpdated extends SessionsStatus {
  final String sessionId;

  const SessionsStatusSessionUpdated({required this.sessionId});

  @override
  List<Object> get props => [sessionId];
}

class SessionsStatusSessionRemoved extends SessionsStatus {
  final String sessionId;

  const SessionsStatusSessionRemoved({required this.sessionId});

  @override
  List<Object> get props => [sessionId];
}

class SessionsStatusError extends SessionsStatus {
  final String message;

  const SessionsStatusError({required this.message});

  @override
  List<Object> get props => [message];
}

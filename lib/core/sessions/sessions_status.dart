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

class SessionsStatusSessionAdded extends SessionsStatus {}

class SessionsStatusSessionUpdated extends SessionsStatus {}

class SessionsStatusSessionRemoved extends SessionsStatus {}

class SessionsStatusError extends SessionsStatus {
  final String message;

  const SessionsStatusError({required this.message});

  @override
  List<Object> get props => [message];
}

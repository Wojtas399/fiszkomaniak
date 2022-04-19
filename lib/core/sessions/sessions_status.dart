abstract class SessionsStatus {
  const SessionsStatus();
}

class SessionsStatusInitial extends SessionsStatus {
  const SessionsStatusInitial();
}

class SessionsStatusLoaded extends SessionsStatus {}

class SessionsStatusLoading extends SessionsStatus {}

class SessionsStatusSessionAdded extends SessionsStatus {}

class SessionsStatusError extends SessionsStatus {
  final String message;

  SessionsStatusError({required this.message});
}

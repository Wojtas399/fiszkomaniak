part of 'sessions_bloc.dart';

class SessionsState extends Equatable {
  final InitializationStatus initializationStatus;
  final List<Session> allSessions;
  final SessionsStatus status;

  const SessionsState({
    this.initializationStatus = InitializationStatus.loading,
    this.allSessions = const [],
    this.status = const SessionsStatusInitial(),
  });

  @override
  List<Object> get props => [
        initializationStatus,
        allSessions,
        status,
      ];

  SessionsState copyWith({
    InitializationStatus? initializationStatus,
    List<Session>? allSessions,
    SessionsStatus? status,
  }) {
    return SessionsState(
      initializationStatus: initializationStatus ?? this.initializationStatus,
      allSessions: allSessions ?? this.allSessions,
      status: status ?? SessionsStatusLoaded(),
    );
  }

  Session? getSessionById(String? sessionId) {
    final List<Session?> sessions = [...allSessions];
    return sessions.firstWhere(
      (session) => session?.id == sessionId,
      orElse: () => null,
    );
  }
}

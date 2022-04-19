import 'package:equatable/equatable.dart';
import 'package:fiszkomaniak/core/sessions/sessions_status.dart';
import 'package:fiszkomaniak/models/session_model.dart';

class SessionsState extends Equatable {
  final List<Session> allSessions;
  final SessionsStatus status;

  const SessionsState({
    this.allSessions = const [],
    this.status = const SessionsStatusInitial(),
  });

  SessionsState copyWith({
    List<Session>? allSessions,
    SessionsStatus? status,
  }) {
    return SessionsState(
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

  @override
  List<Object> get props => [
        allSessions,
        status,
      ];
}

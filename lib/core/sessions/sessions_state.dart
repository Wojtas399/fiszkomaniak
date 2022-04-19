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

  @override
  List<Object> get props => [
        allSessions,
        status,
      ];
}

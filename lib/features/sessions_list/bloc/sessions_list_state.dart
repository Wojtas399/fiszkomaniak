part of 'sessions_list_bloc.dart';

class SessionsListState extends Equatable {
  final BlocStatus status;
  final List<SessionItemParams> sessionsItemsParams;

  const SessionsListState({
    required this.status,
    required this.sessionsItemsParams,
  });

  @override
  List<Object> get props => [
        status,
        sessionsItemsParams,
      ];

  SessionsListState copyWith({
    BlocStatus? status,
    List<SessionItemParams>? sessionsItemsParams,
  }) {
    return SessionsListState(
      status: status ?? const BlocStatusComplete(),
      sessionsItemsParams: sessionsItemsParams ?? this.sessionsItemsParams,
    );
  }
}

class SessionItemParams extends Equatable {
  final String sessionId;
  final Date date;
  final Time startTime;
  final Duration? duration;
  final String groupName;
  final String courseName;

  const SessionItemParams({
    required this.sessionId,
    required this.date,
    required this.startTime,
    required this.duration,
    required this.groupName,
    required this.courseName,
  });

  @override
  List<Object> get props => [
        sessionId,
        date,
        startTime,
        duration ?? '',
        groupName,
        courseName,
      ];
}

SessionItemParams createSessionItemParams({
  String sessionId = '',
  Date date = const Date(year: 2022, month: 1, day: 1),
  Time startTime = const Time(hour: 12, minute: 30),
  Duration? duration,
  String groupName = '',
  String courseName = '',
}) {
  return SessionItemParams(
    sessionId: sessionId,
    date: date,
    startTime: startTime,
    duration: duration,
    groupName: groupName,
    courseName: courseName,
  );
}

import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';
import '../../domain/use_cases/courses/get_course_use_case.dart';
import '../../domain/use_cases/groups/get_group_use_case.dart';
import '../../models/date_model.dart';
import '../../models/time_model.dart';
import '../../domain/entities/session.dart';
import '../../domain/use_cases/sessions/get_all_sessions_use_case.dart';

class SessionsListCubit extends Cubit<List<SessionItemParams>> {
  late final GetAllSessionsUseCase _getAllSessionsUseCase;
  late final GetGroupUseCase _getGroupUseCase;
  late final GetCourseUseCase _getCourseUseCase;
  StreamSubscription<List<SessionItemParams>>? _sessionsItemsParamsListener;

  SessionsListCubit({
    required GetAllSessionsUseCase getAllSessionsUseCase,
    required GetGroupUseCase getGroupUseCase,
    required GetCourseUseCase getCourseUseCase,
  }) : super([]) {
    _getAllSessionsUseCase = getAllSessionsUseCase;
    _getGroupUseCase = getGroupUseCase;
    _getCourseUseCase = getCourseUseCase;
  }

  @override
  Future<void> close() {
    _sessionsItemsParamsListener?.cancel();
    return super.close();
  }

  void initialize() {
    _sessionsItemsParamsListener ??= _getAllSessionsUseCase
        .execute()
        .map((allSessions) => allSessions.map(_createSessionItemParamsStream))
        .switchMap(_convertListOfStreamsIntoStreamOfList)
        .listen((sessionsItemsParams) => emit(sessionsItemsParams));
  }

  Stream<SessionItemParams> _createSessionItemParamsStream(
    Session session,
  ) {
    return _getGroupUseCase.execute(groupId: session.groupId).switchMap(
          (group) => _getCourseNameStream(group.courseId).map(
            (courseName) => SessionItemParams(
              sessionId: session.id,
              date: session.date,
              startTime: session.startTime,
              duration: session.duration,
              groupName: group.name,
              courseName: courseName,
            ),
          ),
        );
  }

  Stream<List<SessionItemParams>> _convertListOfStreamsIntoStreamOfList(
    Iterable<Stream<SessionItemParams>> sessionsItemsParamsStreams,
  ) {
    if (sessionsItemsParamsStreams.isEmpty) {
      return Stream.value([]);
    }
    return Rx.combineLatest(
      sessionsItemsParamsStreams,
      (List<SessionItemParams> sessionsItemsParams) => sessionsItemsParams,
    );
  }

  Stream<String> _getCourseNameStream(String courseId) {
    return _getCourseUseCase
        .execute(courseId: courseId)
        .map((course) => course.name);
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

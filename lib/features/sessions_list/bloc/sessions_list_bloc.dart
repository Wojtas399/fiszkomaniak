import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:fiszkomaniak/domain/use_cases/courses/get_course_use_case.dart';
import 'package:fiszkomaniak/domain/use_cases/groups/get_group_use_case.dart';
import 'package:fiszkomaniak/models/bloc_status.dart';
import 'package:fiszkomaniak/models/date_model.dart';
import 'package:fiszkomaniak/models/time_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';
import '../../../domain/entities/session.dart';
import '../../../domain/use_cases/sessions/get_all_sessions_use_case.dart';
import '../../../domain/use_cases/sessions/load_all_sessions_use_case.dart';

part 'sessions_list_event.dart';

part 'sessions_list_state.dart';

class SessionsListBloc extends Bloc<SessionsListEvent, SessionsListState> {
  late final LoadAllSessionsUseCase _loadAllSessionsUseCase;
  late final GetAllSessionsUseCase _getAllSessionsUseCase;
  late final GetGroupUseCase _getGroupUseCase;
  late final GetCourseUseCase _getCourseUseCase;
  StreamSubscription<List<SessionItemParams>>? _sessionsItemsParamsListener;

  SessionsListBloc({
    required LoadAllSessionsUseCase loadAllSessionsUseCase,
    required GetAllSessionsUseCase getAllSessionsUseCase,
    required GetGroupUseCase getGroupUseCase,
    required GetCourseUseCase getCourseUseCase,
    BlocStatus status = const BlocStatusInitial(),
    List<SessionItemParams> sessionsItemsParams = const [],
  }) : super(
          SessionsListState(
            status: status,
            sessionsItemsParams: sessionsItemsParams,
          ),
        ) {
    _loadAllSessionsUseCase = loadAllSessionsUseCase;
    _getAllSessionsUseCase = getAllSessionsUseCase;
    _getGroupUseCase = getGroupUseCase;
    _getCourseUseCase = getCourseUseCase;
    on<SessionsListEventInitialize>(_initialize);
    on<SessionsListEventSessionsItemsParamsUpdated>(
      _sessionsItemsParamsUpdated,
    );
  }

  @override
  Future<void> close() {
    _sessionsItemsParamsListener?.cancel();
    return super.close();
  }

  Future<void> _initialize(
    SessionsListEventInitialize event,
    Emitter<SessionsListState> emit,
  ) async {
    emit(state.copyWith(status: const BlocStatusLoading()));
    _setSessionsItemsParamsListener();
    await _loadAllSessionsUseCase.execute();
  }

  void _sessionsItemsParamsUpdated(
    SessionsListEventSessionsItemsParamsUpdated event,
    Emitter<SessionsListState> emit,
  ) {
    emit(state.copyWith(
      sessionsItemsParams: event.sessionsItemsParams,
    ));
  }

  void _setSessionsItemsParamsListener() {
    _sessionsItemsParamsListener ??= _getAllSessionsUseCase
        .execute()
        .map((allSessions) => allSessions.map(_createSessionItemParamsStream))
        .switchMap(_convertListOfStreamsIntoStreamOfList)
        .listen(
          (sessionsItemsParams) => add(
            SessionsListEventSessionsItemsParamsUpdated(
              sessionsItemsParams: sessionsItemsParams,
            ),
          ),
        );
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

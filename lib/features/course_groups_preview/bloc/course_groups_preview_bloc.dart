import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';
import '../../../domain/entities/course.dart';
import '../../../domain/entities/group.dart';
import '../../../domain/use_cases/courses/get_course_use_case.dart';
import '../../../domain/use_cases/groups/get_groups_by_course_id_use_case.dart';

part 'course_groups_preview_event.dart';

part 'course_groups_preview_state.dart';

class CourseGroupsPreviewBloc
    extends Bloc<CourseGroupsPreviewEvent, CourseGroupsPreviewState> {
  late final GetCourseUseCase _getCourseUseCase;
  late final GetGroupsByCourseIdUseCase _getGroupsByCourseIdUseCase;
  StreamSubscription<CourseGroupsPreviewStateListenedParams>? _paramsListener;

  CourseGroupsPreviewBloc({
    required GetCourseUseCase getCourseUseCase,
    required GetGroupsByCourseIdUseCase getGroupsByCourseIdUseCase,
    String courseName = '',
    String searchValue = '',
    List<Group> groupsFromCourse = const [],
  }) : super(
          CourseGroupsPreviewState(
            courseName: courseName,
            searchValue: searchValue,
            groupsFromCourse: groupsFromCourse,
          ),
        ) {
    _getCourseUseCase = getCourseUseCase;
    _getGroupsByCourseIdUseCase = getGroupsByCourseIdUseCase;
    on<CourseGroupsPreviewEventInitialize>(_initialize);
    on<CourseGroupsPreviewEventListenedParamsUpdated>(_listenedParamsUpdated);
    on<CourseGroupsPreviewEventSearchValueChanged>(_searchValueChanged);
  }

  @override
  Future<void> close() {
    _paramsListener?.cancel();
    return super.close();
  }

  Future<void> _initialize(
    CourseGroupsPreviewEventInitialize event,
    Emitter<CourseGroupsPreviewState> emit,
  ) async {
    _setParamsListener(event.courseId);
  }

  void _listenedParamsUpdated(
    CourseGroupsPreviewEventListenedParamsUpdated event,
    Emitter<CourseGroupsPreviewState> emit,
  ) {
    emit(state.copyWith(
      courseName: event.params.courseName,
      groupsFromCourse: event.params.groupsFromCourse,
    ));
  }

  void _searchValueChanged(
    CourseGroupsPreviewEventSearchValueChanged event,
    Emitter<CourseGroupsPreviewState> emit,
  ) {
    emit(state.copyWith(
      searchValue: event.searchValue,
    ));
  }

  void _setParamsListener(final String courseId) {
    _paramsListener ??= Rx.combineLatest2(
      _getCourseName(courseId),
      _getGroupsByCourseIdUseCase.execute(courseId: courseId),
      (
        String courseName,
        List<Group> groupsFromCourse,
      ) =>
          CourseGroupsPreviewStateListenedParams(
        courseName: courseName,
        groupsFromCourse: groupsFromCourse,
      ),
    ).listen(
      (CourseGroupsPreviewStateListenedParams params) {
        add(
          CourseGroupsPreviewEventListenedParamsUpdated(params: params),
        );
      },
    );
  }

  Stream<String> _getCourseName(String courseId) {
    return _getCourseUseCase
        .execute(courseId: courseId)
        .map((Course course) => course.name);
  }
}

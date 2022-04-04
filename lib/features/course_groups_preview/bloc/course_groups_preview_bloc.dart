import 'dart:async';

import 'package:fiszkomaniak/core/courses/courses_bloc.dart';
import 'package:fiszkomaniak/core/groups/groups_bloc.dart';
import 'package:fiszkomaniak/features/course_groups_preview/bloc/course_groups_preview_event.dart';
import 'package:fiszkomaniak/features/course_groups_preview/bloc/course_groups_preview_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../models/course_model.dart';

class CourseGroupsPreviewBloc
    extends Bloc<CourseGroupsPreviewEvent, CourseGroupsPreviewState> {
  late final CoursesBloc _coursesBloc;
  late final GroupsBloc _groupsBloc;
  StreamSubscription? _groupsStateSubscription;

  CourseGroupsPreviewBloc({
    required CoursesBloc coursesBloc,
    required GroupsBloc groupsBloc,
  }) : super(const CourseGroupsPreviewState()) {
    _coursesBloc = coursesBloc;
    _groupsBloc = groupsBloc;
    on<CourseGroupsPreviewEventInitialize>(_initialize);
    on<CourseGroupsPreviewEventGroupsStateChanged>(_groupsStateChanged);
    on<CourseGroupsPreviewEventSearchValueChanged>(_searchValueChanged);
  }

  void _initialize(
    CourseGroupsPreviewEventInitialize event,
    Emitter<CourseGroupsPreviewState> emit,
  ) {
    final Course? course = _coursesBloc.state.getCourseById(event.courseId);
    if (course != null) {
      emit(state.copyWith(course: course));
      add(CourseGroupsPreviewEventGroupsStateChanged());
      _groupsStateSubscription = _groupsBloc.stream.listen((_) {
        add(CourseGroupsPreviewEventGroupsStateChanged());
      });
    }
  }

  void _groupsStateChanged(
    CourseGroupsPreviewEventGroupsStateChanged event,
    Emitter<CourseGroupsPreviewState> emit,
  ) {
    final String? courseId = state.course?.id;
    if (courseId != null) {
      emit(
        state.copyWith(
          groupsFromCourse: _groupsBloc.state.getGroupsByCourseId(courseId),
        ),
      );
    }
  }

  void _searchValueChanged(
    CourseGroupsPreviewEventSearchValueChanged event,
    Emitter<CourseGroupsPreviewState> emit,
  ) {
    emit(state.copyWith(searchValue: event.searchValue));
  }

  @override
  Future<void> close() {
    _groupsStateSubscription?.cancel();
    return super.close();
  }
}

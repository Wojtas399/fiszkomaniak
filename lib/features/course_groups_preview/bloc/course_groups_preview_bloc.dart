import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:fiszkomaniak/core/groups/groups_bloc.dart';
import 'package:fiszkomaniak/interfaces/courses_interface.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../models/course_model.dart';
import '../../../models/group_model.dart';

part 'course_groups_preview_event.dart';

part 'course_groups_preview_state.dart';

class CourseGroupsPreviewBloc
    extends Bloc<CourseGroupsPreviewEvent, CourseGroupsPreviewState> {
  late final CoursesInterface _coursesInterface;
  late final GroupsBloc _groupsBloc;
  StreamSubscription<Course>? _courseListener;
  StreamSubscription? _groupsStateSubscription;

  CourseGroupsPreviewBloc({
    required CoursesInterface coursesInterface,
    required GroupsBloc groupsBloc,
  }) : super(const CourseGroupsPreviewState()) {
    _coursesInterface = coursesInterface;
    _groupsBloc = groupsBloc;
    on<CourseGroupsPreviewEventInitialize>(_initialize);
    on<CourseGroupsPreviewEventCourseUpdated>(_courseUpdated);
    on<CourseGroupsPreviewEventGroupsStateChanged>(_groupsStateChanged);
    on<CourseGroupsPreviewEventSearchValueChanged>(_searchValueChanged);
  }

  @override
  Future<void> close() {
    _courseListener?.cancel();
    _groupsStateSubscription?.cancel();
    return super.close();
  }

  Future<void> _initialize(
    CourseGroupsPreviewEventInitialize event,
    Emitter<CourseGroupsPreviewState> emit,
  ) async {
    _setCourseListener(event.courseId);
  }

  void _courseUpdated(
    CourseGroupsPreviewEventCourseUpdated event,
    Emitter<CourseGroupsPreviewState> emit,
  ) {
    emit(state.copyWith(
      course: event.updatedCourse,
    ));
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

  void _setCourseListener(final String courseId) {
    _courseListener = _coursesInterface.getCourseById(courseId).listen(
          (course) => add(
            CourseGroupsPreviewEventCourseUpdated(updatedCourse: course),
          ),
        );
  }
}

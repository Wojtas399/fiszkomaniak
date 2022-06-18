import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:fiszkomaniak/interfaces/courses_interface.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/course.dart';
import '../../../models/group_model.dart';

part 'course_groups_preview_event.dart';

part 'course_groups_preview_state.dart';

class CourseGroupsPreviewBloc
    extends Bloc<CourseGroupsPreviewEvent, CourseGroupsPreviewState> {
  late final CoursesInterface _coursesInterface;
  StreamSubscription<Course>? _courseListener;

  CourseGroupsPreviewBloc({
    required CoursesInterface coursesInterface,
  }) : super(const CourseGroupsPreviewState()) {
    _coursesInterface = coursesInterface;
    on<CourseGroupsPreviewEventInitialize>(_initialize);
    on<CourseGroupsPreviewEventCourseUpdated>(_courseUpdated);
    on<CourseGroupsPreviewEventSearchValueChanged>(_searchValueChanged);
  }

  @override
  Future<void> close() {
    _courseListener?.cancel();
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

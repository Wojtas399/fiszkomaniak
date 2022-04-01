import 'dart:async';
import 'package:fiszkomaniak/core/courses/courses_bloc.dart';
import 'package:fiszkomaniak/core/courses/courses_event.dart';
import 'package:fiszkomaniak/features/course_creator/bloc/course_creator_event.dart';
import 'package:fiszkomaniak/features/course_creator/bloc/course_creator_state.dart';
import 'package:fiszkomaniak/features/course_creator/course_creator_mode.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/courses/courses_state.dart';

class CourseCreatorBloc extends Bloc<CourseCreatorEvent, CourseCreatorState> {
  late final CoursesBloc _coursesBloc;
  StreamSubscription? _coursesStateSubscription;

  CourseCreatorBloc({
    required CoursesBloc coursesBloc,
  }) : super(const CourseCreatorState()) {
    _coursesBloc = coursesBloc;
    on<CourseCreatorEventInitialize>(_initialize);
    on<CourseCreatorEventCourseNameChanged>(_courseNameChanged);
    on<CourseCreatorEventSaveChanges>(_saveChanges);
    on<CourseCreatorEventHttpStatusChanged>(_httpStatusChanged);
  }

  void _initialize(
    CourseCreatorEventInitialize event,
    Emitter<CourseCreatorState> emit,
  ) {
    _setCoursesBlocStateSubscription();
    CourseCreatorMode creatorMode = event.mode;
    if (creatorMode is CourseCreatorCreateMode) {
      emit(state.copyWith(mode: creatorMode));
    } else if (creatorMode is CourseCreatorEditMode) {
      emit(state.copyWith(
        mode: creatorMode,
        courseName: creatorMode.course.name,
      ));
    }
  }

  void _courseNameChanged(
    CourseCreatorEventCourseNameChanged event,
    Emitter<CourseCreatorState> emit,
  ) {
    emit(state.copyWith(
      courseName: event.courseName,
    ));
  }

  void _saveChanges(
    CourseCreatorEventSaveChanges event,
    Emitter<CourseCreatorState> emit,
  ) {
    CourseCreatorMode mode = state.mode;
    if (mode is CourseCreatorCreateMode) {
      _coursesBloc.add(CoursesEventAddNewCourse(name: state.courseName));
    } else if (mode is CourseCreatorEditMode) {
      _coursesBloc.add(CoursesEventUpdateCourseName(
        courseId: mode.course.id,
        newCourseName: state.courseName,
      ));
    }
  }

  void _httpStatusChanged(
    CourseCreatorEventHttpStatusChanged event,
    Emitter<CourseCreatorState> emit,
  ) {
    emit(state.copyWith(httpStatus: event.httpStatus));
  }

  void _setCoursesBlocStateSubscription() {
    _coursesStateSubscription = _coursesBloc.stream.listen(
      (CoursesState coursesState) {
        if (coursesState.httpStatus != state.httpStatus) {
          add(CourseCreatorEventHttpStatusChanged(
            httpStatus: coursesState.httpStatus,
          ));
        }
      },
    );
  }

  @override
  Future<void> close() {
    _coursesStateSubscription?.cancel();
    return super.close();
  }
}

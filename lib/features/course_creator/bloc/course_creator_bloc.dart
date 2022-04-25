import 'package:fiszkomaniak/core/courses/courses_bloc.dart';
import 'package:fiszkomaniak/core/courses/courses_event.dart';
import 'package:fiszkomaniak/features/course_creator/bloc/course_creator_dialogs.dart';
import 'package:fiszkomaniak/features/course_creator/bloc/course_creator_event.dart';
import 'package:fiszkomaniak/features/course_creator/bloc/course_creator_state.dart';
import 'package:fiszkomaniak/features/course_creator/course_creator_mode.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CourseCreatorBloc extends Bloc<CourseCreatorEvent, CourseCreatorState> {
  late final CoursesBloc _coursesBloc;
  late final CourseCreatorDialogs _courseCreatorDialogs;

  CourseCreatorBloc({
    required CoursesBloc coursesBloc,
    required CourseCreatorDialogs courseCreatorDialogs,
  }) : super(const CourseCreatorState()) {
    _coursesBloc = coursesBloc;
    _courseCreatorDialogs = courseCreatorDialogs;
    on<CourseCreatorEventInitialize>(_initialize);
    on<CourseCreatorEventCourseNameChanged>(_courseNameChanged);
    on<CourseCreatorEventSaveChanges>(_saveChanges);
  }

  void _initialize(
    CourseCreatorEventInitialize event,
    Emitter<CourseCreatorState> emit,
  ) {
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
    final String courseName = state.courseName.trim();
    if (_coursesBloc.state.isThereCourseWithTheSameName(courseName)) {
      _courseCreatorDialogs.displayInfoAboutAlreadyTakenCourseName();
    } else {
      CourseCreatorMode mode = state.mode;
      if (mode is CourseCreatorCreateMode) {
        _coursesBloc.add(CoursesEventAddNewCourse(name: courseName));
      } else if (mode is CourseCreatorEditMode) {
        _coursesBloc.add(CoursesEventUpdateCourseName(
          courseId: mode.course.id,
          newCourseName: courseName,
        ));
      }
    }
  }
}

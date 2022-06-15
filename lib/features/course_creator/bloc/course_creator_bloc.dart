import 'package:fiszkomaniak/features/course_creator/bloc/course_creator_dialogs.dart';
import 'package:fiszkomaniak/features/course_creator/bloc/course_creator_event.dart';
import 'package:fiszkomaniak/features/course_creator/bloc/course_creator_state.dart';
import 'package:fiszkomaniak/features/course_creator/course_creator_mode.dart';
import 'package:fiszkomaniak/interfaces/courses_interface.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CourseCreatorBloc extends Bloc<CourseCreatorEvent, CourseCreatorState> {
  late final CoursesInterface _coursesInterface;
  late final CourseCreatorDialogs _courseCreatorDialogs;

  CourseCreatorBloc({
    required CoursesInterface coursesInterface,
    required CourseCreatorDialogs courseCreatorDialogs,
  }) : super(const CourseCreatorState()) {
    _coursesInterface = coursesInterface;
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

  Future<void> _saveChanges(
    CourseCreatorEventSaveChanges event,
    Emitter<CourseCreatorState> emit,
  ) async {
    final String courseName = state.courseName.trim();
    if (await _coursesInterface.isThereCourseWithTheSameName(courseName)) {
      _courseCreatorDialogs.displayInfoAboutAlreadyTakenCourseName();
    } else {
      CourseCreatorMode mode = state.mode;
      if (mode is CourseCreatorCreateMode) {
        await _coursesInterface.addNewCourse(name: courseName);
      } else if (mode is CourseCreatorEditMode) {
        await _coursesInterface.updateCourseName(
          courseId: mode.course.id,
          newCourseName: courseName,
        );
      }
    }
  }
}

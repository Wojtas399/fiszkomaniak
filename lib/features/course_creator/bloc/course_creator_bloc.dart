import 'package:fiszkomaniak/features/course_creator/bloc/course_creator_event.dart';
import 'package:fiszkomaniak/features/course_creator/bloc/course_creator_state.dart';
import 'package:fiszkomaniak/features/course_creator/course_creator_arguments.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CourseCreatorBloc extends Bloc<CourseCreatorEvent, CourseCreatorState> {
  CourseCreatorBloc() : super(CourseCreatorState()) {
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
        courseName: creatorMode.courseName,
      ));
    }
  }

  void _courseNameChanged(
    CourseCreatorEventCourseNameChanged event,
    Emitter<CourseCreatorState> emit,
  ) {
    emit(state.copyWith(
      courseName: event.courseName,
      hasCourseNameBeenEdited: true,
    ));
  }

  void _saveChanges(
    CourseCreatorEventSaveChanges event,
    Emitter<CourseCreatorState> emit,
  ) {
    print(state.courseName);
  }
}

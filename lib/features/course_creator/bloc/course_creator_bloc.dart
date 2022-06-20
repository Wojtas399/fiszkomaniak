import 'package:equatable/equatable.dart';
import 'package:fiszkomaniak/domain/use_cases/courses/add_new_course_use_case.dart';
import 'package:fiszkomaniak/domain/use_cases/courses/check_course_name_usage_use_case.dart';
import 'package:fiszkomaniak/domain/use_cases/courses/update_course_name_use_case.dart';
import 'package:fiszkomaniak/features/course_creator/course_creator_mode.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../models/bloc_status.dart';

part 'course_creator_event.dart';

part 'course_creator_state.dart';

class CourseCreatorBloc extends Bloc<CourseCreatorEvent, CourseCreatorState> {
  late final AddNewCourseUseCase _addNewCourseUseCase;
  late final CheckCourseNameUsageUseCase _checkCourseNameUsageUseCase;
  late final UpdateCourseNameUseCase _updateCourseNameUseCase;

  CourseCreatorBloc({
    required AddNewCourseUseCase addNewCourseUseCase,
    required CheckCourseNameUsageUseCase checkCourseNameUsageUseCase,
    required UpdateCourseNameUseCase updateCourseNameUseCase,
  }) : super(const CourseCreatorState()) {
    _addNewCourseUseCase = addNewCourseUseCase;
    _checkCourseNameUsageUseCase = checkCourseNameUsageUseCase;
    _updateCourseNameUseCase = updateCourseNameUseCase;
    on<CourseCreatorEventInitialize>(_initialize);
    on<CourseCreatorEventCourseNameChanged>(_courseNameChanged);
    on<CourseCreatorEventSaveChanges>(_saveChanges);
  }

  void _initialize(
    CourseCreatorEventInitialize event,
    Emitter<CourseCreatorState> emit,
  ) {
    CourseCreatorMode mode = event.mode;
    if (mode is CourseCreatorCreateMode) {
      emit(state.copyWith(mode: mode));
    } else if (mode is CourseCreatorEditMode) {
      emit(state.copyWith(
        mode: mode,
        courseName: mode.course.name,
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
    emit(state.copyWith(
      status: const BlocStatusLoading(),
    ));
    final String courseName = state.courseName.trim();
    final bool isCourseNameAlreadyTaken =
        await _checkCourseNameUsageUseCase.execute(courseName: courseName);
    if (isCourseNameAlreadyTaken) {
      emit(state.copyWith(
        status: const BlocStatusComplete(
          info: CourseCreatorInfoType.courseNameIsAlreadyTaken,
        ),
      ));
    } else {
      CourseCreatorMode mode = state.mode;
      if (mode is CourseCreatorCreateMode) {
        await _addNewCourse(courseName, emit);
      } else if (mode is CourseCreatorEditMode) {
        await _updateCourseName(mode.course.id, courseName, emit);
      }
    }
  }

  Future<void> _addNewCourse(
    String courseName,
    Emitter<CourseCreatorState> emit,
  ) async {
    await _addNewCourseUseCase.execute(courseName: courseName);
    emit(state.copyWith(
      status: const BlocStatusComplete(
        info: CourseCreatorInfoType.courseHasBeenAdded,
      ),
    ));
  }

  Future<void> _updateCourseName(
    String courseId,
    String newCourseName,
    Emitter<CourseCreatorState> emit,
  ) async {
    await _updateCourseNameUseCase.execute(
      courseId: courseId,
      newCourseName: newCourseName,
    );
    emit(state.copyWith(
      status: const BlocStatusComplete(
        info: CourseCreatorInfoType.courseHasBeenUpdated,
      ),
    ));
  }
}

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/use_cases/courses/add_new_course_use_case.dart';
import '../../../domain/use_cases/courses/check_course_name_usage_use_case.dart';
import '../../../domain/use_cases/courses/update_course_name_use_case.dart';
import '../../../models/bloc_status.dart';
import 'course_creator_mode.dart';

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
    BlocStatus status = const BlocStatusInitial(),
    CourseCreatorMode mode = const CourseCreatorCreateMode(),
    String courseName = '',
  }) : super(
          CourseCreatorState(
            status: status,
            mode: mode,
            courseName: courseName,
          ),
        ) {
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
      emit(state.copyWithError(
        CourseCreatorError.courseNameIsAlreadyTaken,
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
    emit(state.copyWithInfo(
      CourseCreatorInfo.courseHasBeenAdded,
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
    emit(state.copyWithInfo(
      CourseCreatorInfo.courseHasBeenUpdated,
    ));
  }
}

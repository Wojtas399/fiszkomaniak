import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:fiszkomaniak/domain/use_cases/courses/get_all_courses_use_case.dart';
import 'package:fiszkomaniak/domain/use_cases/courses/load_all_courses_use_case.dart';
import 'package:fiszkomaniak/domain/use_cases/courses/remove_course_use_case.dart';
import 'package:fiszkomaniak/domain/entities/course.dart';
import 'package:fiszkomaniak/features/courses_library/courses_library_dialogs.dart';
import 'package:fiszkomaniak/models/bloc_status.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../config/navigation.dart';
import '../../course_creator/course_creator_mode.dart';

part 'courses_library_event.dart';

part 'courses_library_state.dart';

class CoursesLibraryBloc
    extends Bloc<CoursesLibraryEvent, CoursesLibraryState> {
  late final GetAllCoursesUseCase _getAllCoursesUseCase;
  late final LoadAllCoursesUseCase _loadAllCoursesUseCase;
  late final RemoveCourseUseCase _removeCourseUseCase;
  late final CoursesLibraryDialogs _coursesLibraryDialogs;
  late final Navigation _navigation;
  StreamSubscription<List<Course>>? _coursesListener;

  CoursesLibraryBloc({
    required GetAllCoursesUseCase getAllCoursesUseCase,
    required LoadAllCoursesUseCase loadAllCoursesUseCase,
    required RemoveCourseUseCase removeCourseUseCase,
    required CoursesLibraryDialogs coursesLibraryDialogs,
    required Navigation navigation,
  }) : super(const CoursesLibraryState()) {
    _getAllCoursesUseCase = getAllCoursesUseCase;
    _loadAllCoursesUseCase = loadAllCoursesUseCase;
    _removeCourseUseCase = removeCourseUseCase;
    _coursesLibraryDialogs = coursesLibraryDialogs;
    _navigation = navigation;
    on<CoursesLibraryEventInitialize>(_initialize);
    on<CoursesLibraryEventEditCourse>(_editCourse);
    on<CoursesLibraryEventRemoveCourse>(_removeCourse);
    on<CoursesLibraryEventCoursesUpdated>(_coursesUpdated);
  }

  @override
  Future<void> close() {
    _coursesListener?.cancel();
    return super.close();
  }

  Future<void> _initialize(
    CoursesLibraryEventInitialize event,
    Emitter<CoursesLibraryState> emit,
  ) async {
    emit(state.copyWith(
      status: const BlocStatusLoading(),
    ));
    _setCoursesListener();
    await _loadAllCoursesUseCase.execute();
    emit(state.copyWith(
      status: const BlocStatusComplete(),
    ));
  }

  void _editCourse(
    CoursesLibraryEventEditCourse event,
    Emitter<CoursesLibraryState> emit,
  ) {
    _navigation.navigateToCourseCreator(
      CourseCreatorEditMode(course: event.course),
    );
  }

  Future<void> _removeCourse(
    CoursesLibraryEventRemoveCourse event,
    Emitter<CoursesLibraryState> emit,
  ) async {
    final bool confirmation =
        await _coursesLibraryDialogs.askForDeleteConfirmation();
    if (confirmation == true) {
      emit(state.copyWith(
        status: const BlocStatusLoading(),
      ));
      await _removeCourseUseCase.execute(courseId: event.courseId);
      emit(state.copyWith(
        status: const BlocStatusComplete(
          info: CoursesLibraryInfoType.courseHasBeenRemoved,
        ),
      ));
    }
  }

  void _coursesUpdated(
    CoursesLibraryEventCoursesUpdated event,
    Emitter<CoursesLibraryState> emit,
  ) {
    emit(state.copyWith(
      courses: event.updatedCourses,
    ));
  }

  void _setCoursesListener() {
    _coursesListener = _getAllCoursesUseCase.execute().listen((courses) {
      add(CoursesLibraryEventCoursesUpdated(updatedCourses: courses));
    });
  }
}

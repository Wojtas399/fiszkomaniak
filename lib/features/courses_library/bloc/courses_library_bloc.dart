import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/course.dart';
import '../../../domain/use_cases/courses/get_all_courses_use_case.dart';
import '../../../domain/use_cases/courses/load_all_courses_use_case.dart';
import '../../../domain/use_cases/courses/delete_course_use_case.dart';
import '../../../features/courses_library/courses_library_dialogs.dart';
import '../../../models/bloc_status.dart';

part 'courses_library_event.dart';

part 'courses_library_state.dart';

class CoursesLibraryBloc
    extends Bloc<CoursesLibraryEvent, CoursesLibraryState> {
  late final GetAllCoursesUseCase _getAllCoursesUseCase;
  late final LoadAllCoursesUseCase _loadAllCoursesUseCase;
  late final DeleteCourseUseCase _deleteCourseUseCase;
  late final CoursesLibraryDialogs _coursesLibraryDialogs;
  StreamSubscription<List<Course>>? _allCoursesListener;

  CoursesLibraryBloc({
    required GetAllCoursesUseCase getAllCoursesUseCase,
    required LoadAllCoursesUseCase loadAllCoursesUseCase,
    required DeleteCourseUseCase deleteCourseUseCase,
    required CoursesLibraryDialogs coursesLibraryDialogs,
    BlocStatus status = const BlocStatusInitial(),
    List<Course> allCourses = const [],
  }) : super(
          CoursesLibraryState(
            status: status,
            allCourses: allCourses,
          ),
        ) {
    _getAllCoursesUseCase = getAllCoursesUseCase;
    _loadAllCoursesUseCase = loadAllCoursesUseCase;
    _deleteCourseUseCase = deleteCourseUseCase;
    _coursesLibraryDialogs = coursesLibraryDialogs;
    on<CoursesLibraryEventInitialize>(_initialize);
    on<CoursesLibraryEventAllCoursesUpdated>(_allCoursesUpdated);
    on<CoursesLibraryEventDeleteCourse>(_deleteCourse);
  }

  @override
  Future<void> close() {
    _allCoursesListener?.cancel();
    return super.close();
  }

  Future<void> _initialize(
    CoursesLibraryEventInitialize event,
    Emitter<CoursesLibraryState> emit,
  ) async {
    emit(state.copyWith(
      status: const BlocStatusLoading(),
    ));
    await _loadAllCoursesUseCase.execute();
    emit(state.copyWith(
      status: const BlocStatusComplete(),
    ));
    _setAllCoursesListener();
  }

  void _allCoursesUpdated(
    CoursesLibraryEventAllCoursesUpdated event,
    Emitter<CoursesLibraryState> emit,
  ) {
    emit(state.copyWith(
      allCourses: event.allCourses,
    ));
  }

  Future<void> _deleteCourse(
    CoursesLibraryEventDeleteCourse event,
    Emitter<CoursesLibraryState> emit,
  ) async {
    final bool confirmation =
        await _coursesLibraryDialogs.askForDeleteConfirmation();
    if (confirmation == true) {
      emit(state.copyWith(
        status: const BlocStatusLoading(),
      ));
      await _deleteCourseUseCase.execute(courseId: event.courseId);
      emit(state.copyWith(
        status: const BlocStatusComplete<CoursesLibraryInfoType>(
          info: CoursesLibraryInfoType.courseHasBeenRemoved,
        ),
      ));
    }
  }

  void _setAllCoursesListener() {
    _allCoursesListener ??= _getAllCoursesUseCase.execute().listen(
          (List<Course> allCourses) => add(
            CoursesLibraryEventAllCoursesUpdated(allCourses: allCourses),
          ),
        );
  }
}

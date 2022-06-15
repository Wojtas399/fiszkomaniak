import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:fiszkomaniak/features/courses_library/bloc/courses_library_dialogs.dart';
import 'package:fiszkomaniak/interfaces/courses_interface.dart';
import 'package:fiszkomaniak/models/course_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../config/navigation.dart';
import '../../course_creator/course_creator_mode.dart';

part 'courses_library_event.dart';

part 'courses_library_state.dart';

class CoursesLibraryBloc
    extends Bloc<CoursesLibraryEvent, CoursesLibraryState> {
  late final CoursesInterface _coursesInterface;
  late final CoursesLibraryDialogs _coursesLibraryDialogs;
  late final Navigation _navigation;
  StreamSubscription<List<Course>>? _coursesListener;

  CoursesLibraryBloc({
    required CoursesInterface coursesInterface,
    required CoursesLibraryDialogs coursesLibraryDialogs,
    required Navigation navigation,
  }) : super(const CoursesLibraryState()) {
    _coursesInterface = coursesInterface;
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
    _setCoursesListener();
    await _coursesInterface.loadAllCourses();
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
      await _coursesInterface.removeCourse(courseId: event.courseId);
    }
  }

  void _coursesUpdated(
    CoursesLibraryEventCoursesUpdated event,
    Emitter<CoursesLibraryState> emit,
  ) {
    emit(CoursesLibraryState(
      courses: event.updatedCourses,
    ));
  }

  void _setCoursesListener() {
    _coursesListener = _coursesInterface.allCourses$.listen((courses) {
      add(CoursesLibraryEventCoursesUpdated(updatedCourses: courses));
    });
  }
}

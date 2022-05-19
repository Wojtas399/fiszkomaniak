import 'dart:async';
import 'package:fiszkomaniak/core/courses/courses_bloc.dart';
import 'package:fiszkomaniak/core/courses/courses_event.dart';
import 'package:fiszkomaniak/core/groups/groups_bloc.dart';
import 'package:fiszkomaniak/features/courses_library/bloc/courses_library_dialogs.dart';
import 'package:fiszkomaniak/features/courses_library/bloc/courses_library_event.dart';
import 'package:fiszkomaniak/features/courses_library/bloc/courses_library_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../config/navigation.dart';
import '../../course_creator/course_creator_mode.dart';

class CoursesLibraryBloc
    extends Bloc<CoursesLibraryEvent, CoursesLibraryState> {
  late final CoursesBloc _coursesBloc;
  late final GroupsBloc _groupsBloc;
  late final CoursesLibraryDialogs _coursesLibraryDialogs;
  late final Navigation _navigation;
  StreamSubscription? _coursesStateSubscription;

  CoursesLibraryBloc({
    required CoursesBloc coursesBloc,
    required GroupsBloc groupsBloc,
    required CoursesLibraryDialogs coursesLibraryDialogs,
    required Navigation navigation,
  }) : super(const CoursesLibraryState()) {
    _coursesBloc = coursesBloc;
    _groupsBloc = groupsBloc;
    _coursesLibraryDialogs = coursesLibraryDialogs;
    _navigation = navigation;
    on<CoursesLibraryEventInitialize>(_initialize);
    on<CoursesLibraryEventEditCourse>(_editCourse);
    on<CoursesLibraryEventRemoveCourse>(_removeCourse);
    on<CoursesLibraryEventCoursesStateUpdated>(_coursesStateUpdated);
  }

  void _initialize(
    CoursesLibraryEventInitialize event,
    Emitter<CoursesLibraryState> emit,
  ) {
    emit(CoursesLibraryState(courses: _coursesBloc.state.allCourses));
    _setCoursesStateListener();
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
      final List<String> idsOfGroupsFromCourse =
          _groupsBloc.state.getGroupsIdsByCourseId(event.courseId);
      _coursesBloc.add(CoursesEventRemoveCourse(
        courseId: event.courseId,
        idsOfGroupsFromCourse: idsOfGroupsFromCourse,
      ));
    }
  }

  void _coursesStateUpdated(
    CoursesLibraryEventCoursesStateUpdated event,
    Emitter<CoursesLibraryState> emit,
  ) {
    emit(CoursesLibraryState(courses: _coursesBloc.state.allCourses));
  }

  void _setCoursesStateListener() {
    _coursesStateSubscription = _coursesBloc.stream.listen((_) {
      add(CoursesLibraryEventCoursesStateUpdated());
    });
  }

  @override
  Future<void> close() {
    _coursesStateSubscription?.cancel();
    return super.close();
  }
}

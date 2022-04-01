import 'dart:async';
import 'package:fiszkomaniak/components/dialogs/dialogs.dart';
import 'package:fiszkomaniak/core/courses/courses_bloc.dart';
import 'package:fiszkomaniak/core/courses/courses_event.dart';
import 'package:fiszkomaniak/core/groups/groups_bloc.dart';
import 'package:fiszkomaniak/core/groups/groups_event.dart';
import 'package:fiszkomaniak/features/courses_library/bloc/courses_library_event.dart';
import 'package:fiszkomaniak/features/courses_library/bloc/courses_library_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../config/navigation.dart';
import '../../course_creator/course_creator_mode.dart';

class CoursesLibraryBloc
    extends Bloc<CoursesLibraryEvent, CoursesLibraryState> {
  late final CoursesBloc _coursesBloc;
  late final GroupsBloc _groupsBloc;
  late final Dialogs _dialogs;
  StreamSubscription? _coursesStateSubscription;

  CoursesLibraryBloc({
    required CoursesBloc coursesBloc,
    required GroupsBloc groupsBloc,
    required Dialogs dialogs,
  }) : super(const CoursesLibraryState()) {
    _coursesBloc = coursesBloc;
    _groupsBloc = groupsBloc;
    _dialogs = dialogs;
    on<CoursesLibraryEventInitialize>(_initialize);
    on<CoursesLibraryEventUpdateCourses>(_updateCourses);
    on<CoursesLibraryEventEditCourse>(_editCourse);
    on<CoursesLibraryEventRemoveCourse>(_removeCourse);
  }

  void _initialize(
    CoursesLibraryEventInitialize event,
    Emitter<CoursesLibraryState> emit,
  ) {
    add(CoursesLibraryEventUpdateCourses());
    _coursesStateSubscription = _coursesBloc.stream.listen((state) {
      add(CoursesLibraryEventUpdateCourses());
    });
  }

  void _updateCourses(
    CoursesLibraryEventUpdateCourses event,
    Emitter<CoursesLibraryState> emit,
  ) {
    emit(CoursesLibraryState(courses: _coursesBloc.state.allCourses));
  }

  void _editCourse(
    CoursesLibraryEventEditCourse event,
    Emitter<CoursesLibraryState> emit,
  ) {
    Navigation.navigateToCourseCreator(
      CourseCreatorEditMode(course: event.course),
    );
  }

  Future<void> _removeCourse(
    CoursesLibraryEventRemoveCourse event,
    Emitter<CoursesLibraryState> emit,
  ) async {
    final bool? confirmation = await _dialogs.askForConfirmation(
      title: 'Czy na pewno chcesz usunąć ten kurs?',
      text:
          'Usunięcie kursu spowoduje również usunięcie wszystkich grup oraz fiszek należących do tego kursu.',
      confirmButtonText: 'Usuń',
    );
    if (confirmation == true) {
      _coursesBloc.add(CoursesEventRemoveCourse(courseId: event.courseId));
      _groupsBloc.add(
        GroupsEventRemoveGroupsFromCourse(courseId: event.courseId),
      );
    }
  }

  @override
  Future<void> close() {
    _coursesStateSubscription?.cancel();
    return super.close();
  }
}

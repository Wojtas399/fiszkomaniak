import 'dart:async';
import 'package:fiszkomaniak/core/courses/courses_bloc.dart';
import 'package:fiszkomaniak/core/courses/courses_event.dart';
import 'package:fiszkomaniak/core/flashcards/flashcards_bloc.dart';
import 'package:fiszkomaniak/core/flashcards/flashcards_event.dart';
import 'package:fiszkomaniak/core/groups/groups_bloc.dart';
import 'package:fiszkomaniak/core/groups/groups_event.dart';
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
  late final FlashcardsBloc _flashcardsBloc;
  late final CoursesLibraryDialogs _coursesLibraryDialogs;
  StreamSubscription? _coursesStateSubscription;

  CoursesLibraryBloc({
    required CoursesBloc coursesBloc,
    required GroupsBloc groupsBloc,
    required FlashcardsBloc flashcardsBloc,
    required CoursesLibraryDialogs coursesLibraryDialogs,
  }) : super(const CoursesLibraryState()) {
    _coursesBloc = coursesBloc;
    _groupsBloc = groupsBloc;
    _flashcardsBloc = flashcardsBloc;
    _coursesLibraryDialogs = coursesLibraryDialogs;
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
    Navigation.navigateToCourseCreator(
      CourseCreatorEditMode(course: event.course),
    );
  }

  Future<void> _removeCourse(
    CoursesLibraryEventRemoveCourse event,
    Emitter<CoursesLibraryState> emit,
  ) async {
    final bool? confirmation =
        await _coursesLibraryDialogs.askForDeleteConfirmation();
    if (confirmation == true) {
      final List<String> idsOfGroupsFromCourse =
          _groupsBloc.state.getGroupsIdsByCourseId(event.courseId);
      _coursesBloc.add(CoursesEventRemoveCourse(courseId: event.courseId));
      _groupsBloc.add(
        GroupsEventRemoveGroupsFromCourse(courseId: event.courseId),
      );
      _flashcardsBloc.add(FlashcardsEventRemoveFlashcardsFromGroups(
        groupsIds: idsOfGroupsFromCourse,
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

import 'dart:async';
import 'package:fiszkomaniak/core/courses/courses_event.dart';
import 'package:fiszkomaniak/core/courses/courses_state.dart';
import 'package:fiszkomaniak/core/courses/courses_status.dart';
import 'package:fiszkomaniak/interfaces/courses_interface.dart';
import 'package:fiszkomaniak/interfaces/flashcards_interface.dart';
import 'package:fiszkomaniak/interfaces/groups_interface.dart';
import 'package:fiszkomaniak/models/course_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/changed_document.dart';

class CoursesBloc extends Bloc<CoursesEvent, CoursesState> {
  late final CoursesInterface _coursesInterface;
  late final GroupsInterface _groupsInterface;
  late final FlashcardsInterface _flashcardsInterface;
  StreamSubscription<List<ChangedDocument<Course>>>? _coursesSubscription;

  CoursesBloc({
    required CoursesInterface coursesInterface,
    required GroupsInterface groupsInterface,
    required FlashcardsInterface flashcardsInterface,
  }) : super(CoursesState()) {
    _coursesInterface = coursesInterface;
    _groupsInterface = groupsInterface;
    _flashcardsInterface = flashcardsInterface;
    on<CoursesEventInitialize>(_initialize);
    on<CoursesEventAddNewCourse>(_addNewCourse);
    on<CoursesEventUpdateCourseName>(_updateCourseName);
    on<CoursesEventRemoveCourse>(_removeCourse);
    on<CoursesEventCourseAdded>(_onCourseAdded);
    on<CoursesEventCourseModified>(_onCourseModified);
    on<CoursesEventCourseRemoved>(_onCourseRemoved);
  }

  void _initialize(CoursesEventInitialize event, Emitter<CoursesState> emit) {
    _coursesSubscription = _coursesInterface.getCoursesSnapshots().listen(
      (courses) {
        for (final course in courses) {
          switch (course.changeType) {
            case DbDocChangeType.added:
              add(CoursesEventCourseAdded(course: course.doc));
              break;
            case DbDocChangeType.updated:
              add(CoursesEventCourseModified(course: course.doc));
              break;
            case DbDocChangeType.removed:
              add(CoursesEventCourseRemoved(courseId: course.doc.id));
              break;
          }
        }
      },
    );
  }

  Future<void> _addNewCourse(
    CoursesEventAddNewCourse event,
    Emitter<CoursesState> emit,
  ) async {
    try {
      emit(state.copyWith(status: CoursesStatusLoading()));
      await _coursesInterface.addNewCourse(event.name);
      emit(state.copyWith(status: CoursesStatusCourseAdded()));
    } catch (error) {
      emit(
        state.copyWith(status: CoursesStatusError(message: error.toString())),
      );
    }
  }

  Future<void> _updateCourseName(
    CoursesEventUpdateCourseName event,
    Emitter<CoursesState> emit,
  ) async {
    try {
      emit(state.copyWith(status: CoursesStatusLoading()));
      await _coursesInterface.updateCourseName(
        courseId: event.courseId,
        newCourseName: event.newCourseName,
      );
      emit(state.copyWith(status: CoursesStatusCourseUpdated()));
    } catch (error) {
      emit(
        state.copyWith(status: CoursesStatusError(message: error.toString())),
      );
    }
  }

  Future<void> _removeCourse(
    CoursesEventRemoveCourse event,
    Emitter<CoursesState> emit,
  ) async {
    try {
      emit(state.copyWith(status: CoursesStatusLoading()));
      await _flashcardsInterface.removeFlashcardsByGroupsIds(
        event.idsOfGroupsFromCourse,
      );
      await _groupsInterface.removeGroupsFromCourse(event.courseId);
      await _coursesInterface.removeCourse(event.courseId);
      emit(state.copyWith(status: CoursesStatusCourseRemoved()));
    } catch (error) {
      emit(
        state.copyWith(status: CoursesStatusError(message: error.toString())),
      );
    }
  }

  void _onCourseAdded(
    CoursesEventCourseAdded event,
    Emitter<CoursesState> emit,
  ) {
    emit(state.copyWith(allCourses: [
      ...state.allCourses,
      event.course,
    ]));
  }

  void _onCourseModified(
    CoursesEventCourseModified event,
    Emitter<CoursesState> emit,
  ) {
    List<Course> allCourses = [...state.allCourses];
    final modifiedCourseIndex = allCourses.indexWhere(
      (course) => course.id == event.course.id,
    );
    allCourses[modifiedCourseIndex] = event.course;
    emit(state.copyWith(allCourses: allCourses));
  }

  void _onCourseRemoved(
    CoursesEventCourseRemoved event,
    Emitter<CoursesState> emit,
  ) {
    List<Course> allCourses = [...state.allCourses];
    allCourses.removeWhere((course) => course.id == event.courseId);
    emit(state.copyWith(allCourses: allCourses));
  }

  @override
  Future<void> close() {
    _coursesSubscription?.cancel();
    return super.close();
  }
}

import 'dart:async';
import 'package:fiszkomaniak/core/courses/courses_event.dart';
import 'package:fiszkomaniak/core/courses/courses_state.dart';
import 'package:fiszkomaniak/interfaces/courses_interface.dart';
import 'package:fiszkomaniak/models/course_model.dart';
import 'package:fiszkomaniak/models/http_status_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/changed_document.dart';

class CoursesBloc extends Bloc<CoursesEvent, CoursesState> {
  late final CoursesInterface _coursesInterface;
  StreamSubscription<List<ChangedDocument<Course>>>? _coursesSubscription;

  CoursesBloc({required CoursesInterface coursesInterface})
      : super(const CoursesState()) {
    _coursesInterface = coursesInterface;
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
            case TypeOfDocumentChange.added:
              add(CoursesEventCourseAdded(course: course.doc));
              break;
            case TypeOfDocumentChange.updated:
              add(CoursesEventCourseModified(course: course.doc));
              break;
            case TypeOfDocumentChange.removed:
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
      emit(state.copyWith(httpStatus: HttpStatusSubmitting()));
      await _coursesInterface.addNewCourse(event.name);
      emit(state.copyWith(
        httpStatus: const HttpStatusSuccess(
          message: 'Pomyślnie dodano nowy kurs.',
        ),
      ));
    } catch (error) {
      emit(
        state.copyWith(
          httpStatus: HttpStatusFailure(message: error.toString()),
        ),
      );
    }
  }

  Future<void> _updateCourseName(
    CoursesEventUpdateCourseName event,
    Emitter<CoursesState> emit,
  ) async {
    try {
      emit(state.copyWith(httpStatus: HttpStatusSubmitting()));
      await _coursesInterface.updateCourseName(
        courseId: event.courseId,
        newCourseName: event.newCourseName,
      );
      emit(state.copyWith(
        httpStatus: const HttpStatusSuccess(
          message: 'Pomyślnie zmieniono nazwę kursu.',
        ),
      ));
    } catch (error) {
      emit(
        state.copyWith(
          httpStatus: HttpStatusFailure(message: error.toString()),
        ),
      );
    }
  }

  Future<void> _removeCourse(
    CoursesEventRemoveCourse event,
    Emitter<CoursesState> emit,
  ) async {
    try {
      emit(state.copyWith(httpStatus: HttpStatusSubmitting()));
      await _coursesInterface.removeCourse(event.courseId);
      emit(state.copyWith(
        httpStatus: const HttpStatusSuccess(
          message: 'Pomyślnie usunięto kurs.',
        ),
      ));
    } catch (error) {
      emit(
        state.copyWith(
          httpStatus: HttpStatusFailure(message: error.toString()),
        ),
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

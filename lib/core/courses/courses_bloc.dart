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
    on<CoursesEventAddNewCourse>(_add);
    on<CoursesEventCourseAdded>(_onCourseAdded);
    on<CoursesEventCourseModified>(_onCourseModified);
    on<CoursesEventCourseRemoved>(_onCourseRemoved);
  }

  void _initialize(CoursesEventInitialize event, Emitter<CoursesState> emit) {
    _coursesSubscription = _coursesInterface.getCoursesSnapshots().listen(
      (courses) {
        for (final course in courses) {
          if (course.changeType == TypeOfDocumentChange.added) {
            print('Document added: ${course.doc.name}');
            add(CoursesEventCourseAdded(course: course.doc));
          } else if (course.changeType == TypeOfDocumentChange.modified) {
            print('Document modified');
            add(CoursesEventCourseModified(course: course.doc));
          } else if (course.changeType == TypeOfDocumentChange.removed) {
            print('Document removed');
            add(CoursesEventCourseRemoved(courseId: course.doc.id));
          }
        }
      },
    );
  }

  Future<void> _add(
    CoursesEventAddNewCourse event,
    Emitter<CoursesState> emit,
  ) async {
    try {
      emit(state.copyWith(httpStatus: HttpStatusSubmitting()));
      await _coursesInterface.addNewCourse(event.name);
      emit(state.copyWith(httpStatus: HttpStatusSuccess()));
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
    //TODO
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

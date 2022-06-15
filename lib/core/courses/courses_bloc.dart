// import 'dart:async';
// import 'package:equatable/equatable.dart';
// import 'package:fiszkomaniak/interfaces/courses_interface.dart';
// import 'package:fiszkomaniak/models/course_model.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import '../../models/changed_document.dart';
// import '../initialization_status.dart';
//
// part 'courses_event.dart';
//
// part 'courses_state.dart';
//
// part 'courses_status.dart';
//
// class CoursesBloc extends Bloc<CoursesEvent, CoursesState> {
//   late final CoursesInterface _coursesInterface;
//   StreamSubscription<List<ChangedDocument<Course>>>? _coursesSubscription;
//
//   CoursesBloc({
//     required CoursesInterface coursesInterface,
//   }) : super(CoursesState()) {
//     _coursesInterface = coursesInterface;
//     on<CoursesEventInitialize>(_initialize);
//     on<CoursesEventCoursesChanged>(_coursesChanged);
//     on<CoursesEventAddNewCourse>(_addNewCourse);
//     on<CoursesEventUpdateCourseName>(_updateCourseName);
//     on<CoursesEventRemoveCourse>(_removeCourse);
//   }
//
//   @override
//   Future<void> close() {
//     _coursesSubscription?.cancel();
//     return super.close();
//   }
//
//   void _initialize(CoursesEventInitialize event, Emitter<CoursesState> emit) {
//     //TODO
//   }
//
//   void _coursesChanged(
//     CoursesEventCoursesChanged event,
//     Emitter<CoursesState> emit,
//   ) {
//     final List<Course> newCourses = [...state.allCourses];
//     newCourses.addAll(event.addedCourses);
//     for (final updatedCourse in event.updatedCourses) {
//       final int index = newCourses.indexWhere(
//         (course) => course.id == updatedCourse.id,
//       );
//       newCourses[index] = updatedCourse;
//     }
//     for (final deletedCourse in event.deletedCourses) {
//       newCourses.removeWhere((course) => course.id == deletedCourse.id);
//     }
//     emit(state.copyWith(
//       allCourses: newCourses,
//       initializationStatus: InitializationStatus.ready,
//     ));
//   }
//
//   Future<void> _addNewCourse(
//     CoursesEventAddNewCourse event,
//     Emitter<CoursesState> emit,
//   ) async {
//     try {
//       emit(state.copyWith(status: CoursesStatusLoading()));
//       await _coursesInterface.addNewCourse(event.name);
//       emit(state.copyWith(status: CoursesStatusCourseAdded()));
//     } catch (error) {
//       emit(
//         state.copyWith(status: CoursesStatusError(message: error.toString())),
//       );
//     }
//   }
//
//   Future<void> _updateCourseName(
//     CoursesEventUpdateCourseName event,
//     Emitter<CoursesState> emit,
//   ) async {
//     try {
//       emit(state.copyWith(status: CoursesStatusLoading()));
//       await _coursesInterface.updateCourseName(
//         courseId: event.courseId,
//         newCourseName: event.newCourseName,
//       );
//       emit(state.copyWith(status: CoursesStatusCourseUpdated()));
//     } catch (error) {
//       emit(
//         state.copyWith(status: CoursesStatusError(message: error.toString())),
//       );
//     }
//   }
//
//   Future<void> _removeCourse(
//     CoursesEventRemoveCourse event,
//     Emitter<CoursesState> emit,
//   ) async {
//     try {
//       emit(state.copyWith(status: CoursesStatusLoading()));
//       await _coursesInterface.removeCourse(event.courseId);
//       emit(state.copyWith(status: CoursesStatusCourseRemoved()));
//     } catch (error) {
//       emit(
//         state.copyWith(status: CoursesStatusError(message: error.toString())),
//       );
//     }
//   }
// }

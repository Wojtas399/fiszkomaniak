import 'package:fiszkomaniak/domain/entities/course.dart';
import 'package:fiszkomaniak/features/courses_library/bloc/courses_library_bloc.dart';
import 'package:fiszkomaniak/models/bloc_status.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late CoursesLibraryState state;

  setUp(() {
    state = const CoursesLibraryState();
  });

  test('initial state', () {
    expect(state.status, const BlocStatusInitial());
    expect(state.courses, []);
  });

  test('copy with status', () {
    const expectedStatus = BlocStatusLoading();

    final state2 = state.copyWith(status: expectedStatus);
    final state3 = state2.copyWith();

    expect(state2.status, expectedStatus);
    expect(state3.status, const BlocStatusComplete());
  });

  test('copy with courses', () {
    final expectedCourses = [
      createCourse(id: 'c1'),
      createCourse(id: 'c2'),
    ];

    final state2 = state.copyWith(courses: expectedCourses);
    final state3 = state2.copyWith();

    expect(state2.courses, expectedCourses);
    expect(state3.courses, expectedCourses);
  });
}

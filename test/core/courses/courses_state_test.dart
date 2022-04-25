import 'package:fiszkomaniak/core/courses/courses_state.dart';
import 'package:fiszkomaniak/core/courses/courses_status.dart';
import 'package:fiszkomaniak/models/course_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late CoursesState state;
  final List<Course> allCourses = [
    createCourse(id: 'c3', name: 'course3'),
    createCourse(id: 'c1', name: 'course1'),
    createCourse(id: 'c2', name: 'course2')
  ];

  setUp(() {
    state = CoursesState(allCourses: allCourses);
  });

  test('initial state', () {
    final CoursesState initialState = CoursesState();
    expect(initialState.allCourses, const []);
    expect(initialState.status, const CoursesStatusInitial());
  });

  test('copy with all courses', () {
    final List<Course> sortedCourses = [...allCourses];
    sortedCourses.sort(
      (course1, course2) => course1.name.compareTo(course2.name),
    );

    final CoursesState state2 = state.copyWith();

    expect(state.allCourses, sortedCourses);
    expect(state2.allCourses, sortedCourses);
  });

  test('copy with status', () {
    final CoursesState state2 = state.copyWith(status: CoursesStatusLoading());
    final CoursesState state3 = state2.copyWith();

    expect(state2.status, CoursesStatusLoading());
    expect(state3.status, const CoursesStatusLoaded());
  });

  test('get course by id, course exists', () {
    final Course? course = state.getCourseById('c1');

    expect(course, allCourses[1]);
  });

  test('get course by id, course does not exist', () {
    final Course? course = state.getCourseById('c4');

    expect(course, null);
  });

  test('get course name by id, course exists', () {
    final String? name = state.getCourseNameById('c1');

    expect(name, 'course1');
  });

  test('get course name by id, course does not exist', () {
    final String? name = state.getCourseNameById('c4');

    expect(name, null);
  });

  test('is there course with the same name, true', () {
    final bool answer = state.isThereCourseWithTheSameName('course1');

    expect(answer, true);
  });

  test('is there course with the same name, false', () {
    final bool answer = state.isThereCourseWithTheSameName('course4');

    expect(answer, false);
  });
}

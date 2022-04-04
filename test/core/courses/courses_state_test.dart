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
    state = CoursesState();
  });

  test('initial state', () {
    expect(state.allCourses, const []);
    expect(state.status, const CoursesStatusInitial());
  });

  test('copy with all courses', () {
    final List<Course> sortedCourses = [...allCourses];
    sortedCourses.sort(
      (course1, course2) => course1.name.compareTo(course2.name),
    );

    final CoursesState state2 = state.copyWith(allCourses: allCourses);
    final CoursesState state3 = state2.copyWith();

    expect(state2.allCourses, sortedCourses);
    expect(state3.allCourses, sortedCourses);
  });

  test('copy with status', () {
    final CoursesState state2 = state.copyWith(status: CoursesStatusLoading());
    final CoursesState state3 = state2.copyWith();

    expect(state2.status, CoursesStatusLoading());
    expect(state3.status, const CoursesStatusLoaded());
  });

  test('get course by id, course exists', () {
    final CoursesState updatedState = state.copyWith(allCourses: allCourses);

    final Course? course = updatedState.getCourseById('c1');

    expect(course, allCourses[1]);
  });

  test('get course by id, course does not exist', () {
    final CoursesState updatedState = state.copyWith(allCourses: allCourses);

    final Course? course = updatedState.getCourseById('c4');

    expect(course, null);
  });

  test('get course name by id, course exists', () {
    final CoursesState updatedState = state.copyWith(allCourses: allCourses);

    final String? name = updatedState.getCourseNameById('c1');

    expect(name, 'course1');
  });

  test('get course name by id, course does not exist', () {
    final CoursesState updatedState = state.copyWith(allCourses: allCourses);

    final String? name = updatedState.getCourseNameById('c4');

    expect(name, null);
  });
}

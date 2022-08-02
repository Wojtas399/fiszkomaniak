import 'package:fiszkomaniak/components/course_item.dart';
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
    expect(state.coursesItemsParams, []);
  });

  test('copy with status', () {
    const expectedStatus = BlocStatusLoading();

    final state2 = state.copyWith(status: expectedStatus);
    final state3 = state2.copyWith();

    expect(state2.status, expectedStatus);
    expect(state3.status, const BlocStatusComplete());
  });

  test('copy with courses items params', () {
    final expectedCoursesItemsParams = [
      createCourseItemParams(
        title: 'course 1',
        amountOfGroups: 2,
      ),
      createCourseItemParams(
        title: 'course 2',
        amountOfGroups: 4,
      ),
    ];

    final state2 = state.copyWith(
      coursesItemsParams: expectedCoursesItemsParams,
    );
    final state3 = state2.copyWith();

    expect(state2.coursesItemsParams, expectedCoursesItemsParams);
    expect(state3.coursesItemsParams, expectedCoursesItemsParams);
  });
}

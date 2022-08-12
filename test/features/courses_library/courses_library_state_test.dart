import 'package:flutter_test/flutter_test.dart';
import 'package:fiszkomaniak/domain/entities/course.dart';
import 'package:fiszkomaniak/features/courses_library/bloc/courses_library_bloc.dart';
import 'package:fiszkomaniak/models/bloc_status.dart';

void main() {
  late CoursesLibraryState state;

  setUp(() {
    state = const CoursesLibraryState(
      status: BlocStatusInitial(),
      allCourses: [],
    );
  });

  test(
    'all courses, should be true if there is at least one course',
    () {
      state = state.copyWith(
        allCourses: [
          createCourse(id: 'c1'),
        ],
      );

      expect(state.areCourses, true);
    },
  );

  test(
    'all courses, should be false if there are no courses',
    () {
      expect(state.areCourses, false);
    },
  );

  test(
    'copy with status',
    () {
      const BlocStatus expectedStatus = BlocStatusLoading();

      state = state.copyWith(status: expectedStatus);
      final state2 = state.copyWith();

      expect(state.status, expectedStatus);
      expect(state2.status, const BlocStatusInProgress());
    },
  );

  test(
    'copy with all courses',
    () {
      final List<Course> expectedCourses = [
        createCourse(id: 'c1'),
        createCourse(id: 'c2'),
      ];

      state = state.copyWith(allCourses: expectedCourses);
      final state2 = state.copyWith();

      expect(state.allCourses, expectedCourses);
      expect(state2.allCourses, expectedCourses);
    },
  );

  test(
    'copy with info',
    () {
      const CoursesLibraryInfo expectedInfo =
          CoursesLibraryInfo.courseHasBeenRemoved;

      state = state.copyWithInfo(expectedInfo);

      expect(
        state.status,
        const BlocStatusComplete<CoursesLibraryInfo>(info: expectedInfo),
      );
    },
  );
}

import 'package:flutter_test/flutter_test.dart';
import 'package:fiszkomaniak/domain/entities/course.dart';
import 'package:fiszkomaniak/features/course_creator/bloc/course_creator_bloc.dart';
import 'package:fiszkomaniak/features/course_creator/bloc/course_creator_mode.dart';
import 'package:fiszkomaniak/models/bloc_status.dart';

void main() {
  late CourseCreatorState state;

  setUp(() {
    state = const CourseCreatorState(
      status: BlocStatusInitial(),
      mode: CourseCreatorCreateMode(),
      courseName: '',
    );
  });

  test(
    'is button disabled, create mode, should be true if course name is empty string',
    () {
      expect(state.isButtonDisabled, true);
    },
  );

  test(
    'is button disabled, edit mode, should be true if course name has not been edited',
    () {
      state = state.copyWith(
        mode: CourseCreatorEditMode(course: createCourse(name: 'course name')),
        courseName: 'course name',
      );

      expect(state.isButtonDisabled, true);
    },
  );

  test(
    'is button disabled, edit mode, should be false if course name has been edited',
    () {
      state = state.copyWith(
        mode: CourseCreatorEditMode(course: createCourse(name: 'course name')),
        courseName: 'course name 123',
      );

      expect(state.isButtonDisabled, false);
    },
  );

  test(
    'is button disabled, edit mode, should be true if course name is empty string',
    () {
      state = state.copyWith(
        mode: CourseCreatorEditMode(course: createCourse(name: 'course name')),
        courseName: '',
      );

      expect(state.isButtonDisabled, true);
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
    'copy with mode',
    () {
      final CourseCreatorMode expectedMode = CourseCreatorEditMode(
        course: createCourse(id: 'c1'),
      );

      state = state.copyWith(mode: expectedMode);
      final state2 = state.copyWith();

      expect(state.mode, expectedMode);
      expect(state2.mode, expectedMode);
    },
  );

  test(
    'copy with course name',
    () {
      const String expectedCourseName = 'course name';

      state = state.copyWith(courseName: expectedCourseName);
      final state2 = state.copyWith();

      expect(state.courseName, expectedCourseName);
      expect(state2.courseName, expectedCourseName);
    },
  );

  test(
    'copy with info',
    () {
      const CourseCreatorInfo expectedInfo =
          CourseCreatorInfo.courseHasBeenAdded;

      state = state.copyWithInfo(expectedInfo);

      expect(
        state.status,
        const BlocStatusComplete<CourseCreatorInfo>(
          info: expectedInfo,
        ),
      );
    },
  );

  test(
    'copy with error',
    () {
      const CourseCreatorError expectedError =
          CourseCreatorError.courseNameIsAlreadyTaken;

      state = state.copyWithError(expectedError);

      expect(
        state.status,
        const BlocStatusError<CourseCreatorError>(
          error: CourseCreatorError.courseNameIsAlreadyTaken,
        ),
      );
    },
  );
}

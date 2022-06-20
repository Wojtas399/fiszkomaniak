import 'package:fiszkomaniak/domain/entities/course.dart';
import 'package:fiszkomaniak/features/course_creator/bloc/course_creator_bloc.dart';
import 'package:fiszkomaniak/features/course_creator/course_creator_mode.dart';
import 'package:fiszkomaniak/models/bloc_status.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late CourseCreatorState state;

  setUp(() {
    state = const CourseCreatorState();
  });

  test(
    'initial state',
    () {
      expect(state.status, const BlocStatusInitial());
      expect(state.mode, const CourseCreatorCreateMode());
      expect(state.courseName, '');
    },
  );

  test(
    'copy with status',
    () {
      const expectedStatus = BlocStatusLoading();

      final state2 = state.copyWith(status: expectedStatus);
      final state3 = state2.copyWith();

      expect(state2.status, expectedStatus);
      expect(state3.status, const BlocStatusComplete());
    },
  );

  test(
    'copy with mode',
    () {
      final expectedMode =
          CourseCreatorEditMode(course: createCourse(id: 'c1'));

      final state2 = state.copyWith(mode: expectedMode);
      final state3 = state2.copyWith();

      expect(state2.mode, expectedMode);
      expect(state3.mode, expectedMode);
    },
  );

  test(
    'copy with course name',
    () {
      const expectedCourseName = 'course name';

      final state2 = state.copyWith(courseName: expectedCourseName);
      final state3 = state2.copyWith();

      expect(state2.courseName, expectedCourseName);
      expect(state3.courseName, expectedCourseName);
    },
  );

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
}

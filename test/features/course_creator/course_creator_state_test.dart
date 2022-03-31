import 'package:fiszkomaniak/features/course_creator/bloc/course_creator_state.dart';
import 'package:fiszkomaniak/features/course_creator/course_creator_mode.dart';
import 'package:fiszkomaniak/models/http_status_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late CourseCreatorState state;

  setUp(() {
    state = const CourseCreatorState();
  });

  test('initial state', () {
    expect(state.mode, const CourseCreatorCreateMode());
    expect(state.courseName, '');
    expect(state.httpStatus, const HttpStatusInitial());
    expect(state.isButtonDisabled, true);
  });

  test('copy with mode', () {
    final CourseCreatorState state1 = state.copyWith(
      mode: const CourseCreatorEditMode(courseId: 'c1', courseName: 'name'),
    );
    final CourseCreatorState state2 = state1.copyWith();

    expect(
      state1.mode,
      const CourseCreatorEditMode(courseId: 'c1', courseName: 'name'),
    );
    expect(
      state2.mode,
      const CourseCreatorEditMode(courseId: 'c1', courseName: 'name'),
    );
  });

  test('copy with course name', () {
    final CourseCreatorState state1 = state.copyWith(courseName: 'cName');
    final CourseCreatorState state2 = state1.copyWith();

    expect(state1.courseName, 'cName');
    expect(state2.courseName, 'cName');
  });

  test('copy with http status', () {
    final CourseCreatorState state1 = state.copyWith(
      httpStatus: const HttpStatusSuccess(),
    );
    final CourseCreatorState state2 = state1.copyWith();

    expect(state1.httpStatus, const HttpStatusSuccess());
    expect(state2.httpStatus, const HttpStatusInitial());
  });

  test('is button disabled, create mode, not empty string', () {
    final CourseCreatorState updatedState = state.copyWith(
      courseName: 'course name',
    );

    expect(updatedState.isButtonDisabled, false);
  });

  test('is button disabled, edit mode, data not edited', () {
    final CourseCreatorState updatedState = state.copyWith(
      mode: const CourseCreatorEditMode(
        courseId: 'c1',
        courseName: 'courseName',
      ),
      courseName: 'courseName',
    );

    expect(updatedState.isButtonDisabled, true);
  });

  test('is button disabled, edit mode, data edited', () {
    final CourseCreatorState state1 = state.copyWith(
      mode: const CourseCreatorEditMode(
        courseId: 'c1',
        courseName: 'courseName',
      ),
      courseName: 'courseName',
    );
    final CourseCreatorState state2 = state1.copyWith(
      courseName: 'course name',
    );

    expect(state2.isButtonDisabled, false);
  });

  test('is button disabled, edit mode, empty string', () {
    final CourseCreatorState state1 = state.copyWith(
      mode: const CourseCreatorEditMode(
        courseId: 'c1',
        courseName: 'courseName',
      ),
      courseName: 'courseName',
    );
    final CourseCreatorState state2 = state1.copyWith(
      courseName: '',
    );

    expect(state2.isButtonDisabled, true);
  });

  test('title, create mode', () {
    expect(state.title, 'Nowy kurs');
  });

  test('title, edit mode', () {
    final CourseCreatorState updatedState = state.copyWith(
      mode: const CourseCreatorEditMode(
        courseId: 'c1',
        courseName: 'courseName',
      ),
    );

    expect(updatedState.title, 'Edycja kursu');
  });

  test('button text, create mode', () {
    expect(state.buttonText, 'utwórz');
  });

  test('button text, edit mode', () {
    final CourseCreatorState updatedState = state.copyWith(
      mode: const CourseCreatorEditMode(
        courseId: 'c1',
        courseName: 'courseName',
      ),
    );

    expect(updatedState.buttonText, 'zapisz');
  });
}

import 'package:fiszkomaniak/features/group_creator/bloc/group_creator_mode.dart';
import 'package:fiszkomaniak/features/group_creator/bloc/group_creator_state.dart';
import 'package:fiszkomaniak/models/course_model.dart';
import 'package:fiszkomaniak/models/group_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late GroupCreatorState state;

  setUp(() {
    state = const GroupCreatorState();
  });

  test('initial state', () {
    expect(state.mode, const GroupCreatorCreateMode());
    expect(state.selectedCourse, null);
    expect(state.allCourses, const []);
    expect(state.groupName, '');
    expect(state.nameForQuestions, '');
    expect(state.nameForAnswers, '');
  });

  test('copy with mode', () {
    final Group group = createGroup(id: 'g1');

    final GroupCreatorState state1 = state.copyWith(
      mode: GroupCreatorEditMode(group: group),
    );
    final GroupCreatorState state2 = state1.copyWith();

    expect(state1.mode, GroupCreatorEditMode(group: group));
    expect(state2.mode, GroupCreatorEditMode(group: group));
  });

  test('copy with selected course', () {
    final Course selectedCourse = createCourse(id: 'c1');

    final GroupCreatorState state1 = state.copyWith(
      selectedCourse: selectedCourse,
    );
    final GroupCreatorState state2 = state1.copyWith();

    expect(state1.selectedCourse, selectedCourse);
    expect(state2.selectedCourse, selectedCourse);
  });

  test('copy with all courses', () {
    final List<Course> allCourses = [
      createCourse(id: 'c1'),
      createCourse(id: 'c2'),
      createCourse(id: 'c3'),
    ];

    final GroupCreatorState state1 = state.copyWith(allCourses: allCourses);
    final GroupCreatorState state2 = state1.copyWith();

    expect(state1.allCourses, allCourses);
    expect(state2.allCourses, allCourses);
  });

  test('copy with group name', () {
    const String groupName = 'groupName';

    final GroupCreatorState state1 = state.copyWith(groupName: groupName);
    final GroupCreatorState state2 = state1.copyWith();

    expect(state1.groupName, groupName);
    expect(state2.groupName, groupName);
  });

  test('copy with name for questions', () {
    const String nameForQuestions = 'nameForQuestions';

    final GroupCreatorState state1 = state.copyWith(
      nameForQuestions: nameForQuestions,
    );
    final GroupCreatorState state2 = state1.copyWith();

    expect(state1.nameForQuestions, nameForQuestions);
    expect(state2.nameForQuestions, nameForQuestions);
  });

  test('copy with name for answers', () {
    const String nameForAnswers = 'nameForAnswers';

    final GroupCreatorState state1 = state.copyWith(
      nameForAnswers: nameForAnswers,
    );
    final GroupCreatorState state2 = state1.copyWith();

    expect(state1.nameForAnswers, nameForAnswers);
    expect(state2.nameForAnswers, nameForAnswers);
  });

  test('mode title, create mode', () {
    expect(state.modeTitle, 'Nowa grupa');
  });

  test('mode title, edit mode', () {
    final GroupCreatorState updatedState = state.copyWith(
      mode: GroupCreatorEditMode(group: createGroup()),
    );

    expect(updatedState.modeTitle, 'Edycja grupy');
  });

  test('mode button text, create mode', () {
    expect(state.modeButtonText, 'utwórz');
  });

  test('mode button text, edit mode', () {
    final GroupCreatorState updatedState = state.copyWith(
      mode: GroupCreatorEditMode(group: createGroup()),
    );

    expect(updatedState.modeButtonText, 'zapisz');
  });

  test('is button disabled, create mode, not all data entered', () {
    final GroupCreatorState updatedState = state.copyWith(
      groupName: 'groupName',
      nameForAnswers: 'nameForAnswers',
    );

    expect(updatedState.isButtonDisabled, true);
  });

  test('is button disabled, create mode, all data entered', () {
    final GroupCreatorState updatedState = state.copyWith(
      selectedCourse: createCourse(),
      groupName: 'groupName',
      nameForQuestions: 'nameForQuestions',
      nameForAnswers: 'nameForAnswers',
    );

    expect(updatedState.isButtonDisabled, false);
  });

  test('is button disabled, edit mode, data not edited', () {
    final GroupCreatorState updatedState = state.copyWith(
      mode: GroupCreatorEditMode(
        group: createGroup(
          id: 'g1',
          courseId: 'c1',
          name: 'name',
          nameForQuestions: 'nameForQuestions',
          nameForAnswers: 'nameForAnswers',
        ),
      ),
      selectedCourse: createCourse(id: 'c1'),
      groupName: 'name',
      nameForQuestions: 'nameForQuestions',
      nameForAnswers: 'nameForAnswers',
    );

    expect(updatedState.isButtonDisabled, true);
  });

  test('is button disabled, edit mode, data edited', () {
    final GroupCreatorState state2 = state.copyWith(
      mode: GroupCreatorEditMode(
        group: createGroup(
          id: 'g1',
          courseId: 'c1',
          name: 'name',
          nameForQuestions: 'nameForQuestions',
          nameForAnswers: 'nameForAnswers',
        ),
      ),
      selectedCourse: createCourse(id: 'c1'),
      groupName: 'name',
      nameForQuestions: 'nameForQuestions',
      nameForAnswers: 'nameForAnswers',
    );
    final GroupCreatorState state3 = state2.copyWith(
      nameForQuestions: 'name for questions',
    );

    expect(state3.isButtonDisabled, false);
  });

  test('is button disabled, edit mode, not all data entered', () {
    final GroupCreatorState state2 = state.copyWith(
      mode: GroupCreatorEditMode(
        group: createGroup(
          id: 'g1',
          courseId: 'c1',
          name: 'name',
          nameForQuestions: 'nameForQuestions',
          nameForAnswers: 'nameForAnswers',
        ),
      ),
      selectedCourse: createCourse(id: 'c1'),
      groupName: 'name',
      nameForQuestions: 'nameForQuestions',
      nameForAnswers: 'nameForAnswers',
    );
    final GroupCreatorState state3 = state2.copyWith(nameForQuestions: '');

    expect(state3.isButtonDisabled, true);
  });
}

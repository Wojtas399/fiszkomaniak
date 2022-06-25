import 'package:fiszkomaniak/domain/entities/course.dart';
import 'package:fiszkomaniak/domain/entities/group.dart';
import 'package:fiszkomaniak/features/group_creator/bloc/group_creator_bloc.dart';
import 'package:fiszkomaniak/features/group_creator/bloc/group_creator_info.dart';
import 'package:fiszkomaniak/features/group_creator/bloc/group_creator_mode.dart';
import 'package:fiszkomaniak/models/bloc_status.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late GroupCreatorState state;

  setUp(() {
    state = const GroupCreatorState();
  });

  test(
    'initial state',
    () {
      expect(state.mode, const GroupCreatorCreateMode());
      expect(state.status, const BlocStatusInitial());
      expect(state.selectedCourse, null);
      expect(state.allCourses, []);
      expect(state.groupName, '');
      expect(state.nameForQuestions, '');
      expect(state.nameForAnswers, '');
    },
  );

  test(
    'copy with mode',
    () {
      final GroupCreatorMode expectedMode = GroupCreatorEditMode(
        group: createGroup(id: 'g1'),
      );

      final state2 = state.copyWith(mode: expectedMode);
      final state3 = state2.copyWith();

      expect(state2.mode, expectedMode);
      expect(state3.mode, expectedMode);
    },
  );

  test(
    'copy with status',
    () {
      const BlocStatus expectedStatus = BlocStatusLoading();

      final state2 = state.copyWith(status: expectedStatus);
      final state3 = state2.copyWith();

      expect(state2.status, expectedStatus);
      expect(state3.status, const BlocStatusComplete<GroupCreatorInfo>());
    },
  );

  test(
    'copy with selected course',
    () {
      final Course expectedCourse = createCourse(id: 'c1', name: 'course 1');

      final state2 = state.copyWith(selectedCourse: expectedCourse);
      final state3 = state2.copyWith();

      expect(state2.selectedCourse, expectedCourse);
      expect(state3.selectedCourse, expectedCourse);
    },
  );

  test(
    'copy with all courses',
    () {
      final List<Course> expectedCourses = [
        createCourse(id: 'c1', name: 'course 1 name'),
        createCourse(id: 'c2', name: 'course 2 name'),
      ];

      final state2 = state.copyWith(allCourses: expectedCourses);
      final state3 = state2.copyWith();

      expect(state2.allCourses, expectedCourses);
      expect(state3.allCourses, expectedCourses);
    },
  );

  test(
    'copy with group name',
    () {
      const String expectedName = 'group 1';

      final state2 = state.copyWith(groupName: expectedName);
      final state3 = state2.copyWith();

      expect(state2.groupName, expectedName);
      expect(state3.groupName, expectedName);
    },
  );

  test(
    'copy with name for questions',
    () {
      const String expectedName = 'questions';

      final state2 = state.copyWith(nameForQuestions: expectedName);
      final state3 = state2.copyWith();

      expect(state2.nameForQuestions, expectedName);
      expect(state3.nameForQuestions, expectedName);
    },
  );

  test(
    'copy with name for answers',
    () {
      const String expectedName = 'answers';

      final state2 = state.copyWith(nameForAnswers: expectedName);
      final state3 = state2.copyWith();

      expect(state2.nameForAnswers, expectedName);
      expect(state3.nameForAnswers, expectedName);
    },
  );

  test(
    'is button disabled, course has not been selected, should be true',
    () {
      state = state.copyWith(
        selectedCourse: null,
        groupName: 'group 1',
        nameForQuestions: 'questions',
        nameForAnswers: 'answers',
      );

      expect(state.isButtonDisabled, true);
    },
  );

  test(
    'is button disabled, group name is empty string, should be true',
    () {
      state = state.copyWith(
        selectedCourse: createCourse(id: 'c1'),
        groupName: '',
        nameForQuestions: 'questions',
        nameForAnswers: 'answers',
      );

      expect(state.isButtonDisabled, true);
    },
  );

  test(
    'is button disabled, name for questions is empty string, should be true',
    () {
      state = state.copyWith(
        selectedCourse: createCourse(id: 'c1'),
        groupName: 'group 1',
        nameForQuestions: '',
        nameForAnswers: 'answers',
      );

      expect(state.isButtonDisabled, true);
    },
  );

  test(
    'is button disabled, name for answers is empty string, should be true',
    () {
      state = state.copyWith(
        selectedCourse: createCourse(id: 'c1'),
        groupName: 'group 1',
        nameForQuestions: 'questions',
        nameForAnswers: '',
      );

      expect(state.isButtonDisabled, true);
    },
  );

  test(
    'is button disabled, create mode, all required params have been entered, should be false',
    () {
      state = state.copyWith(
        selectedCourse: createCourse(id: 'c1'),
        groupName: 'group 1',
        nameForQuestions: 'questions',
        nameForAnswers: 'answers',
      );

      expect(state.isButtonDisabled, false);
    },
  );

  test(
    'is button disabled, edit mode, all required params have not been edited, should be true',
    () {
      state = state.copyWith(
        mode: GroupCreatorEditMode(
          group: createGroup(
            id: 'g1',
            name: 'group 1',
            courseId: 'c1',
            nameForQuestions: 'questions',
            nameForAnswers: 'answers',
          ),
        ),
        selectedCourse: createCourse(id: 'c1'),
        groupName: 'group 1',
        nameForQuestions: 'questions',
        nameForAnswers: 'answers',
      );

      expect(state.isButtonDisabled, true);
    },
  );
}

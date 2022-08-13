import 'package:flutter_test/flutter_test.dart';
import 'package:fiszkomaniak/domain/entities/course.dart';
import 'package:fiszkomaniak/domain/entities/group.dart';
import 'package:fiszkomaniak/features/group_creator/bloc/group_creator_bloc.dart';
import 'package:fiszkomaniak/features/group_creator/bloc/group_creator_mode.dart';
import 'package:fiszkomaniak/models/bloc_status.dart';

void main() {
  late GroupCreatorState state;

  setUp(() {
    state = const GroupCreatorState(
      mode: GroupCreatorCreateMode(),
      status: BlocStatusInitial(),
      selectedCourse: null,
      allCourses: [],
      groupName: '',
      nameForQuestions: '',
      nameForAnswers: '',
    );
  });

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

  test(
    'copy with mode',
    () {
      final GroupCreatorMode expectedMode = GroupCreatorEditMode(
        group: createGroup(id: 'g1'),
      );

      state = state.copyWith(mode: expectedMode);
      final state2 = state.copyWith();

      expect(state.mode, expectedMode);
      expect(state2.mode, expectedMode);
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
    'copy with selected course',
    () {
      final Course expectedCourse = createCourse(id: 'c1', name: 'course 1');

      state = state.copyWith(selectedCourse: expectedCourse);
      final state2 = state.copyWith();

      expect(state.selectedCourse, expectedCourse);
      expect(state2.selectedCourse, expectedCourse);
    },
  );

  test(
    'copy with all courses',
    () {
      final List<Course> expectedCourses = [
        createCourse(id: 'c1', name: 'course 1 name'),
        createCourse(id: 'c2', name: 'course 2 name'),
      ];

      state = state.copyWith(allCourses: expectedCourses);
      final state2 = state.copyWith();

      expect(state.allCourses, expectedCourses);
      expect(state2.allCourses, expectedCourses);
    },
  );

  test(
    'copy with group name',
    () {
      const String expectedName = 'group 1';

      state = state.copyWith(groupName: expectedName);
      final state2 = state.copyWith();

      expect(state.groupName, expectedName);
      expect(state2.groupName, expectedName);
    },
  );

  test(
    'copy with name for questions',
    () {
      const String expectedName = 'questions';

      state = state.copyWith(nameForQuestions: expectedName);
      final state2 = state.copyWith();

      expect(state.nameForQuestions, expectedName);
      expect(state2.nameForQuestions, expectedName);
    },
  );

  test(
    'copy with name for answers',
    () {
      const String expectedName = 'answers';

      state = state.copyWith(nameForAnswers: expectedName);
      final state2 = state.copyWith();

      expect(state.nameForAnswers, expectedName);
      expect(state2.nameForAnswers, expectedName);
    },
  );

  test(
    'copy with info',
    () {
      const GroupCreatorInfo expectedInfo = GroupCreatorInfo.groupHasBeenAdded;

      state = state.copyWithInfo(expectedInfo);

      expect(
        state.status,
        const BlocStatusComplete<GroupCreatorInfo>(
          info: expectedInfo,
        ),
      );
    },
  );

  test(
    'copy with error',
    () {
      const GroupCreatorError expectedError =
          GroupCreatorError.groupNameIsAlreadyTaken;

      state = state.copyWithError(expectedError);

      expect(
        state.status,
        const BlocStatusError<GroupCreatorError>(
          error: expectedError,
        ),
      );
    },
  );
}

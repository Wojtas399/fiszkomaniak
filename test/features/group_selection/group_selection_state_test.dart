import 'package:fiszkomaniak/domain/entities/course.dart';
import 'package:fiszkomaniak/domain/entities/group.dart';
import 'package:fiszkomaniak/features/group_selection/bloc/group_selection_bloc.dart';
import 'package:fiszkomaniak/models/bloc_status.dart';
import 'package:fiszkomaniak/models/flashcard_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late GroupSelectionState state;

  setUp(() => state = GroupSelectionState());

  test(
    'initial state',
    () {
      expect(state.status, const BlocStatusInitial());
      expect(state.coursesToSelect, {});
      expect(state.groupsFromCourseToSelect, {});
      expect(state.selectedCourse, null);
      expect(state.selectedGroup, null);
    },
  );

  test(
    'courses to select, should be a map in which keys are courses ids and values are courses names',
    () {
      final List<Course> courses = [
        createCourse(id: 'c1', name: 'course 1'),
        createCourse(id: 'c2', name: 'course 2'),
      ];

      state = state.copyWith(allCourses: courses);

      expect(
        state.coursesToSelect,
        {
          'c1': 'course 1',
          'c2': 'course 2',
        },
      );
    },
  );

  test(
    'groups from course to select, should be a map in which keys are groups ids and values are groups names',
    () {
      final List<Group> groups = [
        createGroup(id: 'g1', name: 'group one'),
        createGroup(id: 'g2', name: 'group two'),
      ];

      state = state.copyWith(groupsFromCourse: groups);

      expect(
        state.groupsFromCourseToSelect,
        {
          'g1': 'group one',
          'g2': 'group two',
        },
      );
    },
  );

  test(
    'amount of all flashcards, should be a number which represents the amount of all flashcards in selected group',
    () {
      final Group group = createGroup(
        flashcards: [
          createFlashcard(index: 0, status: FlashcardStatus.remembered),
          createFlashcard(index: 1, status: FlashcardStatus.notRemembered),
          createFlashcard(index: 2, status: FlashcardStatus.remembered),
        ],
      );

      state = state.copyWith(selectedGroup: group);

      expect(state.amountOfAllFlashcards, 3);
    },
  );

  test(
    'amount of remembered flashcards, should be a number which represents the amount of remembered flashcards in selected group',
    () {
      final Group group = createGroup(
        flashcards: [
          createFlashcard(index: 0, status: FlashcardStatus.remembered),
          createFlashcard(index: 1, status: FlashcardStatus.notRemembered),
          createFlashcard(index: 2, status: FlashcardStatus.remembered),
        ],
      );

      state = state.copyWith(selectedGroup: group);

      expect(state.amountOfRememberedFlashcards, 2);
    },
  );

  test(
    'is button disabled, should be true if course has not been selected',
    () {
      state = state.copyWith(
        selectedCourse: null,
        selectedGroup: createGroup(id: 'g1'),
      );

      expect(state.isButtonDisabled, true);
    },
  );

  test(
    'is button disabled, should be true if group has not been selected',
    () {
      state = state.copyWith(
        selectedCourse: createCourse(id: 'c1'),
        selectedGroup: null,
      );

      expect(state.isButtonDisabled, true);
    },
  );

  test(
    'is button disabled, should be false if course and group have been selected',
    () {
      state = state.copyWith(
        selectedCourse: createCourse(id: 'c1'),
        selectedGroup: createGroup(id: 'g1'),
      );

      expect(state.isButtonDisabled, false);
    },
  );

  test(
    'copy with status',
    () {
      const BlocStatus expectedStatus = BlocStatusLoading();

      final state2 = state.copyWith(status: expectedStatus);
      final state3 = state2.copyWith();

      expect(state2.status, expectedStatus);
      expect(state3.status, const BlocStatusComplete());
    },
  );

  test(
    'copy with courses',
    () {
      final List<Course> courses = [
        createCourse(id: 'c1', name: 'course 1'),
        createCourse(id: 'c2', name: 'course 2'),
      ];

      final state2 = state.copyWith(allCourses: courses);
      final state3 = state2.copyWith();

      expect(
        state2.coursesToSelect,
        {
          'c1': 'course 1',
          'c2': 'course 2',
        },
      );
      expect(
        state3.coursesToSelect,
        {
          'c1': 'course 1',
          'c2': 'course 2',
        },
      );
    },
  );

  test(
    'copy with groups from course',
    () {
      final List<Group> groups = [
        createGroup(id: 'g1', name: 'group 1'),
        createGroup(id: 'g2', name: 'group 2'),
      ];

      final state2 = state.copyWith(groupsFromCourse: groups);
      final state3 = state2.copyWith();

      expect(
        state2.groupsFromCourseToSelect,
        {
          'g1': 'group 1',
          'g2': 'group 2',
        },
      );
      expect(
        state3.groupsFromCourseToSelect,
        {
          'g1': 'group 1',
          'g2': 'group 2',
        },
      );
    },
  );

  test(
    'copy with selected course',
    () {
      final Course expectedCourse = createCourse(id: 'c1');

      final state2 = state.copyWith(selectedCourse: expectedCourse);
      final state3 = state2.copyWith();

      expect(state2.selectedCourse, expectedCourse);
      expect(state3.selectedCourse, expectedCourse);
    },
  );

  test(
    'copy with selected group',
    () {
      final Group expectedGroup = createGroup(id: 'c1');

      final state2 = state.copyWith(selectedGroup: expectedGroup);
      final state3 = state2.copyWith();

      expect(state2.selectedGroup, expectedGroup);
      expect(state3.selectedGroup, null);
    },
  );
}

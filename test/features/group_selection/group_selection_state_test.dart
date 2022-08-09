import 'package:flutter_test/flutter_test.dart';
import 'package:fiszkomaniak/domain/entities/course.dart';
import 'package:fiszkomaniak/domain/entities/flashcard.dart';
import 'package:fiszkomaniak/domain/entities/group.dart';
import 'package:fiszkomaniak/features/group_selection/bloc/group_selection_bloc.dart';
import 'package:fiszkomaniak/models/bloc_status.dart';

void main() {
  late GroupSelectionState state;

  setUp(
    () => state = const GroupSelectionState(
      status: BlocStatusInitial(),
      allCourses: [],
      groupsFromCourse: [],
      selectedCourse: null,
      selectedGroup: null,
    ),
  );

  test(
    'amount of all flashcards',
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
    'amount of remembered flashcards',
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

      state = state.copyWith(status: expectedStatus);
      final state2 = state.copyWith();

      expect(state.status, expectedStatus);
      expect(state2.status, const BlocStatusInProgress());
    },
  );

  test(
    'copy with courses',
    () {
      final List<Course> expectedCourses = [
        createCourse(id: 'c1', name: 'course 1'),
        createCourse(id: 'c2', name: 'course 2'),
      ];

      state = state.copyWith(allCourses: expectedCourses);
      final state2 = state.copyWith();

      expect(state.allCourses, expectedCourses);
      expect(state2.allCourses, expectedCourses);
    },
  );

  test(
    'copy with groups from course',
    () {
      final List<Group> expectedGroups = [
        createGroup(id: 'g1', name: 'group 1'),
        createGroup(id: 'g2', name: 'group 2'),
      ];

      state = state.copyWith(groupsFromCourse: expectedGroups);
      final state2 = state.copyWith();

      expect(state.groupsFromCourse, expectedGroups);
      expect(state2.groupsFromCourse, expectedGroups);
    },
  );

  test(
    'copy with selected course',
    () {
      final Course expectedCourse = createCourse(id: 'c1');

      state = state.copyWith(selectedCourse: expectedCourse);
      final state2 = state.copyWith();

      expect(state.selectedCourse, expectedCourse);
      expect(state2.selectedCourse, expectedCourse);
    },
  );

  test(
    'copy with selected group',
    () {
      final Group expectedGroup = createGroup(id: 'c1');

      state = state.copyWith(selectedGroup: expectedGroup);
      final state2 = state.copyWith();

      expect(state.selectedGroup, expectedGroup);
      expect(state2.selectedGroup, null);
    },
  );
}

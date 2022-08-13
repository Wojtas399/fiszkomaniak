import 'package:flutter_test/flutter_test.dart';
import 'package:fiszkomaniak/domain/entities/course.dart';
import 'package:fiszkomaniak/domain/entities/flashcard.dart';
import 'package:fiszkomaniak/domain/entities/group.dart';
import 'package:fiszkomaniak/features/group_preview/bloc/group_preview_bloc.dart';
import 'package:fiszkomaniak/models/bloc_status.dart';

void main() {
  late GroupPreviewState state;

  setUp(
    () => state = const GroupPreviewState(
      status: BlocStatusInitial(),
      group: null,
      course: null,
    ),
  );

  test(
    'amount of all flashcards, should return amount of all flashcards from group',
    () {
      final Group group = createGroup(flashcards: [
        createFlashcard(index: 0, status: FlashcardStatus.remembered),
        createFlashcard(index: 1, status: FlashcardStatus.remembered),
        createFlashcard(index: 2, status: FlashcardStatus.notRemembered),
      ]);

      state = state.copyWith(group: group);

      expect(state.amountOfAllFlashcards, 3);
    },
  );

  test(
    'amount of remembered flashcards, should return amount of remembered flashcards from group',
    () {
      final Group group = createGroup(flashcards: [
        createFlashcard(index: 0, status: FlashcardStatus.remembered),
        createFlashcard(index: 1, status: FlashcardStatus.remembered),
        createFlashcard(index: 2, status: FlashcardStatus.notRemembered),
      ]);

      state = state.copyWith(group: group);

      expect(state.amountOfRememberedFlashcards, 2);
    },
  );

  test(
    'does group exist, should be false if group is null',
    () {
      expect(state.doesGroupExist, false);
    },
  );

  test(
    'does group exist, should be true if group is not null',
    () {
      state = state.copyWith(
        group: createGroup(),
      );

      expect(state.doesGroupExist, true);
    },
  );

  test(
    'is quick session button disabled, should be true if amount of all flashcards is equal to zero',
    () {
      state = state.copyWith(
        group: createGroup(flashcards: []),
      );

      expect(state.isQuickSessionButtonDisabled, true);
    },
  );

  test(
    'is quick session button disabled, should be false if amount of all flashcards is higher than zero',
    () {
      state = state.copyWith(
        group: createGroup(
          flashcards: [
            createFlashcard(index: 0),
            createFlashcard(index: 1),
          ],
        ),
      );

      expect(state.isQuickSessionButtonDisabled, false);
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
    'copy with group',
    () {
      final Group expectedGroup = createGroup(id: 'g1', name: 'group 1');

      state = state.copyWith(group: expectedGroup);
      final state2 = state.copyWith();

      expect(state.group, expectedGroup);
      expect(state2.group, expectedGroup);
    },
  );

  test(
    'copy with course',
    () {
      final Course expectedCourse = createCourse(id: 'c1', name: 'course 1');

      state = state.copyWith(course: expectedCourse);
      final state2 = state.copyWith();

      expect(state.course, expectedCourse);
      expect(state2.course, expectedCourse);
    },
  );

  test(
    'copy with info',
    () {
      const GroupPreviewInfo expectedInfo =
          GroupPreviewInfo.groupHasBeenDeleted;

      state = state.copyWithInfo(expectedInfo);

      expect(
        state.status,
        const BlocStatusComplete<GroupPreviewInfo>(
          info: expectedInfo,
        ),
      );
    },
  );
}

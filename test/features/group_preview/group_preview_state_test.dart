import 'package:fiszkomaniak/domain/entities/course.dart';
import 'package:fiszkomaniak/domain/entities/group.dart';
import 'package:fiszkomaniak/features/group_preview/bloc/group_preview_bloc.dart';
import 'package:fiszkomaniak/models/bloc_status.dart';
import 'package:fiszkomaniak/models/flashcard_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late GroupPreviewState state;

  setUp(() => state = const GroupPreviewState());

  test(
    'initial state',
    () {
      expect(state.status, const BlocStatusInitial());
      expect(state.group, null);
      expect(state.course, null);
    },
  );

  test(
    'copy with status',
    () {
      const BlocStatus expectedStatus = BlocStatusLoading();

      final state2 = state.copyWith(status: expectedStatus);
      final state3 = state2.copyWith();

      expect(state2.status, expectedStatus);
      expect(state3.status, const BlocStatusComplete<GroupPreviewInfoType>());
    },
  );

  test(
    'copy with group',
    () {
      final Group expectedGroup = createGroup(id: 'g1', name: 'group 1');

      final state2 = state.copyWith(group: expectedGroup);
      final state3 = state2.copyWith();

      expect(state2.group, expectedGroup);
      expect(state3.group, expectedGroup);
    },
  );

  test(
    'copy with course',
    () {
      final Course expectedCourse = createCourse(id: 'c1', name: 'course 1');

      final state2 = state.copyWith(course: expectedCourse);
      final state3 = state2.copyWith();

      expect(state2.course, expectedCourse);
      expect(state3.course, expectedCourse);
    },
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
}

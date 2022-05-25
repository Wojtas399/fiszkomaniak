import 'package:bloc_test/bloc_test.dart';
import 'package:fiszkomaniak/core/flashcards/flashcards_bloc.dart';
import 'package:fiszkomaniak/core/groups/groups_bloc.dart';
import 'package:fiszkomaniak/features/flashcards_editor/bloc/flashcards_editor_bloc.dart';
import 'package:fiszkomaniak/features/flashcards_editor/bloc/flashcards_editor_dialogs.dart';
import 'package:fiszkomaniak/features/flashcards_editor/bloc/flashcards_editor_event.dart';
import 'package:fiszkomaniak/features/flashcards_editor/bloc/flashcards_editor_state.dart';
import 'package:fiszkomaniak/features/flashcards_editor/bloc/flashcards_editor_utils.dart';
import 'package:fiszkomaniak/features/flashcards_editor/flashcards_editor_mode.dart';
import 'package:fiszkomaniak/models/flashcard_model.dart';
import 'package:fiszkomaniak/models/group_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGroupsBloc extends Mock implements GroupsBloc {}

class MockFlashcardsBloc extends Mock implements FlashcardsBloc {}

class MockFlashcardsEditorDialogs extends Mock
    implements FlashcardsEditorDialogs {}

class MockFlashcardsEditorUtils extends Mock implements FlashcardsEditorUtils {}

void main() {
  final GroupsBloc groupsBloc = MockGroupsBloc();
  final FlashcardsBloc flashcardsBloc = MockFlashcardsBloc();
  final FlashcardsEditorDialogs flashcardsEditorDialogs =
      MockFlashcardsEditorDialogs();
  final FlashcardsEditorUtils flashcardsEditorUtils =
      MockFlashcardsEditorUtils();
  late FlashcardsEditorBloc bloc;
  final List<Flashcard> flashcards = [
    createFlashcard(
      index: 0,
      question: 'q1',
      answer: 'a1',
    ),
    createFlashcard(
      index: 1,
      question: 'q2',
      answer: 'a2',
    ),
    createFlashcard(
      index: 2,
      question: 'q3',
      answer: 'a3',
    ),
  ];
  final List<Group> groups = [
    createGroup(id: 'g1', name: 'group 1', flashcards: flashcards),
    createGroup(id: 'g2', name: 'group 2'),
  ];
  final FlashcardsEditorState stateAfterInitialization = FlashcardsEditorState(
    mode: const FlashcardsEditorEditMode(groupId: 'g1'),
    group: groups[0],
    flashcards: [
      createEditorFlashcard(
        key: 'flashcard0',
        doc: flashcards[0],
        isCorrect: true,
      ),
      createEditorFlashcard(
        key: 'flashcard1',
        doc: flashcards[1],
        isCorrect: true,
      ),
      createEditorFlashcard(
        key: 'flashcard2',
        doc: flashcards[2],
        isCorrect: true,
      ),
      createEditorFlashcard(
        key: 'flashcard3',
        doc: createFlashcard(index: 3),
        isCorrect: true,
      ),
    ],
    keyCounter: 3,
  );
  final FlashcardsEditorState addModeStateAfterInitialization =
      stateAfterInitialization.copyWith(
    flashcards: [stateAfterInitialization.flashcards[3]],
    mode: const FlashcardsEditorAddMode(groupId: 'g1'),
  );

  setUp(() {
    bloc = FlashcardsEditorBloc(
      groupsBloc: groupsBloc,
      flashcardsBloc: flashcardsBloc,
      flashcardsEditorDialogs: flashcardsEditorDialogs,
      flashcardsEditorUtils: flashcardsEditorUtils,
    );
    when(() => groupsBloc.state).thenReturn(
      GroupsState(allGroups: groups),
    );
    when(() => flashcardsBloc.state).thenReturn(
      FlashcardsState(groupsState: GroupsState(allGroups: groups)),
    );
  });

  tearDown(() {
    reset(groupsBloc);
    reset(flashcardsBloc);
    reset(flashcardsEditorDialogs);
    reset(flashcardsEditorUtils);
  });

  blocTest(
    'initialize, edit mode',
    build: () => bloc,
    act: (_) => bloc.add(
      FlashcardsEditorEventInitialize(
        mode: const FlashcardsEditorEditMode(groupId: 'g1'),
      ),
    ),
    expect: () => [stateAfterInitialization],
  );

  blocTest(
    'initialize, add mode',
    build: () => bloc,
    act: (_) => bloc.add(
      FlashcardsEditorEventInitialize(
        mode: const FlashcardsEditorAddMode(groupId: 'g1'),
      ),
    ),
    expect: () => [addModeStateAfterInitialization],
  );

  blocTest(
    'remove flashcard, confirmed',
    build: () => bloc,
    setUp: () {
      when(() => flashcardsEditorDialogs.askForDeleteConfirmation())
          .thenAnswer((_) async => true);
    },
    act: (_) {
      bloc.add(FlashcardsEditorEventInitialize(
        mode: const FlashcardsEditorEditMode(groupId: 'g1'),
      ));
      bloc.add(FlashcardsEditorEventRemoveFlashcard(indexOfFlashcard: 1));
    },
    expect: () => [
      stateAfterInitialization,
      stateAfterInitialization.copyWith(
        flashcards: [
          stateAfterInitialization.flashcards[0],
          stateAfterInitialization.flashcards[2],
          stateAfterInitialization.flashcards[3],
        ],
      ),
    ],
  );

  blocTest(
    'remove flashcard, confirmed, the last flashcard',
    build: () => bloc,
    setUp: () {
      when(() => flashcardsEditorDialogs.askForDeleteConfirmation())
          .thenAnswer((_) async => true);
    },
    act: (_) {
      bloc.add(FlashcardsEditorEventInitialize(
        mode: const FlashcardsEditorAddMode(groupId: 'g1'),
      ));
      bloc.add(FlashcardsEditorEventRemoveFlashcard(indexOfFlashcard: 0));
    },
    expect: () => [
      stateAfterInitialization.copyWith(
        flashcards: [
          stateAfterInitialization
              .flashcards[stateAfterInitialization.flashcards.length - 1],
        ],
        mode: const FlashcardsEditorAddMode(groupId: 'g1'),
      ),
    ],
  );

  blocTest(
    'remove flashcard, cancelled',
    build: () => bloc,
    setUp: () {
      when(() => flashcardsEditorDialogs.askForDeleteConfirmation())
          .thenAnswer((_) async => false);
    },
    act: (_) {
      bloc.add(FlashcardsEditorEventInitialize(
        mode: const FlashcardsEditorEditMode(groupId: 'g1'),
      ));
      bloc.add(FlashcardsEditorEventRemoveFlashcard(indexOfFlashcard: 1));
    },
    expect: () => [stateAfterInitialization],
  );

  blocTest(
    'save, no changes',
    build: () => bloc,
    setUp: () {
      when(
        () => flashcardsEditorUtils.haveChangesBeenMade(
          flashcards,
          stateAfterInitialization.flashcardsWithoutLastOne,
        ),
      ).thenReturn(false);
      when(() => flashcardsEditorDialogs.displayInfoAboutNoChanges())
          .thenAnswer((_) async => '');
    },
    act: (_) {
      bloc.add(FlashcardsEditorEventInitialize(
        mode: const FlashcardsEditorEditMode(groupId: 'g1'),
      ));
      bloc.add(FlashcardsEditorEventSave());
    },
    verify: (_) {
      verify(() => flashcardsEditorDialogs.displayInfoAboutNoChanges())
          .called(1);
      verifyNever(
        () => flashcardsBloc.add(
          FlashcardsEventSaveFlashcards(
            groupId: 'g1',
            flashcards: stateAfterInitialization.flashcardsWithoutLastOne,
          ),
        ),
      );
    },
  );

  blocTest(
    'save, incorrect flashcards',
    build: () => bloc,
    setUp: () {
      when(
        () => flashcardsEditorUtils.haveChangesBeenMade(
          flashcards,
          stateAfterInitialization.flashcardsWithoutLastOne,
        ),
      ).thenReturn(true);
      when(
        () => flashcardsEditorUtils.lookForIncorrectlyCompletedFlashcards(
          stateAfterInitialization.flashcardsWithoutLastOne,
        ),
      ).thenReturn([stateAfterInitialization.flashcardsWithoutLastOne[0]]);
      when(
        () => flashcardsEditorDialogs.displayInfoAboutIncorrectFlashcards(),
      ).thenAnswer((_) async => '');
    },
    act: (_) {
      bloc.add(FlashcardsEditorEventInitialize(
        mode: const FlashcardsEditorEditMode(groupId: 'g1'),
      ));
      bloc.add(FlashcardsEditorEventSave());
    },
    expect: () => [
      stateAfterInitialization,
      stateAfterInitialization.copyWith(
        flashcards: [
          stateAfterInitialization.flashcards[0].copyWith(isCorrect: false),
          stateAfterInitialization.flashcards[1],
          stateAfterInitialization.flashcards[2],
          stateAfterInitialization.flashcards[3],
        ],
      ),
    ],
    verify: (_) {
      verify(
        () => flashcardsEditorDialogs.displayInfoAboutIncorrectFlashcards(),
      ).called(1);
      verifyNever(
        () => flashcardsBloc.add(
          FlashcardsEventSaveFlashcards(
            groupId: 'g1',
            flashcards: stateAfterInitialization.flashcardsWithoutLastOne,
          ),
        ),
      );
    },
  );

  blocTest(
    'save, duplicates',
    build: () => bloc,
    setUp: () {
      when(
        () => flashcardsEditorUtils.haveChangesBeenMade(
          flashcards,
          stateAfterInitialization.flashcardsWithoutLastOne,
        ),
      ).thenReturn(true);
      when(
        () => flashcardsEditorUtils.lookForIncorrectlyCompletedFlashcards(
          stateAfterInitialization.flashcardsWithoutLastOne,
        ),
      ).thenReturn([]);
      when(
        () => flashcardsEditorUtils.lookForDuplicates(
          stateAfterInitialization.flashcardsWithoutLastOne,
        ),
      ).thenReturn([
        stateAfterInitialization.flashcardsWithoutLastOne[0],
        stateAfterInitialization.flashcardsWithoutLastOne[1],
      ]);
      when(
        () => flashcardsEditorDialogs.displayInfoAboutDuplicates(),
      ).thenAnswer((_) async => '');
    },
    act: (_) {
      bloc.add(FlashcardsEditorEventInitialize(
        mode: const FlashcardsEditorEditMode(groupId: 'g1'),
      ));
      bloc.add(FlashcardsEditorEventSave());
    },
    expect: () => [
      stateAfterInitialization,
      stateAfterInitialization.copyWith(
        flashcards: [
          stateAfterInitialization.flashcards[0].copyWith(isCorrect: false),
          stateAfterInitialization.flashcards[1].copyWith(isCorrect: false),
          stateAfterInitialization.flashcards[2],
          stateAfterInitialization.flashcards[3],
        ],
      ),
    ],
    verify: (_) {
      verify(
        () => flashcardsEditorDialogs.displayInfoAboutDuplicates(),
      ).called(1);
      verifyNever(
        () => flashcardsBloc.add(
          FlashcardsEventSaveFlashcards(
            groupId: 'g1',
            flashcards: stateAfterInitialization.flashcardsWithoutLastOne,
          ),
        ),
      );
    },
  );

  group('save correctly edited flashcards', () {
    setUp(() {
      when(
        () => flashcardsEditorUtils.haveChangesBeenMade(
          flashcards,
          stateAfterInitialization.flashcardsWithoutLastOne,
        ),
      ).thenReturn(true);
      when(
        () => flashcardsEditorUtils.lookForIncorrectlyCompletedFlashcards(
          stateAfterInitialization.flashcardsWithoutLastOne,
        ),
      ).thenReturn([]);
      when(
        () => flashcardsEditorUtils.lookForDuplicates(
          stateAfterInitialization.flashcardsWithoutLastOne,
        ),
      ).thenReturn([]);
    });

    blocTest(
      'cancelled',
      build: () => bloc,
      setUp: () {
        when(() => flashcardsEditorDialogs.askForSaveConfirmation())
            .thenAnswer((_) async => false);
      },
      act: (_) {
        bloc.add(FlashcardsEditorEventInitialize(
          mode: const FlashcardsEditorEditMode(groupId: 'g1'),
        ));
        bloc.add(FlashcardsEditorEventSave());
      },
      verify: (_) {
        verify(() => flashcardsEditorDialogs.askForSaveConfirmation())
            .called(1);
        verifyNever(
          () => flashcardsBloc.add(
            FlashcardsEventSaveFlashcards(
              groupId: 'g1',
              flashcards: stateAfterInitialization.flashcardsWithoutLastOne,
            ),
          ),
        );
      },
    );

    blocTest(
      'confirmed',
      build: () => bloc,
      setUp: () {
        when(() => flashcardsEditorDialogs.askForSaveConfirmation())
            .thenAnswer((_) async => true);
      },
      act: (_) {
        bloc.add(FlashcardsEditorEventInitialize(
          mode: const FlashcardsEditorEditMode(groupId: 'g1'),
        ));
        bloc.add(FlashcardsEditorEventSave());
      },
      verify: (_) {
        verify(() => flashcardsEditorDialogs.askForSaveConfirmation())
            .called(1);
        verify(
          () => flashcardsBloc.add(
            FlashcardsEventSaveFlashcards(
              groupId: 'g1',
              flashcards: stateAfterInitialization.flashcardsWithoutLastOne,
            ),
          ),
        ).called(1);
      },
    );

    blocTest(
      'add mode',
      build: () => bloc,
      setUp: () {
        when(
          () => flashcardsEditorUtils.haveChangesBeenMade(
            flashcards,
            addModeStateAfterInitialization.flashcardsWithoutLastOne,
          ),
        ).thenReturn(true);
        when(
          () => flashcardsEditorUtils.lookForIncorrectlyCompletedFlashcards(
            addModeStateAfterInitialization.flashcardsWithoutLastOne,
          ),
        ).thenReturn([]);
        when(() => flashcardsEditorDialogs.askForSaveConfirmation())
            .thenAnswer((_) async => true);
      },
      act: (_) {
        bloc.add(FlashcardsEditorEventInitialize(
          mode: const FlashcardsEditorAddMode(groupId: 'g1'),
        ));
        bloc.add(FlashcardsEditorEventSave());
      },
      verify: (_) {
        verify(() => flashcardsEditorDialogs.askForSaveConfirmation())
            .called(1);
        verify(
          () => flashcardsBloc.add(
            FlashcardsEventSaveFlashcards(
              groupId: 'g1',
              flashcards: stateAfterInitialization.flashcardsWithoutLastOne,
              justAddedFlashcards: true,
            ),
          ),
        ).called(1);
      },
    );
  });
}

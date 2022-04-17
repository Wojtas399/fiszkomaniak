import 'package:bloc_test/bloc_test.dart';
import 'package:fiszkomaniak/core/flashcards/flashcards_bloc.dart';
import 'package:fiszkomaniak/core/flashcards/flashcards_event.dart';
import 'package:fiszkomaniak/core/flashcards/flashcards_state.dart';
import 'package:fiszkomaniak/core/groups/groups_bloc.dart';
import 'package:fiszkomaniak/core/groups/groups_state.dart';
import 'package:fiszkomaniak/features/flashcards_editor/bloc/flashcards_editor_bloc.dart';
import 'package:fiszkomaniak/features/flashcards_editor/bloc/flashcards_editor_dialogs.dart';
import 'package:fiszkomaniak/features/flashcards_editor/bloc/flashcards_editor_event.dart';
import 'package:fiszkomaniak/features/flashcards_editor/bloc/flashcards_editor_state.dart';
import 'package:fiszkomaniak/features/flashcards_editor/bloc/flashcards_editor_utils.dart';
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
  final List<Group> groups = [
    createGroup(id: 'g1', name: 'group 1'),
    createGroup(id: 'g2', name: 'group 2'),
  ];
  final List<Flashcard> flashcards = [
    createFlashcard(
      id: 'f1',
      groupId: 'g1',
      question: 'q1',
      answer: 'a1',
    ),
    createFlashcard(
      id: 'f2',
      groupId: 'g1',
      question: 'q2',
      answer: 'a2',
    ),
    createFlashcard(
      id: 'f3',
      groupId: 'g1',
      question: 'q3',
      answer: 'a3',
    ),
    createFlashcard(
      id: 'f4',
      groupId: 'g2',
      question: 'q4',
      answer: 'a4',
    ),
  ];
  final FlashcardsEditorState stateAfterInitialization = FlashcardsEditorState(
    group: groups[0],
    flashcards: [
      createEditorFlashcard(
        key: 'flashcard0',
        doc: flashcards[0],
      ),
      createEditorFlashcard(
        key: 'flashcard1',
        doc: flashcards[1],
      ),
      createEditorFlashcard(
        key: 'flashcard2',
        doc: flashcards[2],
      ),
      createEditorFlashcard(
        key: 'flashcard3',
        doc: createFlashcard(groupId: 'g1'),
      ),
    ],
    keyCounter: 3,
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
      FlashcardsState(allFlashcards: flashcards),
    );
  });

  tearDown(() {
    reset(groupsBloc);
    reset(flashcardsBloc);
    reset(flashcardsEditorDialogs);
    reset(flashcardsEditorUtils);
  });

  blocTest(
    'initialize',
    build: () => bloc,
    act: (_) => bloc.add(FlashcardsEditorEventInitialize(groupId: 'g1')),
    expect: () => [stateAfterInitialization],
  );

  blocTest(
    'remove flashcard, confirmed',
    build: () => bloc,
    setUp: () {
      when(() => flashcardsEditorDialogs.askForDeleteConfirmation())
          .thenAnswer((_) async => true);
    },
    act: (_) {
      bloc.add(FlashcardsEditorEventInitialize(groupId: 'g1'));
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
    'remove flashcard, cancelled',
    build: () => bloc,
    setUp: () {
      when(() => flashcardsEditorDialogs.askForDeleteConfirmation())
          .thenAnswer((_) async => false);
    },
    act: (_) {
      bloc.add(FlashcardsEditorEventInitialize(groupId: 'g1'));
      bloc.add(FlashcardsEditorEventRemoveFlashcard(indexOfFlashcard: 1));
    },
    expect: () => [stateAfterInitialization],
  );

  blocTest(
    'save, no changes',
    build: () => bloc,
    setUp: () {
      when(() => flashcardsEditorDialogs.displayInfoAboutNoChanges())
          .thenAnswer((_) async => '');
      when(
        () => flashcardsEditorUtils.groupFlashcardsIntoAppropriateGroups(
          flashcards.getRange(0, 3).toList(),
          flashcards.getRange(0, 3).toList(),
        ),
      ).thenReturn(const FlashcardsEditorGroups(
        edited: [],
        added: [],
        removed: [],
      ));
      when(() => flashcardsEditorUtils.lookForIncorrectlyCompletedFlashcards(
          stateAfterInitialization.flashcardsWithoutLastOne)).thenReturn([]);
      when(() => flashcardsEditorUtils.lookForDuplicates(
          stateAfterInitialization.flashcardsWithoutLastOne)).thenReturn([]);
    },
    act: (_) {
      bloc.add(FlashcardsEditorEventInitialize(groupId: 'g1'));
      bloc.add(FlashcardsEditorEventSave());
    },
    verify: (_) {
      verify(() => flashcardsEditorDialogs.displayInfoAboutNoChanges())
          .called(1);
      verifyNever(
        () => flashcardsBloc.add(FlashcardsEventSaveMultipleActions(
          flashcardsToUpdate: const [],
          flashcardsToAdd: const [],
          idsOfFlashcardsToRemove: const [],
        )),
      );
    },
  );

  group('save edited and incorrectly completed flashcards', () {
    final List<Flashcard> editedFlashcards = [
      flashcards[0].copyWith(question: 'new question', answer: ''),
      flashcards[1].copyWith(question: 'new question', answer: 'new answer'),
    ];

    blocTest(
      'should not call save method',
      build: () => bloc,
      setUp: () {
        when(
          () => flashcardsEditorUtils.groupFlashcardsIntoAppropriateGroups(
            flashcards.getRange(0, 3).toList(),
            flashcards.getRange(0, 3).toList(),
          ),
        ).thenReturn(FlashcardsEditorGroups(
          edited: editedFlashcards,
          added: const [],
          removed: const [],
        ));
        when(
          () => flashcardsEditorUtils.lookForIncorrectlyCompletedFlashcards(
            stateAfterInitialization.flashcardsWithoutLastOne,
          ),
        ).thenReturn([editedFlashcards[0]]);
        when(
          () => flashcardsEditorDialogs.displayInfoAboutIncorrectFlashcards(),
        ).thenAnswer((_) async => '');
      },
      act: (_) {
        bloc.add(FlashcardsEditorEventInitialize(groupId: 'g1'));
        bloc.add(FlashcardsEditorEventSave());
      },
      verify: (_) {
        verify(
          () => flashcardsEditorDialogs.displayInfoAboutIncorrectFlashcards(),
        ).called(1);
        verifyNever(
          () => flashcardsBloc.add(FlashcardsEventSaveMultipleActions(
            flashcardsToUpdate: editedFlashcards,
            flashcardsToAdd: const [],
            idsOfFlashcardsToRemove: const [],
          )),
        );
      },
    );
  });

  group('save edited flashcards with duplicates', () {
    final List<Flashcard> editedFlashcards = [
      flashcards[0].copyWith(question: 'new question', answer: 'new answer'),
      flashcards[1].copyWith(question: 'new question', answer: 'new answer'),
    ];

    blocTest(
      'should not call save method',
      build: () => bloc,
      setUp: () {
        when(
          () => flashcardsEditorUtils.groupFlashcardsIntoAppropriateGroups(
            flashcards.getRange(0, 3).toList(),
            flashcards.getRange(0, 3).toList(),
          ),
        ).thenReturn(FlashcardsEditorGroups(
          edited: editedFlashcards,
          added: const [],
          removed: const [],
        ));
        when(
          () => flashcardsEditorUtils.lookForIncorrectlyCompletedFlashcards(
            stateAfterInitialization.flashcardsWithoutLastOne,
          ),
        ).thenReturn([]);
        when(
          () => flashcardsEditorUtils.lookForDuplicates(
            stateAfterInitialization.flashcardsWithoutLastOne,
          ),
        ).thenReturn(editedFlashcards);
        when(
          () => flashcardsEditorDialogs.displayInfoAboutDuplicates(),
        ).thenAnswer((_) async => '');
      },
      act: (_) {
        bloc.add(FlashcardsEditorEventInitialize(groupId: 'g1'));
        bloc.add(FlashcardsEditorEventSave());
      },
      verify: (_) {
        verify(
          () => flashcardsEditorDialogs.displayInfoAboutDuplicates(),
        ).called(1);
        verifyNever(
          () => flashcardsBloc.add(FlashcardsEventSaveMultipleActions(
            flashcardsToUpdate: editedFlashcards,
            flashcardsToAdd: const [],
            idsOfFlashcardsToRemove: const [],
          )),
        );
      },
    );
  });

  group('save added and incorrectly completed flashcards', () {
    final List<Flashcard> addedFlashcards = [
      createFlashcard(question: 'question', answer: 'answer'),
      createFlashcard(question: '', answer: 'answer 2'),
    ];

    blocTest(
      'should not call save method',
      build: () => bloc,
      setUp: () {
        when(
          () => flashcardsEditorUtils.groupFlashcardsIntoAppropriateGroups(
            flashcards.getRange(0, 3).toList(),
            flashcards.getRange(0, 3).toList(),
          ),
        ).thenReturn(FlashcardsEditorGroups(
          edited: const [],
          added: addedFlashcards,
          removed: const [],
        ));
        when(
          () => flashcardsEditorUtils.lookForIncorrectlyCompletedFlashcards(
            stateAfterInitialization.flashcardsWithoutLastOne,
          ),
        ).thenReturn([addedFlashcards[1]]);
        when(
          () => flashcardsEditorDialogs.displayInfoAboutIncorrectFlashcards(),
        ).thenAnswer((_) async => '');
      },
      act: (_) {
        bloc.add(FlashcardsEditorEventInitialize(groupId: 'g1'));
        bloc.add(FlashcardsEditorEventSave());
      },
      verify: (_) {
        verify(
          () => flashcardsEditorDialogs.displayInfoAboutIncorrectFlashcards(),
        ).called(1);
        verifyNever(
          () => flashcardsBloc.add(FlashcardsEventSaveMultipleActions(
            flashcardsToUpdate: const [],
            flashcardsToAdd: addedFlashcards,
            idsOfFlashcardsToRemove: const [],
          )),
        );
      },
    );
  });

  group('save added flashcards with duplicates', () {
    final List<Flashcard> addedFlashcards = [
      createFlashcard(question: 'question', answer: 'answer'),
      createFlashcard(question: 'question', answer: 'answer'),
    ];

    blocTest(
      'should not call save method',
      build: () => bloc,
      setUp: () {
        when(
          () => flashcardsEditorUtils.groupFlashcardsIntoAppropriateGroups(
            flashcards.getRange(0, 3).toList(),
            flashcards.getRange(0, 3).toList(),
          ),
        ).thenReturn(FlashcardsEditorGroups(
          edited: const [],
          added: addedFlashcards,
          removed: const [],
        ));
        when(
          () => flashcardsEditorUtils.lookForIncorrectlyCompletedFlashcards(
            stateAfterInitialization.flashcardsWithoutLastOne,
          ),
        ).thenReturn([]);
        when(
          () => flashcardsEditorUtils.lookForDuplicates(
            stateAfterInitialization.flashcardsWithoutLastOne,
          ),
        ).thenReturn(addedFlashcards);
        when(
          () => flashcardsEditorDialogs.displayInfoAboutDuplicates(),
        ).thenAnswer((_) async => '');
      },
      act: (_) {
        bloc.add(FlashcardsEditorEventInitialize(groupId: 'g1'));
        bloc.add(FlashcardsEditorEventSave());
      },
      verify: (_) {
        verify(
          () => flashcardsEditorDialogs.displayInfoAboutDuplicates(),
        ).called(1);
        verifyNever(
          () => flashcardsBloc.add(FlashcardsEventSaveMultipleActions(
            flashcardsToUpdate: const [],
            flashcardsToAdd: addedFlashcards,
            idsOfFlashcardsToRemove: const [],
          )),
        );
      },
    );
  });

  group('save correctly edited flashcards', () {
    final List<Flashcard> editedFlashcards = [
      flashcards[0].copyWith(question: 'question1', answer: 'answer1'),
      flashcards[1].copyWith(question: 'question2', answer: 'answer2'),
    ];

    setUp(() {
      when(
        () => flashcardsEditorUtils.groupFlashcardsIntoAppropriateGroups(
          flashcards.getRange(0, 3).toList(),
          flashcards.getRange(0, 3).toList(),
        ),
      ).thenReturn(FlashcardsEditorGroups(
        edited: editedFlashcards,
        added: const [],
        removed: const [],
      ));
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
      'operation cancelled',
      build: () => bloc,
      setUp: () {
        when(() => flashcardsEditorDialogs.askForSaveConfirmation())
            .thenAnswer((_) async => false);
      },
      act: (_) {
        bloc.add(FlashcardsEditorEventInitialize(groupId: 'g1'));
        bloc.add(FlashcardsEditorEventSave());
      },
      verify: (_) {
        verify(() => flashcardsEditorDialogs.askForSaveConfirmation())
            .called(1);
        verifyNever(
          () => flashcardsBloc.add(FlashcardsEventSaveMultipleActions(
            flashcardsToUpdate: editedFlashcards,
            flashcardsToAdd: const [],
            idsOfFlashcardsToRemove: const [],
          )),
        );
      },
    );

    blocTest(
      'operation confirmed',
      build: () => bloc,
      setUp: () {
        when(() => flashcardsEditorDialogs.askForSaveConfirmation())
            .thenAnswer((_) async => true);
      },
      act: (_) {
        bloc.add(FlashcardsEditorEventInitialize(groupId: 'g1'));
        bloc.add(FlashcardsEditorEventSave());
      },
      verify: (_) {
        verify(() => flashcardsEditorDialogs.askForSaveConfirmation())
            .called(1);
        verify(
          () => flashcardsBloc.add(FlashcardsEventSaveMultipleActions(
            flashcardsToUpdate: editedFlashcards,
            flashcardsToAdd: const [],
            idsOfFlashcardsToRemove: const [],
          )),
        ).called(1);
      },
    );
  });

  group('save correctly added flashcards', () {
    final List<Flashcard> addedFlashcards = [
      createFlashcard(question: 'question1', answer: 'answer1'),
      createFlashcard(question: 'question2', answer: 'answer2'),
    ];

    setUp(() {
      when(
        () => flashcardsEditorUtils.groupFlashcardsIntoAppropriateGroups(
          flashcards.getRange(0, 3).toList(),
          flashcards.getRange(0, 3).toList(),
        ),
      ).thenReturn(FlashcardsEditorGroups(
        edited: const [],
        added: addedFlashcards,
        removed: const [],
      ));
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
      'operation cancelled',
      build: () => bloc,
      setUp: () {
        when(() => flashcardsEditorDialogs.askForSaveConfirmation())
            .thenAnswer((_) async => false);
      },
      act: (_) {
        bloc.add(FlashcardsEditorEventInitialize(groupId: 'g1'));
        bloc.add(FlashcardsEditorEventSave());
      },
      verify: (_) {
        verify(() => flashcardsEditorDialogs.askForSaveConfirmation())
            .called(1);
        verifyNever(
          () => flashcardsBloc.add(FlashcardsEventSaveMultipleActions(
            flashcardsToUpdate: const [],
            flashcardsToAdd: addedFlashcards,
            idsOfFlashcardsToRemove: const [],
          )),
        );
      },
    );

    blocTest(
      'operation confirmed',
      build: () => bloc,
      setUp: () {
        when(() => flashcardsEditorDialogs.askForSaveConfirmation())
            .thenAnswer((_) async => true);
      },
      act: (_) {
        bloc.add(FlashcardsEditorEventInitialize(groupId: 'g1'));
        bloc.add(FlashcardsEditorEventSave());
      },
      verify: (_) {
        verify(() => flashcardsEditorDialogs.askForSaveConfirmation())
            .called(1);
        verify(
          () => flashcardsBloc.add(FlashcardsEventSaveMultipleActions(
            flashcardsToUpdate: const [],
            flashcardsToAdd: addedFlashcards,
            idsOfFlashcardsToRemove: const [],
          )),
        ).called(1);
      },
    );
  });

  group('save removed flashcards', () {
    final List<String> removedFlashcards = ['f1', 'f2'];

    setUp(() {
      when(
        () => flashcardsEditorUtils.groupFlashcardsIntoAppropriateGroups(
          flashcards.getRange(0, 3).toList(),
          flashcards.getRange(0, 3).toList(),
        ),
      ).thenReturn(FlashcardsEditorGroups(
        edited: const [],
        added: const [],
        removed: removedFlashcards,
      ));
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
      'operation cancelled',
      build: () => bloc,
      setUp: () {
        when(() => flashcardsEditorDialogs.askForSaveConfirmation())
            .thenAnswer((_) async => false);
      },
      act: (_) {
        bloc.add(FlashcardsEditorEventInitialize(groupId: 'g1'));
        bloc.add(FlashcardsEditorEventSave());
      },
      verify: (_) {
        verify(() => flashcardsEditorDialogs.askForSaveConfirmation())
            .called(1);
        verifyNever(
          () => flashcardsBloc.add(FlashcardsEventSaveMultipleActions(
            flashcardsToUpdate: const [],
            flashcardsToAdd: const [],
            idsOfFlashcardsToRemove: removedFlashcards,
          )),
        );
      },
    );

    blocTest(
      'operation confirmed',
      build: () => bloc,
      setUp: () {
        when(() => flashcardsEditorDialogs.askForSaveConfirmation())
            .thenAnswer((_) async => true);
      },
      act: (_) {
        bloc.add(FlashcardsEditorEventInitialize(groupId: 'g1'));
        bloc.add(FlashcardsEditorEventSave());
      },
      verify: (_) {
        verify(() => flashcardsEditorDialogs.askForSaveConfirmation())
            .called(1);
        verify(
          () => flashcardsBloc.add(FlashcardsEventSaveMultipleActions(
            flashcardsToUpdate: const [],
            flashcardsToAdd: const [],
            idsOfFlashcardsToRemove: removedFlashcards,
          )),
        ).called(1);
      },
    );
  });
}

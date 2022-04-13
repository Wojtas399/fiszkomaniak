import 'package:bloc_test/bloc_test.dart';
import 'package:fiszkomaniak/core/flashcards/flashcards_bloc.dart';
import 'package:fiszkomaniak/core/flashcards/flashcards_event.dart';
import 'package:fiszkomaniak/core/flashcards/flashcards_state.dart';
import 'package:fiszkomaniak/core/groups/groups_bloc.dart';
import 'package:fiszkomaniak/core/groups/groups_state.dart';
import 'package:fiszkomaniak/features/flashcards_editor/bloc/flashcards_editor_bloc.dart';
import 'package:fiszkomaniak/features/flashcards_editor/bloc/flashcards_editor_event.dart';
import 'package:fiszkomaniak/features/flashcards_editor/bloc/flashcards_editor_state.dart';
import 'package:fiszkomaniak/models/flashcard_model.dart';
import 'package:fiszkomaniak/models/group_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGroupsBloc extends Mock implements GroupsBloc {}

class MockFlashcardsBloc extends Mock implements FlashcardsBloc {}

void main() {
  final GroupsBloc groupsBloc = MockGroupsBloc();
  final FlashcardsBloc flashcardsBloc = MockFlashcardsBloc();
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
      EditorFlashcard(
        key: 'flashcard0',
        doc: flashcards[0],
      ),
      EditorFlashcard(
        key: 'flashcard1',
        doc: flashcards[1],
      ),
      EditorFlashcard(
        key: 'flashcard2',
        doc: flashcards[2],
      ),
      EditorFlashcard(
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
  });

  blocTest(
    'initialize',
    build: () => bloc,
    act: (_) => bloc.add(FlashcardsEditorEventInitialize(groupId: 'g1')),
    expect: () => [stateAfterInitialization],
  );

  blocTest(
    'add flashcard, group exists',
    build: () => bloc,
    act: (_) {
      bloc.add(FlashcardsEditorEventInitialize(groupId: 'g1'));
      bloc.add(FlashcardsEditorEventAddFlashcard());
    },
    expect: () => [
      stateAfterInitialization,
      bloc.state.copyWith(
        flashcards: [
          ...stateAfterInitialization.flashcards,
          EditorFlashcard(
            key: 'flashcard4',
            doc: createFlashcard(groupId: 'g1'),
          ),
        ],
      ),
    ],
  );

  blocTest(
    'add flashcard, group does not exist',
    build: () => bloc,
    act: (_) => bloc.add(FlashcardsEditorEventAddFlashcard()),
    expect: () => [],
  );

  blocTest(
    'remove flashcard',
    build: () => bloc,
    act: (_) {
      bloc.add(FlashcardsEditorEventInitialize(groupId: 'g1'));
      bloc.add(FlashcardsEditorEventRemoveFlashcard(indexOfFlashcard: 1));
    },
    expect: () => [
      stateAfterInitialization,
      bloc.state.copyWith(
        flashcards: [
          stateAfterInitialization.flashcards[0],
          stateAfterInitialization.flashcards[2],
          stateAfterInitialization.flashcards[3],
        ],
      ),
    ],
  );

  blocTest(
    'question changed, last item',
    build: () => bloc,
    act: (_) {
      bloc.add(FlashcardsEditorEventInitialize(groupId: 'g1'));
      bloc.add(FlashcardsEditorEventQuestionChanged(
        indexOfFlashcard: 3,
        question: 'NEW question',
      ));
    },
    expect: () => [
      stateAfterInitialization,
      bloc.state.copyWith(flashcards: [
        stateAfterInitialization.flashcards[0],
        stateAfterInitialization.flashcards[1],
        stateAfterInitialization.flashcards[2],
        stateAfterInitialization.flashcards[3].copyWith(
          doc: stateAfterInitialization.flashcards[3].doc.copyWith(
            question: 'NEW question',
          ),
        ),
      ], keyCounter: 3),
      bloc.state.copyWith(flashcards: [
        stateAfterInitialization.flashcards[0],
        stateAfterInitialization.flashcards[1],
        stateAfterInitialization.flashcards[2],
        stateAfterInitialization.flashcards[3].copyWith(
          doc: stateAfterInitialization.flashcards[3].doc.copyWith(
            question: 'NEW question',
          ),
        ),
        EditorFlashcard(
          key: 'flashcard4',
          doc: createFlashcard(groupId: 'g1'),
        ),
      ], keyCounter: 4),
    ],
  );

  blocTest(
    'question changed, second to last item',
    build: () => bloc,
    act: (_) {
      bloc.add(FlashcardsEditorEventInitialize(groupId: 'g1'));
      bloc.add(FlashcardsEditorEventQuestionChanged(
        indexOfFlashcard: 2,
        question: 'NEW question',
      ));
    },
    expect: () => [
      stateAfterInitialization,
      bloc.state.copyWith(flashcards: [
        stateAfterInitialization.flashcards[0],
        stateAfterInitialization.flashcards[1],
        stateAfterInitialization.flashcards[2].copyWith(
          doc: stateAfterInitialization.flashcards[2].doc.copyWith(
            question: 'NEW question',
          ),
        ),
        stateAfterInitialization.flashcards[3],
      ], keyCounter: 3),
    ],
  );

  blocTest(
    'question changed, second to last item, question and answer empty',
    build: () => bloc,
    act: (_) {
      bloc.add(FlashcardsEditorEventInitialize(groupId: 'g1'));
      bloc.add(FlashcardsEditorEventAnswerChanged(
        indexOfFlashcard: 2,
        answer: '',
      ));
      bloc.add(FlashcardsEditorEventQuestionChanged(
        indexOfFlashcard: 2,
        question: '',
      ));
    },
    expect: () => [
      stateAfterInitialization,
      bloc.state.copyWith(
        flashcards: [
          stateAfterInitialization.flashcards[0],
          stateAfterInitialization.flashcards[1],
          stateAfterInitialization.flashcards[2].copyWith(
            doc: stateAfterInitialization.flashcards[2].doc.copyWith(
              answer: '',
            ),
          ),
          stateAfterInitialization.flashcards[3],
        ],
        keyCounter: 3,
      ),
      bloc.state.copyWith(
        flashcards: [
          stateAfterInitialization.flashcards[0],
          stateAfterInitialization.flashcards[1],
          stateAfterInitialization.flashcards[2].copyWith(
            doc: stateAfterInitialization.flashcards[2].doc.copyWith(
              answer: '',
              question: '',
            ),
          ),
          stateAfterInitialization.flashcards[3],
        ],
        keyCounter: 3,
      ),
    ],
  );

  blocTest(
    'question changed',
    build: () => bloc,
    act: (_) {
      bloc.add(FlashcardsEditorEventInitialize(groupId: 'g1'));
      bloc.add(FlashcardsEditorEventQuestionChanged(
        indexOfFlashcard: 0,
        question: 'NEW question',
      ));
    },
    expect: () => [
      stateAfterInitialization,
      bloc.state.copyWith(flashcards: [
        stateAfterInitialization.flashcards[0].copyWith(
          doc: stateAfterInitialization.flashcards[0].doc.copyWith(
            question: 'NEW question',
          ),
        ),
        stateAfterInitialization.flashcards[1],
        stateAfterInitialization.flashcards[2],
        stateAfterInitialization.flashcards[3]
      ], keyCounter: 3),
    ],
  );

  blocTest(
    'answer changed, last item',
    build: () => bloc,
    act: (_) {
      bloc.add(FlashcardsEditorEventInitialize(groupId: 'g1'));
      bloc.add(FlashcardsEditorEventAnswerChanged(
        indexOfFlashcard: 3,
        answer: 'NEW answer',
      ));
    },
    expect: () => [
      stateAfterInitialization,
      bloc.state.copyWith(flashcards: [
        stateAfterInitialization.flashcards[0],
        stateAfterInitialization.flashcards[1],
        stateAfterInitialization.flashcards[2],
        stateAfterInitialization.flashcards[3].copyWith(
          doc: stateAfterInitialization.flashcards[3].doc.copyWith(
            answer: 'NEW answer',
          ),
        ),
      ], keyCounter: 3),
      bloc.state.copyWith(flashcards: [
        stateAfterInitialization.flashcards[0],
        stateAfterInitialization.flashcards[1],
        stateAfterInitialization.flashcards[2],
        stateAfterInitialization.flashcards[3].copyWith(
          doc: stateAfterInitialization.flashcards[3].doc.copyWith(
            answer: 'NEW answer',
          ),
        ),
        EditorFlashcard(
          key: 'flashcard4',
          doc: createFlashcard(groupId: 'g1'),
        ),
      ], keyCounter: 4),
    ],
  );

  blocTest(
    'answer changed, second to last item',
    build: () => bloc,
    act: (_) {
      bloc.add(FlashcardsEditorEventInitialize(groupId: 'g1'));
      bloc.add(FlashcardsEditorEventAnswerChanged(
        indexOfFlashcard: 2,
        answer: 'NEW answer',
      ));
    },
    expect: () => [
      stateAfterInitialization,
      bloc.state.copyWith(
        flashcards: [
          stateAfterInitialization.flashcards[0],
          stateAfterInitialization.flashcards[1],
          stateAfterInitialization.flashcards[2].copyWith(
            doc: stateAfterInitialization.flashcards[2].doc.copyWith(
              answer: 'NEW answer',
            ),
          ),
          stateAfterInitialization.flashcards[3]
        ],
        keyCounter: 3,
      ),
    ],
  );

  blocTest(
    'answer changed, second to last item, question and answer empty',
    build: () => bloc,
    act: (_) {
      bloc.add(FlashcardsEditorEventInitialize(groupId: 'g1'));
      bloc.add(FlashcardsEditorEventQuestionChanged(
        indexOfFlashcard: 2,
        question: '',
      ));
      bloc.add(FlashcardsEditorEventAnswerChanged(
        indexOfFlashcard: 2,
        answer: '',
      ));
    },
    expect: () => [
      stateAfterInitialization,
      bloc.state.copyWith(flashcards: [
        stateAfterInitialization.flashcards[0],
        stateAfterInitialization.flashcards[1],
        stateAfterInitialization.flashcards[2].copyWith(
          doc: stateAfterInitialization.flashcards[2].doc.copyWith(
            question: '',
          ),
        ),
        stateAfterInitialization.flashcards[3]
      ], keyCounter: 3),
      bloc.state.copyWith(
        flashcards: [
          stateAfterInitialization.flashcards[0],
          stateAfterInitialization.flashcards[1],
          stateAfterInitialization.flashcards[2].copyWith(
            doc: stateAfterInitialization.flashcards[2].doc.copyWith(
              question: '',
              answer: '',
            ),
          ),
          stateAfterInitialization.flashcards[3]
        ],
        keyCounter: 3,
      ),
    ],
  );

  blocTest(
    'answer changed',
    build: () => bloc,
    act: (_) {
      bloc.add(FlashcardsEditorEventInitialize(groupId: 'g1'));
      bloc.add(FlashcardsEditorEventAnswerChanged(
        indexOfFlashcard: 0,
        answer: 'NEW answer',
      ));
    },
    expect: () => [
      stateAfterInitialization,
      bloc.state.copyWith(
        flashcards: [
          stateAfterInitialization.flashcards[0].copyWith(
            doc: stateAfterInitialization.flashcards[0].doc.copyWith(
              answer: 'NEW answer',
            ),
          ),
          stateAfterInitialization.flashcards[1],
          stateAfterInitialization.flashcards[2],
          stateAfterInitialization.flashcards[3],
        ],
        keyCounter: 3,
      ),
    ],
  );

  blocTest(
    'save, flashcard edited',
    build: () => bloc,
    act: (_) {
      bloc.add(FlashcardsEditorEventInitialize(groupId: 'g1'));
      bloc.add(FlashcardsEditorEventQuestionChanged(
        indexOfFlashcard: 0,
        question: 'question',
      ));
      bloc.add(FlashcardsEditorEventAnswerChanged(
        indexOfFlashcard: 0,
        answer: 'answer',
      ));
      bloc.add(FlashcardsEditorEventSave());
    },
    verify: (_) {
      verify(
        () => flashcardsBloc.add(FlashcardsEventSave(
          flashcardsToUpdate: [
            createFlashcard(
              id: 'f1',
              question: 'question',
              answer: 'answer',
              groupId: 'g1',
            ),
          ],
          flashcardsToAdd: const [],
          idsOfFlashcardsToRemove: const [],
        )),
      ).called(1);
    },
  );

  blocTest(
    'save, flashcard added',
    build: () => bloc,
    act: (_) {
      bloc.add(FlashcardsEditorEventInitialize(groupId: 'g1'));
      bloc.add(FlashcardsEditorEventQuestionChanged(
        indexOfFlashcard: 3,
        question: 'question',
      ));
      bloc.add(FlashcardsEditorEventAnswerChanged(
        indexOfFlashcard: 3,
        answer: 'answer',
      ));
      bloc.add(FlashcardsEditorEventSave());
    },
    verify: (_) {
      verify(
        () => flashcardsBloc.add(FlashcardsEventSave(
          flashcardsToUpdate: const [],
          flashcardsToAdd: [
            createFlashcard(
              id: '',
              question: 'question',
              answer: 'answer',
              groupId: 'g1',
            ),
          ],
          idsOfFlashcardsToRemove: const [],
        )),
      ).called(1);
    },
  );

  blocTest(
    'save, flashcard removed',
    build: () => bloc,
    act: (_) {
      bloc.add(FlashcardsEditorEventInitialize(groupId: 'g1'));
      bloc.add(FlashcardsEditorEventQuestionChanged(
        indexOfFlashcard: 0,
        question: '',
      ));
      bloc.add(FlashcardsEditorEventAnswerChanged(
        indexOfFlashcard: 0,
        answer: '',
      ));
      bloc.add(FlashcardsEditorEventSave());
    },
    verify: (_) {
      verify(
        () => flashcardsBloc.add(
          FlashcardsEventSave(
            flashcardsToUpdate: const [],
            flashcardsToAdd: const [],
            idsOfFlashcardsToRemove: const ['f1'],
          ),
        ),
      ).called(1);
    },
  );

  blocTest(
    'save, empty flashcards should be ignored or removed',
    build: () => bloc,
    act: (_) {
      bloc.add(FlashcardsEditorEventInitialize(groupId: 'g1'));
      bloc.add(FlashcardsEditorEventQuestionChanged(
        indexOfFlashcard: 0,
        question: '',
      ));
      bloc.add(FlashcardsEditorEventAnswerChanged(
        indexOfFlashcard: 0,
        answer: '',
      ));
      bloc.add(FlashcardsEditorEventQuestionChanged(
        indexOfFlashcard: 3,
        question: 'question',
      ));
      bloc.add(FlashcardsEditorEventAnswerChanged(
        indexOfFlashcard: 3,
        answer: 'answer',
      ));
      bloc.add(FlashcardsEditorEventQuestionChanged(
        indexOfFlashcard: 3,
        question: '',
      ));
      bloc.add(FlashcardsEditorEventAnswerChanged(
        indexOfFlashcard: 3,
        answer: '',
      ));
      bloc.add(FlashcardsEditorEventSave());
    },
    verify: (_) {
      verify(
        () => flashcardsBloc.add(
          FlashcardsEventSave(
            flashcardsToUpdate: const [],
            flashcardsToAdd: const [],
            idsOfFlashcardsToRemove: const ['f1'],
          ),
        ),
      ).called(1);
    },
  );
}

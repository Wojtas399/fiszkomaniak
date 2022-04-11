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
      question: 'question',
      answer: 'answer',
    ),
    createFlashcard(id: 'f2', groupId: 'g2'),
    createFlashcard(
      id: 'f3',
      groupId: 'g1',
      question: 'WoW',
      answer: 'HMMMM',
    ),
  ];
  final FlashcardsEditorState stateAfterInitialization = FlashcardsEditorState(
    group: groups[0],
    flashcards: [
      createFlashcardsEditorItemParams(
        index: 0,
        isNew: false,
        doc: flashcards[0],
      ),
      createFlashcardsEditorItemParams(
        index: 1,
        isNew: false,
        doc: flashcards[2],
      ),
      createFlashcardsEditorItemParams(
        index: 2,
        doc: createFlashcard(groupId: 'g1'),
      ),
    ],
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
          FlashcardsEditorItemParams(
            index: 3,
            isNew: true,
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
        indexOfFlashcard: 2,
        question: 'NEW question',
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
              question: 'NEW question',
            ),
          ),
        ],
      ),
      bloc.state.copyWith(
        flashcards: [
          stateAfterInitialization.flashcards[0],
          stateAfterInitialization.flashcards[1],
          stateAfterInitialization.flashcards[2].copyWith(
            doc: stateAfterInitialization.flashcards[2].doc.copyWith(
              question: 'NEW question',
            ),
          ),
          createFlashcardsEditorItemParams(
            index: 3,
            doc: createFlashcard(groupId: 'g1'),
          ),
        ],
      ),
    ],
  );

  blocTest(
    'question changed, second to last item',
    build: () => bloc,
    act: (_) {
      bloc.add(FlashcardsEditorEventInitialize(groupId: 'g1'));
      bloc.add(FlashcardsEditorEventQuestionChanged(
        indexOfFlashcard: 1,
        question: 'NEW question',
      ));
    },
    expect: () => [
      stateAfterInitialization,
      bloc.state.copyWith(
        flashcards: [
          stateAfterInitialization.flashcards[0],
          stateAfterInitialization.flashcards[1].copyWith(
            doc: stateAfterInitialization.flashcards[1].doc.copyWith(
              question: 'NEW question',
            ),
          ),
          stateAfterInitialization.flashcards[2]
        ],
      ),
    ],
  );

  blocTest(
    'question changed, second to last item, question and answer empty',
    build: () => bloc,
    act: (_) {
      bloc.add(FlashcardsEditorEventInitialize(groupId: 'g1'));
      bloc.add(FlashcardsEditorEventAnswerChanged(
        indexOfFlashcard: 1,
        answer: '',
      ));
      bloc.add(FlashcardsEditorEventQuestionChanged(
        indexOfFlashcard: 1,
        question: '',
      ));
    },
    expect: () => [
      stateAfterInitialization,
      bloc.state.copyWith(
        flashcards: [
          stateAfterInitialization.flashcards[0],
          stateAfterInitialization.flashcards[1].copyWith(
            doc: stateAfterInitialization.flashcards[1].doc.copyWith(
              answer: '',
            ),
          ),
          stateAfterInitialization.flashcards[2]
        ],
      ),
      bloc.state.copyWith(
        flashcards: [
          stateAfterInitialization.flashcards[0],
          stateAfterInitialization.flashcards[1].copyWith(
            doc: stateAfterInitialization.flashcards[1].doc.copyWith(
              answer: '',
              question: '',
            ),
          ),
          stateAfterInitialization.flashcards[2]
        ],
      ),
      bloc.state.copyWith(
        flashcards: [
          stateAfterInitialization.flashcards[0],
          stateAfterInitialization.flashcards[1].copyWith(
            doc: stateAfterInitialization.flashcards[1].doc.copyWith(
              answer: '',
              question: '',
            ),
          ),
        ],
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
      bloc.state.copyWith(
        flashcards: [
          stateAfterInitialization.flashcards[0].copyWith(
            doc: stateAfterInitialization.flashcards[0].doc.copyWith(
              question: 'NEW question',
            ),
          ),
          stateAfterInitialization.flashcards[1],
          stateAfterInitialization.flashcards[2]
        ],
      ),
    ],
  );

  blocTest(
    'answer changed, last item',
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
        ],
      ),
      bloc.state.copyWith(
        flashcards: [
          stateAfterInitialization.flashcards[0],
          stateAfterInitialization.flashcards[1],
          stateAfterInitialization.flashcards[2].copyWith(
            doc: stateAfterInitialization.flashcards[2].doc.copyWith(
              answer: 'NEW answer',
            ),
          ),
          createFlashcardsEditorItemParams(
            index: 3,
            doc: createFlashcard(groupId: 'g1'),
          ),
        ],
      ),
    ],
  );

  blocTest(
    'answer changed, second to last item',
    build: () => bloc,
    act: (_) {
      bloc.add(FlashcardsEditorEventInitialize(groupId: 'g1'));
      bloc.add(FlashcardsEditorEventAnswerChanged(
        indexOfFlashcard: 1,
        answer: 'NEW answer',
      ));
    },
    expect: () => [
      stateAfterInitialization,
      bloc.state.copyWith(
        flashcards: [
          stateAfterInitialization.flashcards[0],
          stateAfterInitialization.flashcards[1].copyWith(
            doc: stateAfterInitialization.flashcards[1].doc.copyWith(
              answer: 'NEW answer',
            ),
          ),
          stateAfterInitialization.flashcards[2]
        ],
      ),
    ],
  );

  blocTest(
    'answer changed, second to last item, question and answer empty',
    build: () => bloc,
    act: (_) {
      bloc.add(FlashcardsEditorEventInitialize(groupId: 'g1'));
      bloc.add(FlashcardsEditorEventQuestionChanged(
        indexOfFlashcard: 1,
        question: '',
      ));
      bloc.add(FlashcardsEditorEventAnswerChanged(
        indexOfFlashcard: 1,
        answer: '',
      ));
    },
    expect: () => [
      stateAfterInitialization,
      bloc.state.copyWith(
        flashcards: [
          stateAfterInitialization.flashcards[0],
          stateAfterInitialization.flashcards[1].copyWith(
            doc: stateAfterInitialization.flashcards[1].doc.copyWith(
              question: '',
            ),
          ),
          stateAfterInitialization.flashcards[2]
        ],
      ),
      bloc.state.copyWith(
        flashcards: [
          stateAfterInitialization.flashcards[0],
          stateAfterInitialization.flashcards[1].copyWith(
            doc: stateAfterInitialization.flashcards[1].doc.copyWith(
              question: '',
              answer: '',
            ),
          ),
          stateAfterInitialization.flashcards[2]
        ],
      ),
      bloc.state.copyWith(
        flashcards: [
          stateAfterInitialization.flashcards[0],
          stateAfterInitialization.flashcards[1].copyWith(
            doc: stateAfterInitialization.flashcards[1].doc.copyWith(
              question: '',
              answer: '',
            ),
          ),
        ],
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
          stateAfterInitialization.flashcards[2]
        ],
      ),
    ],
  );

  blocTest(
    'save',
    build: () => bloc,
    act: (_) {
      bloc.add(FlashcardsEditorEventInitialize(groupId: 'g1'));
      bloc.add(FlashcardsEditorEventQuestionChanged(
        indexOfFlashcard: 2,
        question: 'question',
      ));
      bloc.add(FlashcardsEditorEventAnswerChanged(
        indexOfFlashcard: 2,
        answer: 'answer',
      ));
      bloc.add(FlashcardsEditorEventSave());
    },
    verify: (_) {
      verify(
        () => flashcardsBloc.add(
          FlashcardsEventAddFlashcards(
            flashcards: [
              stateAfterInitialization.flashcards[2]
                  .copyWith(
                    doc: stateAfterInitialization.flashcards[2].doc.copyWith(
                      question: 'question',
                      answer: 'answer',
                    ),
                  )
                  .doc,
            ],
          ),
        ),
      ).called(1);
    },
  );
}

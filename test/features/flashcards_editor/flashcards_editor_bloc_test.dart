import 'package:bloc_test/bloc_test.dart';
import 'package:fiszkomaniak/domain/entities/flashcard.dart';
import 'package:fiszkomaniak/domain/entities/group.dart';
import 'package:fiszkomaniak/domain/use_cases/flashcards/save_edited_flashcards_use_case.dart';
import 'package:fiszkomaniak/domain/use_cases/groups/get_group_use_case.dart';
import 'package:fiszkomaniak/features/flashcards_editor/bloc/flashcards_editor_bloc.dart';
import 'package:fiszkomaniak/features/flashcards_editor/bloc/flashcards_editor_event.dart';
import 'package:fiszkomaniak/features/flashcards_editor/bloc/flashcards_editor_state.dart';
import 'package:fiszkomaniak/features/flashcards_editor/bloc/flashcards_editor_utils.dart';
import 'package:fiszkomaniak/features/flashcards_editor/flashcards_editor_dialogs.dart';
import 'package:fiszkomaniak/models/bloc_status.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGetGroupUseCase extends Mock implements GetGroupUseCase {}

class MockSaveEditedFlashcardsUseCase extends Mock
    implements SaveEditedFlashcardsUseCase {}

class MockFlashcardsEditorDialogs extends Mock
    implements FlashcardsEditorDialogs {}

class MockFlashcardsEditorUtils extends Mock implements FlashcardsEditorUtils {}

void main() {
  final getGroupUseCase = MockGetGroupUseCase();
  final saveEditedFlashcardsUseCase = MockSaveEditedFlashcardsUseCase();
  final flashcardsEditorDialogs = MockFlashcardsEditorDialogs();
  final flashcardsEditorUtils = MockFlashcardsEditorUtils();

  FlashcardsEditorBloc createBloc({
    BlocStatus status = const BlocStatusInitial(),
    Group? group,
    List<EditorFlashcard> editorFlashcards = const [],
    int keyCounter = 0,
  }) {
    return FlashcardsEditorBloc(
      getGroupUseCase: getGroupUseCase,
      saveEditedFlashcardsUseCase: saveEditedFlashcardsUseCase,
      flashcardsEditorDialogs: flashcardsEditorDialogs,
      flashcardsEditorUtils: flashcardsEditorUtils,
      status: status,
      group: group,
      editorFlashcards: editorFlashcards,
      keyCounter: keyCounter,
    );
  }

  tearDown(() {
    reset(getGroupUseCase);
    reset(saveEditedFlashcardsUseCase);
    reset(flashcardsEditorDialogs);
    reset(flashcardsEditorUtils);
  });

  group(
    'initialize',
    () {
      final List<Flashcard> flashcards = [
        createFlashcard(index: 0, question: 'q0', answer: 'a0'),
        createFlashcard(index: 1, question: 'q1', answer: 'a1'),
        createFlashcard(index: 2, question: 'q2', answer: 'a2'),
      ];
      final Group group = createGroup(id: 'g1', flashcards: flashcards);
      final List<EditorFlashcard> editorFlashcards = [
        createEditorFlashcard(key: 'f0', question: 'q0', answer: 'a0'),
        createEditorFlashcard(key: 'f1', question: 'q1', answer: 'a1'),
        createEditorFlashcard(key: 'f2', question: 'q2', answer: 'a2'),
      ];

      blocTest(
        'should load group and create initial editor flashcards',
        build: () => createBloc(),
        setUp: () {
          when(
            () => getGroupUseCase.execute(groupId: 'g1'),
          ).thenAnswer((_) => Stream.value(group));
          when(
            () => flashcardsEditorUtils.createInitialEditorFlashcards(
              flashcards,
            ),
          ).thenReturn(editorFlashcards);
        },
        act: (FlashcardsEditorBloc bloc) {
          bloc.add(FlashcardsEditorEventInitialize(groupId: 'g1'));
        },
        expect: () => [
          FlashcardsEditorState(
            status: const BlocStatusComplete<FlashcardsEditorInfoType>(),
            group: group,
            editorFlashcards: editorFlashcards,
            keyCounter: 2,
          ),
        ],
      );
    },
  );

  group(
    'remove flashcard',
    () {
      final List<EditorFlashcard> editorFlashcards = [
        createEditorFlashcard(key: 'f0', question: 'q0', answer: 'a0'),
        createEditorFlashcard(key: 'f1', question: 'q1', answer: 'a1'),
      ];

      blocTest(
        'confirmed, should remove flashcard at given index',
        build: () => createBloc(
          editorFlashcards: editorFlashcards,
          keyCounter: 1,
        ),
        setUp: () {
          when(
            () => flashcardsEditorDialogs.askForDeleteConfirmation(),
          ).thenAnswer((_) async => true);
        },
        act: (FlashcardsEditorBloc bloc) {
          bloc.add(FlashcardsEditorEventRemoveFlashcard(flashcardIndex: 1));
        },
        expect: () => [
          FlashcardsEditorState(
            status: const BlocStatusComplete<FlashcardsEditorInfoType>(),
            group: null,
            editorFlashcards: [editorFlashcards[0]],
            keyCounter: 1,
          ),
        ],
      );

      blocTest(
        'cancelled, should not remove flashcard at given index',
        build: () => createBloc(
          editorFlashcards: editorFlashcards,
          keyCounter: 1,
        ),
        setUp: () {
          when(
            () => flashcardsEditorDialogs.askForDeleteConfirmation(),
          ).thenAnswer((_) async => false);
        },
        act: (FlashcardsEditorBloc bloc) {
          bloc.add(FlashcardsEditorEventRemoveFlashcard(flashcardIndex: 1));
        },
        expect: () => [],
      );

      blocTest(
        'should remove flashcard and add new empty flashcard if there is only one flashcard in list',
        build: () => createBloc(editorFlashcards: [editorFlashcards[0]]),
        setUp: () {
          when(
            () => flashcardsEditorDialogs.askForDeleteConfirmation(),
          ).thenAnswer((_) async => true);
          when(
            () => flashcardsEditorUtils.addNewEditorFlashcard([], 0),
          ).thenReturn([createEditorFlashcard(key: 'flashcard0')]);
        },
        act: (FlashcardsEditorBloc bloc) {
          bloc.add(FlashcardsEditorEventRemoveFlashcard(flashcardIndex: 0));
        },
        expect: () => [
          FlashcardsEditorState(
            status: const BlocStatusComplete<FlashcardsEditorInfoType>(),
            group: null,
            editorFlashcards: [createEditorFlashcard(key: 'flashcard0')],
            keyCounter: 0,
          ),
        ],
      );
    },
  );

  group(
    'value changed, edited flashcard is the last one',
    () {
      final List<EditorFlashcard> editorFlashcards = [
        createEditorFlashcard(
          key: 'f0',
          question: 'q0',
          answer: 'a0',
          completionStatus: EditorFlashcardCompletionStatus.complete,
        ),
        createEditorFlashcard(
          key: 'f1',
          question: 'q1',
          answer: 'a1',
          completionStatus: EditorFlashcardCompletionStatus.complete,
        ),
      ];
      final List<EditorFlashcard> updatedEditorFlashcards = [
        editorFlashcards[0],
        editorFlashcards[1].copyWith(question: 'question1'),
      ];
      final EditorFlashcard newEditorFlashcard = createEditorFlashcard(
        key: 'f2',
        question: '',
        answer: '',
      );

      blocTest(
        'should updated edited flashcard and should add new flashcard',
        build: () => createBloc(
          editorFlashcards: editorFlashcards,
          keyCounter: 1,
        ),
        setUp: () {
          when(
            () => flashcardsEditorUtils
                .removeEmptyEditorFlashcardsApartFromLastAndEditedOne(
              updatedEditorFlashcards,
              1,
            ),
          ).thenReturn(updatedEditorFlashcards);
          when(
            () => flashcardsEditorUtils.addNewEditorFlashcard(
              updatedEditorFlashcards,
              2,
            ),
          ).thenReturn([
            ...updatedEditorFlashcards,
            newEditorFlashcard,
          ]);
        },
        act: (FlashcardsEditorBloc bloc) {
          bloc.add(
            FlashcardsEditorEventValueChanged(
              flashcardIndex: 1,
              question: 'question1',
            ),
          );
        },
        expect: () => [
          FlashcardsEditorState(
            status: const BlocStatusComplete<FlashcardsEditorInfoType>(),
            group: null,
            editorFlashcards: [...updatedEditorFlashcards, newEditorFlashcard],
            keyCounter: 2,
          ),
        ],
      );
    },
  );

  group(
    'value changed, there are flashcards marked as incomplete',
    () {
      final List<EditorFlashcard> editorFlashcards = [
        createEditorFlashcard(
          key: 'f0',
          question: 'q0',
          answer: 'a0',
          completionStatus: EditorFlashcardCompletionStatus.incomplete,
        ),
        createEditorFlashcard(
          key: 'f1',
          question: 'q1',
          answer: 'a1',
          completionStatus: EditorFlashcardCompletionStatus.complete,
        ),
      ];
      final List<EditorFlashcard> updatedEditorFlashcards = [
        editorFlashcards[0].copyWith(question: 'question1'),
        editorFlashcards[1],
      ];

      blocTest(
        'should updated edited flashcard and should update completion statuses in flashcards marked as incomplete',
        build: () => createBloc(
          editorFlashcards: editorFlashcards,
          keyCounter: 1,
        ),
        setUp: () {
          when(
            () => flashcardsEditorUtils
                .removeEmptyEditorFlashcardsApartFromLastAndEditedOne(
              updatedEditorFlashcards,
              0,
            ),
          ).thenReturn(updatedEditorFlashcards);
          when(
            () => flashcardsEditorUtils
                .updateCompletionStatusInEditorFlashcardsMarkedAsIncomplete(
              updatedEditorFlashcards,
            ),
          ).thenReturn([
            updatedEditorFlashcards[0].copyWith(
              completionStatus: EditorFlashcardCompletionStatus.complete,
            ),
            updatedEditorFlashcards[1],
          ]);
        },
        act: (FlashcardsEditorBloc bloc) {
          bloc.add(
            FlashcardsEditorEventValueChanged(
              flashcardIndex: 0,
              question: 'question1',
            ),
          );
        },
        expect: () => [
          FlashcardsEditorState(
            status: const BlocStatusComplete<FlashcardsEditorInfoType>(),
            group: null,
            editorFlashcards: [
              updatedEditorFlashcards[0].copyWith(
                completionStatus: EditorFlashcardCompletionStatus.complete,
              ),
              updatedEditorFlashcards[1],
            ],
            keyCounter: 1,
          ),
        ],
      );
    },
  );

  group(
    'save',
    () {
      final List<EditorFlashcard> editorFlashcards = [
        createEditorFlashcard(key: 'f0', question: 'q0', answer: 'a0'),
        createEditorFlashcard(),
      ];

      blocTest(
        'should emit no changes info when editor flashcards are same as group flashcards',
        build: () => createBloc(
          group: createGroup(),
          editorFlashcards: editorFlashcards,
        ),
        setUp: () {
          when(
            () =>
                flashcardsEditorUtils.areEditorFlashcardsSameAsGroupFlashcards(
              [],
              [editorFlashcards[0]],
            ),
          ).thenReturn(true);
        },
        act: (FlashcardsEditorBloc bloc) {
          bloc.add(FlashcardsEditorEventSave());
        },
        expect: () => [
          FlashcardsEditorState(
            status: const BlocStatusComplete<FlashcardsEditorInfoType>(
              info: FlashcardsEditorInfoType.noChangesHaveBeenMade,
            ),
            group: createGroup(),
            editorFlashcards: editorFlashcards,
            keyCounter: 0,
          ),
        ],
      );

      blocTest(
        'should emit incomplete flashcards info and update editor flashcards when there is at least one incomplete flashcard',
        build: () => createBloc(
          group: createGroup(),
          editorFlashcards: editorFlashcards,
        ),
        setUp: () {
          when(
            () =>
                flashcardsEditorUtils.areEditorFlashcardsSameAsGroupFlashcards(
              [],
              [editorFlashcards[0]],
            ),
          ).thenReturn(false);
          when(
            () => flashcardsEditorUtils.areThereIncompleteEditorFlashcards(
              [editorFlashcards[0]],
            ),
          ).thenReturn(true);
          when(
            () =>
                flashcardsEditorUtils.updateEditorFlashcardsCompletionStatuses(
              editorFlashcards,
            ),
          ).thenReturn(editorFlashcards);
        },
        act: (FlashcardsEditorBloc bloc) {
          bloc.add(FlashcardsEditorEventSave());
        },
        expect: () => [
          FlashcardsEditorState(
            status: const BlocStatusComplete<FlashcardsEditorInfoType>(
              info: FlashcardsEditorInfoType.incompleteFlashcardsExist,
            ),
            group: createGroup(),
            editorFlashcards: editorFlashcards,
            keyCounter: 0,
          ),
        ],
      );

      blocTest(
        'confirmed, should save edited flashcards',
        build: () => createBloc(
          group: createGroup(),
          editorFlashcards: editorFlashcards,
        ),
        setUp: () {
          when(
            () =>
                flashcardsEditorUtils.areEditorFlashcardsSameAsGroupFlashcards(
              [],
              [editorFlashcards[0]],
            ),
          ).thenReturn(false);
          when(
            () => flashcardsEditorUtils.areThereIncompleteEditorFlashcards(
              [editorFlashcards[0]],
            ),
          ).thenReturn(false);
          when(
            () => flashcardsEditorDialogs.askForSaveConfirmation(),
          ).thenAnswer((_) async => true);
          when(
            () => flashcardsEditorUtils.convertEditorFlashcardsToFlashcards(
              [editorFlashcards[0]],
            ),
          ).thenReturn(
            [createFlashcard(index: 0, question: 'q0', answer: 'a0')],
          );
          when(
            () => saveEditedFlashcardsUseCase.execute(
              groupId: '',
              flashcards: [
                createFlashcard(index: 0, question: 'q0', answer: 'a0'),
              ],
            ),
          ).thenAnswer((_) async => '');
        },
        act: (FlashcardsEditorBloc bloc) {
          bloc.add(FlashcardsEditorEventSave());
        },
        expect: () => [
          FlashcardsEditorState(
            status: const BlocStatusLoading(),
            group: createGroup(),
            editorFlashcards: editorFlashcards,
            keyCounter: 0,
          ),
          FlashcardsEditorState(
            status: const BlocStatusComplete<FlashcardsEditorInfoType>(
              info: FlashcardsEditorInfoType.editedFlashcardsHaveBeenSaved,
            ),
            group: createGroup(),
            editorFlashcards: editorFlashcards,
            keyCounter: 0,
          ),
        ],
        verify: (_) {
          verify(
            () => saveEditedFlashcardsUseCase.execute(
              groupId: '',
              flashcards: [
                createFlashcard(index: 0, question: 'q0', answer: 'a0'),
              ],
            ),
          ).called(1);
        },
      );

      blocTest(
        'cancelled, should not save edited flashcards',
        build: () => createBloc(
          group: createGroup(),
          editorFlashcards: editorFlashcards,
        ),
        setUp: () {
          when(
            () =>
                flashcardsEditorUtils.areEditorFlashcardsSameAsGroupFlashcards(
              [],
              [editorFlashcards[0]],
            ),
          ).thenReturn(false);
          when(
            () => flashcardsEditorUtils.areThereIncompleteEditorFlashcards(
              [editorFlashcards[0]],
            ),
          ).thenReturn(false);
          when(
            () => flashcardsEditorDialogs.askForSaveConfirmation(),
          ).thenAnswer((_) async => false);
        },
        act: (FlashcardsEditorBloc bloc) {
          bloc.add(FlashcardsEditorEventSave());
        },
        expect: () => [],
        verify: (_) {
          verifyNever(
            () => saveEditedFlashcardsUseCase.execute(
              groupId: '',
              flashcards: [
                createFlashcard(index: 0, question: 'q0', answer: 'a0'),
              ],
            ),
          );
        },
      );
    },
  );
}

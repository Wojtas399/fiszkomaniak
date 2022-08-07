import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:fiszkomaniak/domain/entities/flashcard.dart';
import 'package:fiszkomaniak/domain/entities/group.dart';
import 'package:fiszkomaniak/domain/use_cases/flashcards/save_edited_flashcards_use_case.dart';
import 'package:fiszkomaniak/domain/use_cases/groups/get_group_use_case.dart';
import 'package:fiszkomaniak/features/flashcards_editor/bloc/flashcards_editor_bloc.dart';
import 'package:fiszkomaniak/features/flashcards_editor/flashcards_editor_dialogs.dart';
import 'package:fiszkomaniak/models/bloc_status.dart';

class MockGetGroupUseCase extends Mock implements GetGroupUseCase {}

class MockSaveEditedFlashcardsUseCase extends Mock
    implements SaveEditedFlashcardsUseCase {}

class MockFlashcardsEditorDialogs extends Mock
    implements FlashcardsEditorDialogs {}

void main() {
  final getGroupUseCase = MockGetGroupUseCase();
  final saveEditedFlashcardsUseCase = MockSaveEditedFlashcardsUseCase();
  final flashcardsEditorDialogs = MockFlashcardsEditorDialogs();

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
      status: status,
      group: group,
      editorFlashcards: editorFlashcards,
      keyCounter: keyCounter,
    );
  }

  FlashcardsEditorState createState({
    BlocStatus status = const BlocStatusInProgress(),
    Group? group,
    List<EditorFlashcard> editorFlashcards = const [],
    int keyCounter = 0,
  }) {
    return FlashcardsEditorState(
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
        createEditorFlashcard(
          key: 'flashcard0',
          question: 'q0',
          answer: 'a0',
          completionStatus: EditorFlashcardCompletionStatus.complete,
        ),
        createEditorFlashcard(
          key: 'flashcard1',
          question: 'q1',
          answer: 'a1',
          completionStatus: EditorFlashcardCompletionStatus.complete,
        ),
        createEditorFlashcard(
          key: 'flashcard2',
          question: 'q2',
          answer: 'a2',
          completionStatus: EditorFlashcardCompletionStatus.complete,
        ),
        createEditorFlashcard(key: 'flashcard3'),
      ];

      blocTest(
        'should load group and create initial editor flashcards',
        build: () => createBloc(),
        setUp: () {
          when(
            () => getGroupUseCase.execute(groupId: 'g1'),
          ).thenAnswer((_) => Stream.value(group));
        },
        act: (FlashcardsEditorBloc bloc) {
          bloc.add(
            FlashcardsEditorEventInitialize(groupId: 'g1'),
          );
        },
        expect: () => [
          createState(
            group: group,
            editorFlashcards: editorFlashcards,
            keyCounter: editorFlashcards.length - 1,
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
          bloc.add(
            FlashcardsEditorEventRemoveFlashcard(flashcardIndex: 1),
          );
        },
        expect: () => [
          createState(
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
          bloc.add(
            FlashcardsEditorEventRemoveFlashcard(flashcardIndex: 1),
          );
        },
        expect: () => [],
      );

      blocTest(
        'should remove flashcard and add new empty flashcard if there is only one flashcard in list',
        build: () => createBloc(
          editorFlashcards: [editorFlashcards[0]],
        ),
        setUp: () {
          when(
            () => flashcardsEditorDialogs.askForDeleteConfirmation(),
          ).thenAnswer((_) async => true);
        },
        act: (FlashcardsEditorBloc bloc) {
          bloc.add(
            FlashcardsEditorEventRemoveFlashcard(flashcardIndex: 0),
          );
        },
        expect: () => [
          createState(
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
          key: 'flashcard0',
          question: 'q0',
          answer: 'a0',
          completionStatus: EditorFlashcardCompletionStatus.complete,
        ),
        createEditorFlashcard(
          key: 'flashcard1',
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
        key: 'flashcard2',
      );

      blocTest(
        'should updated edited flashcard and should add new flashcard',
        build: () => createBloc(
          editorFlashcards: editorFlashcards,
          keyCounter: 1,
        ),
        act: (FlashcardsEditorBloc bloc) {
          bloc.add(
            FlashcardsEditorEventValueChanged(
              flashcardIndex: 1,
              question: 'question1',
            ),
          );
        },
        expect: () => [
          createState(
            editorFlashcards: [
              ...updatedEditorFlashcards,
              newEditorFlashcard,
            ],
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
        act: (FlashcardsEditorBloc bloc) {
          bloc.add(
            FlashcardsEditorEventValueChanged(
              flashcardIndex: 0,
              question: 'question1',
            ),
          );
        },
        expect: () => [
          createState(
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
      final Group group = createGroup(
        flashcards: [
          createFlashcard(index: 0, question: 'q0', answer: 'a0'),
        ],
      );
      final List<EditorFlashcard> editorFlashcards = [
        createEditorFlashcard(
          key: 'flashcard0',
          question: 'question0',
          answer: 'answer0',
          completionStatus: EditorFlashcardCompletionStatus.complete,
        ),
        createEditorFlashcard(key: 'flashcard1'),
      ];

      blocTest(
        'confirmed, should save edited flashcards',
        build: () => createBloc(
          group: group,
          editorFlashcards: editorFlashcards,
        ),
        setUp: () {
          when(
            () => flashcardsEditorDialogs.askForSaveConfirmation(),
          ).thenAnswer((_) async => true);
          when(
            () => saveEditedFlashcardsUseCase.execute(
              groupId: '',
              flashcards: [
                createFlashcard(
                  index: 0,
                  question: 'question0',
                  answer: 'answer0',
                ),
              ],
            ),
          ).thenAnswer((_) async => '');
        },
        act: (FlashcardsEditorBloc bloc) {
          bloc.add(FlashcardsEditorEventSave());
        },
        expect: () => [
          createState(
            status: const BlocStatusLoading(),
            group: group,
            editorFlashcards: editorFlashcards,
          ),
          createState(
            status: const BlocStatusComplete<FlashcardsEditorInfo>(
              info: FlashcardsEditorInfo.editedFlashcardsHaveBeenSaved,
            ),
            group: group,
            editorFlashcards: editorFlashcards,
          ),
        ],
        verify: (_) {
          verify(
            () => saveEditedFlashcardsUseCase.execute(
              groupId: '',
              flashcards: [
                createFlashcard(
                  index: 0,
                  question: 'question0',
                  answer: 'answer0',
                ),
              ],
            ),
          ).called(1);
        },
      );

      blocTest(
        'cancelled, should not save edited flashcards',
        build: () => createBloc(
          group: group,
          editorFlashcards: editorFlashcards,
        ),
        setUp: () {
          when(
            () => flashcardsEditorDialogs.askForSaveConfirmation(),
          ).thenAnswer((_) async => false);
          when(
            () => saveEditedFlashcardsUseCase.execute(
              groupId: '',
              flashcards: [
                createFlashcard(
                  index: 0,
                  question: 'question0',
                  answer: 'answer0',
                ),
              ],
            ),
          ).thenAnswer((_) async => '');
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
                createFlashcard(
                  index: 0,
                  question: 'question0',
                  answer: 'answer0',
                ),
              ],
            ),
          );
        },
      );

      blocTest(
        'should emit no changes info when editor flashcards are same as group flashcards',
        build: () => createBloc(
          group: group,
          editorFlashcards: [
            editorFlashcards.first.copyWith(question: 'q0', answer: 'a0'),
            editorFlashcards[1],
          ],
        ),
        act: (FlashcardsEditorBloc bloc) {
          bloc.add(
            FlashcardsEditorEventSave(),
          );
        },
        expect: () => [
          createState(
            status: const BlocStatusError<FlashcardsEditorError>(
              error: FlashcardsEditorError.noChangesHaveBeenMade,
            ),
            group: group,
            editorFlashcards: [
              editorFlashcards.first.copyWith(question: 'q0', answer: 'a0'),
              editorFlashcards[1],
            ],
            keyCounter: 0,
          ),
        ],
      );

      blocTest(
        'should emit incomplete flashcards info and update editor flashcards when there is at least one incomplete flashcard',
        build: () => createBloc(
          group: group,
          editorFlashcards: [
            editorFlashcards.first.copyWith(
              question: '',
              completionStatus: EditorFlashcardCompletionStatus.incomplete,
            ),
            editorFlashcards[1],
          ],
        ),
        act: (FlashcardsEditorBloc bloc) {
          bloc.add(FlashcardsEditorEventSave());
        },
        expect: () => [
          createState(
            status: const BlocStatusError<FlashcardsEditorError>(
              error: FlashcardsEditorError.incompleteFlashcardsExist,
            ),
            group: group,
            editorFlashcards: [
              editorFlashcards.first.copyWith(
                question: '',
                completionStatus: EditorFlashcardCompletionStatus.incomplete,
              ),
              editorFlashcards[1],
            ],
            keyCounter: 0,
          ),
        ],
      );
    },
  );
}

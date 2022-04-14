import 'package:equatable/equatable.dart';
import 'package:fiszkomaniak/core/flashcards/flashcards_bloc.dart';
import 'package:fiszkomaniak/core/groups/groups_bloc.dart';
import 'package:fiszkomaniak/features/flashcards_editor/bloc/flashcards_editor_dialogs.dart';
import 'package:fiszkomaniak/features/flashcards_editor/bloc/flashcards_editor_event.dart';
import 'package:fiszkomaniak/features/flashcards_editor/bloc/flashcards_editor_state.dart';
import 'package:fiszkomaniak/features/flashcards_editor/bloc/flashcards_editor_utils.dart';
import 'package:fiszkomaniak/models/flashcard_model.dart';
import 'package:fiszkomaniak/models/group_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/flashcards/flashcards_event.dart';

class FlashcardsEditorBloc
    extends Bloc<FlashcardsEditorEvent, FlashcardsEditorState> {
  late final GroupsBloc _groupsBloc;
  late final FlashcardsBloc _flashcardsBloc;
  late final FlashcardsEditorDialogs _flashcardsEditorDialogs;
  late final FlashcardsEditorUtils _flashcardsEditorUtils;

  FlashcardsEditorBloc({
    required GroupsBloc groupsBloc,
    required FlashcardsBloc flashcardsBloc,
    required FlashcardsEditorDialogs flashcardsEditorDialogs,
    required FlashcardsEditorUtils flashcardsEditorUtils,
  }) : super(const FlashcardsEditorState()) {
    _groupsBloc = groupsBloc;
    _flashcardsBloc = flashcardsBloc;
    _flashcardsEditorDialogs = flashcardsEditorDialogs;
    _flashcardsEditorUtils = flashcardsEditorUtils;
    on<FlashcardsEditorEventInitialize>(_initialize);
    on<FlashcardsEditorEventAddFlashcard>(_addFlashcard);
    on<FlashcardsEditorEventRemoveFlashcard>(_removeFlashcard);
    on<FlashcardsEditorEventQuestionChanged>(_questionChanged);
    on<FlashcardsEditorEventAnswerChanged>(_answerChanged);
    on<FlashcardsEditorEventSave>(_save);
  }

  void _initialize(
    FlashcardsEditorEventInitialize event,
    Emitter<FlashcardsEditorState> emit,
  ) {
    final Group? group = _groupsBloc.state.getGroupById(event.groupId);
    if (group != null) {
      final List<Flashcard> initialFlashcards =
          _getFlashcardsFromCore(group.id);
      final List<EditorFlashcard> convertedInitialFlashcards =
          _convertFlashcardsFromCore(initialFlashcards);
      emit(state.copyWith(
        group: group,
        flashcards: [
          ...convertedInitialFlashcards,
          EditorFlashcard(
            key: 'flashcard${convertedInitialFlashcards.length}',
            doc: createFlashcard(groupId: group.id),
          ),
        ],
        keyCounter: convertedInitialFlashcards.length,
      ));
    }
  }

  void _addFlashcard(
    FlashcardsEditorEventAddFlashcard event,
    Emitter<FlashcardsEditorState> emit,
  ) {
    final String? groupId = state.group?.id;
    if (groupId != null) {
      emit(state.copyWith(
        flashcards: [
          ...state.flashcards,
          EditorFlashcard(
            key: 'flashcard${state.keyCounter + 1}',
            doc: createFlashcard(groupId: groupId),
          ),
        ],
        keyCounter: state.keyCounter + 1,
      ));
    }
  }

  Future<void> _removeFlashcard(
    FlashcardsEditorEventRemoveFlashcard event,
    Emitter<FlashcardsEditorState> emit,
  ) async {
    final bool? confirmation =
        await _flashcardsEditorDialogs.askForDeleteConfirmation();
    if (confirmation == true) {
      final List<EditorFlashcard> flashcards = [...state.flashcards];
      flashcards.removeAt(event.indexOfFlashcard);
      emit(state.copyWith(flashcards: flashcards));
    }
  }

  void _questionChanged(
    FlashcardsEditorEventQuestionChanged event,
    Emitter<FlashcardsEditorState> emit,
  ) {
    final List<EditorFlashcard> flashcards = [...state.flashcards];
    EditorFlashcard editedFlashcard = flashcards[event.indexOfFlashcard];
    flashcards[event.indexOfFlashcard] = editedFlashcard.copyWith(
      doc: editedFlashcard.doc.copyWith(question: event.question),
    );
    emit(state.copyWith(flashcards: flashcards));
    _addFlashcardAsNeeded(event.indexOfFlashcard);
    _removeEmptyFlashcards(event.indexOfFlashcard, emit);
  }

  void _answerChanged(
    FlashcardsEditorEventAnswerChanged event,
    Emitter<FlashcardsEditorState> emit,
  ) {
    final List<EditorFlashcard> flashcards = [...state.flashcards];
    EditorFlashcard editedFlashcard = flashcards[event.indexOfFlashcard];
    flashcards[event.indexOfFlashcard] = editedFlashcard.copyWith(
      doc: editedFlashcard.doc.copyWith(answer: event.answer),
    );
    emit(state.copyWith(flashcards: flashcards));
    _addFlashcardAsNeeded(event.indexOfFlashcard);
    _removeEmptyFlashcards(event.indexOfFlashcard, emit);
  }

  Future<void> _save(
    FlashcardsEditorEventSave event,
    Emitter<FlashcardsEditorState> emit,
  ) async {
    final FlashcardsEditorGroups flashcardsGroups = _getSegregatedFlashcards();
    if (flashcardsGroups.added.isEmpty &&
        flashcardsGroups.edited.isEmpty &&
        flashcardsGroups.removed.isEmpty) {
      await _flashcardsEditorDialogs.displayInfoAboutNoChanges();
    } else {
      List<Flashcard> flashcardsToCheck = [
        ...flashcardsGroups.added,
        ...flashcardsGroups.edited,
      ];
      if (_areThereIncorrectlyCompletedFlashcards(flashcardsToCheck)) {
        await _flashcardsEditorDialogs.displayInfoAboutIncorrectFlashcards();
      } else {
        final bool? confirmation =
            await _flashcardsEditorDialogs.askForSaveConfirmation();
        if (confirmation == true) {
          _flashcardsBloc.add(FlashcardsEventSave(
            flashcardsToUpdate: flashcardsGroups.edited,
            flashcardsToAdd: flashcardsGroups.added,
            idsOfFlashcardsToRemove: flashcardsGroups.removed,
          ));
        }
      }
    }
  }

  List<Flashcard> _getFlashcardsFromCore(String? groupId) {
    return _flashcardsBloc.state.getFlashcardsFromGroup(groupId).toList();
  }

  List<EditorFlashcard> _convertFlashcardsFromCore(
    List<Flashcard> flashcards,
  ) {
    return flashcards.asMap().entries.map((entry) {
      return EditorFlashcard(
        key: 'flashcard${entry.key}',
        doc: entry.value,
      );
    }).toList();
  }

  void _addFlashcardAsNeeded(int indexOfEditedFlashcard) {
    if (indexOfEditedFlashcard == state.flashcards.length - 1) {
      add(FlashcardsEditorEventAddFlashcard());
    }
  }

  void _removeEmptyFlashcards(
    int currentFlashcardIndex,
    Emitter<FlashcardsEditorState> emit,
  ) {
    final List<EditorFlashcard> allFlashcards = [...state.flashcards];
    for (int i = 0; i < state.flashcards.length - 1; i++) {
      if (!_flashcardsEditorUtils.areFlashcardBothFieldsCompleted(
            state.flashcards[i].doc,
          ) &&
          currentFlashcardIndex != i) {
        print('remove: $i');
        allFlashcards.removeAt(i);
      }
    }
    emit(state.copyWith(flashcards: allFlashcards));
  }

  bool _areThereIncorrectlyCompletedFlashcards(
    List<Flashcard> flashcardsToCheck,
  ) {
    return !_flashcardsEditorUtils.areFlashcardsCompletedCorrectly(
      flashcardsToCheck,
    );
  }

  FlashcardsEditorGroups _getSegregatedFlashcards() {
    final String? groupId = state.group?.id;
    if (groupId != null) {
      final List<Flashcard> editedFlashcards = state.flashcards
          .getRange(0, state.flashcards.length - 1)
          .map((flashcard) => flashcard.doc)
          .toList();
      final List<Flashcard> initialFlashcards = _getFlashcardsFromCore(groupId);
      return _flashcardsEditorUtils.groupFlashcardsIntoAppropriateGroups(
        editedFlashcards,
        initialFlashcards,
      );
    }
    return const FlashcardsEditorGroups(edited: [], added: [], removed: []);
  }
}

class FlashcardsEditorGroups extends Equatable {
  final List<Flashcard> edited;
  final List<Flashcard> added;
  final List<String> removed;

  const FlashcardsEditorGroups({
    required this.edited,
    required this.added,
    required this.removed,
  });

  @override
  List<Object> get props => [edited, added, removed];
}

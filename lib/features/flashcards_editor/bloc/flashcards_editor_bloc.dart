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
    on<FlashcardsEditorEventRemoveFlashcard>(_removeFlashcard);
    on<FlashcardsEditorEventValueChanged>(_valueChanged);
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
            isCorrect: true,
            doc: createFlashcard(groupId: group.id),
          ),
        ],
        keyCounter: convertedInitialFlashcards.length,
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

  void _valueChanged(
    FlashcardsEditorEventValueChanged event,
    Emitter<FlashcardsEditorState> emit,
  ) {
    List<EditorFlashcard> flashcards = [...state.flashcards];
    EditorFlashcard editedFlashcard = flashcards[event.indexOfFlashcard];
    flashcards[event.indexOfFlashcard] = editedFlashcard.copyWith(
      doc: editedFlashcard.doc.copyWith(
        question: event.question,
        answer: event.answer,
      ),
    );
    flashcards = _flashcardsEditorUtils
        .removeEmptyFlashcardsWithoutLastOneAndChangedFlashcard(
      flashcards,
      event.indexOfFlashcard,
    );
    if (event.indexOfFlashcard == flashcards.length - 1) {
      flashcards = _addNewFlashcard(flashcards);
      emit(state.copyWith(keyCounter: state.keyCounter + 1));
    }
    if (state.areIncorrectFlashcards) {
      flashcards = _flashcardsEditorUtils.setFlashcardsAsCorrectIfItIsPossible(
        flashcards,
      );
    }
    emit(state.copyWith(flashcards: flashcards));
  }

  Future<void> _save(
    FlashcardsEditorEventSave event,
    Emitter<FlashcardsEditorState> emit,
  ) async {
    final FlashcardsEditorGroups flashcardsGroups = _getSegregatedFlashcards();
    if (await _canSave(flashcardsGroups, emit)) {
      _flashcardsBloc.add(FlashcardsEventSaveMultipleActions(
        flashcardsToUpdate: flashcardsGroups.edited,
        flashcardsToAdd: flashcardsGroups.added,
        idsOfFlashcardsToRemove: flashcardsGroups.removed,
      ));
    }
  }

  List<Flashcard> _getFlashcardsFromCore(String? groupId) {
    return _flashcardsBloc.state.getFlashcardsByGroupId(groupId).toList();
  }

  List<EditorFlashcard> _convertFlashcardsFromCore(
    List<Flashcard> flashcards,
  ) {
    return flashcards.asMap().entries.map((entry) {
      return EditorFlashcard(
        key: 'flashcard${entry.key}',
        isCorrect: true,
        doc: entry.value,
      );
    }).toList();
  }

  List<EditorFlashcard> _addNewFlashcard(
    List<EditorFlashcard> flashcards,
  ) {
    final String? groupId = state.group?.id;
    final List<EditorFlashcard> updatedFlashcards = [...flashcards];
    if (groupId != null) {
      updatedFlashcards.add(EditorFlashcard(
        key: 'flashcard${state.keyCounter + 1}',
        isCorrect: true,
        doc: createFlashcard(id: 'f${state.keyCounter + 1}', groupId: groupId),
      ));
    }
    return updatedFlashcards;
  }

  FlashcardsEditorGroups _getSegregatedFlashcards() {
    final String? groupId = state.group?.id;
    if (groupId != null) {
      final List<Flashcard> initialFlashcards = _getFlashcardsFromCore(groupId);
      return _flashcardsEditorUtils.groupFlashcardsIntoAppropriateGroups(
        state.flashcardsWithoutLastOne,
        initialFlashcards,
      );
    }
    return const FlashcardsEditorGroups(edited: [], added: [], removed: []);
  }

  Future<bool> _canSave(
    FlashcardsEditorGroups groups,
    Emitter<FlashcardsEditorState> emit,
  ) async {
    final List<Flashcard> incorrectFlashcards = _flashcardsEditorUtils
        .lookForIncorrectlyCompletedFlashcards(state.flashcardsWithoutLastOne);
    if (incorrectFlashcards.isNotEmpty) {
      _updateIncorrectFlashcards(incorrectFlashcards, emit);
      await _flashcardsEditorDialogs.displayInfoAboutIncorrectFlashcards();
      return false;
    }
    final List<Flashcard> duplications =
        _flashcardsEditorUtils.lookForDuplicates(
      state.flashcardsWithoutLastOne,
    );
    if (duplications.isNotEmpty) {
      _updateIncorrectFlashcards(duplications, emit);
      await _flashcardsEditorDialogs.displayInfoAboutDuplicates();
      return false;
    }
    if (groups.added.isEmpty &&
        groups.edited.isEmpty &&
        groups.removed.isEmpty) {
      await _flashcardsEditorDialogs.displayInfoAboutNoChanges();
      return false;
    }
    return await _flashcardsEditorDialogs.askForSaveConfirmation() == true;
  }

  void _updateIncorrectFlashcards(
    List<Flashcard> incorrectFlashcards,
    Emitter<FlashcardsEditorState> emit,
  ) {
    final List<EditorFlashcard> updatedFlashcards = [...state.flashcards];
    for (int i = 0; i < updatedFlashcards.length; i++) {
      if (incorrectFlashcards.contains(updatedFlashcards[i].doc)) {
        updatedFlashcards[i] = updatedFlashcards[i].copyWith(isCorrect: false);
      }
    }
    emit(state.copyWith(flashcards: updatedFlashcards));
  }
}

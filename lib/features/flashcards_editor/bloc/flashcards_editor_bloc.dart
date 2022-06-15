import 'package:fiszkomaniak/core/achievements/achievements_bloc.dart';
import 'package:fiszkomaniak/features/flashcards_editor/bloc/flashcards_editor_dialogs.dart';
import 'package:fiszkomaniak/features/flashcards_editor/bloc/flashcards_editor_event.dart';
import 'package:fiszkomaniak/features/flashcards_editor/bloc/flashcards_editor_state.dart';
import 'package:fiszkomaniak/features/flashcards_editor/bloc/flashcards_editor_utils.dart';
import 'package:fiszkomaniak/features/flashcards_editor/flashcards_editor_mode.dart';
import 'package:fiszkomaniak/models/flashcard_model.dart';
import 'package:fiszkomaniak/models/group_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FlashcardsEditorBloc
    extends Bloc<FlashcardsEditorEvent, FlashcardsEditorState> {
  late final AchievementsBloc _achievementsBloc;
  late final FlashcardsEditorDialogs _flashcardsEditorDialogs;
  late final FlashcardsEditorUtils _flashcardsEditorUtils;

  FlashcardsEditorBloc({
    required AchievementsBloc achievementsBloc,
    required FlashcardsEditorDialogs flashcardsEditorDialogs,
    required FlashcardsEditorUtils flashcardsEditorUtils,
  }) : super(const FlashcardsEditorState()) {
    _achievementsBloc = achievementsBloc;
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
    // final Group? group = _groupsBloc.state.getGroupById(event.mode.groupId);
    // if (group != null) {
    //   final List<Flashcard> initialFlashcards = group.flashcards;
    //   final List<EditorFlashcard> convertedInitialFlashcards =
    //       _convertFlashcardsFromCore(initialFlashcards);
    //   final List<EditorFlashcard> flashcards = [
    //     ...(event.mode is FlashcardsEditorEditMode
    //         ? convertedInitialFlashcards
    //         : []),
    //     EditorFlashcard(
    //       key: 'flashcard${convertedInitialFlashcards.length}',
    //       isCorrect: true,
    //       doc: createFlashcard(index: convertedInitialFlashcards.length),
    //     ),
    //   ];
    //   emit(state.copyWith(
    //     mode: event.mode,
    //     group: group,
    //     flashcards: flashcards,
    //     keyCounter: convertedInitialFlashcards.length,
    //   ));
    // }
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
      final Group? group = state.group;
      if (flashcards.isEmpty && group != null) {
        int amountOfFlashcardsInGroup = 0;
        if (state.mode is FlashcardsEditorAddMode) {
          amountOfFlashcardsInGroup = group.flashcards.length;
        }
        flashcards.add(
          EditorFlashcard(
            key: 'flashcard$amountOfFlashcardsInGroup',
            isCorrect: true,
            doc: createFlashcard(index: amountOfFlashcardsInGroup),
          ),
        );
      }
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
    // final Group? group = state.group;
    // final FlashcardsEditorMode? mode = state.mode;
    // if (group != null && mode != null && await _canSave(emit)) {
    //   final List<Flashcard> flashcardsToSave = mode is FlashcardsEditorEditMode
    //       ? state.flashcardsWithoutLastOne
    //       : [...group.flashcards, ...state.flashcardsWithoutLastOne];
    //   _flashcardsBloc.add(FlashcardsEventSaveEditedFlashcards(
    //     groupId: group.id,
    //     flashcards: flashcardsToSave,
    //     justAddedFlashcards: mode is FlashcardsEditorAddMode,
    //   ));
    //   _achievementsBloc.add(AchievementsEventAddNewFlashcards(
    //     groupId: group.id,
    //     flashcardsIndexes:
    //         flashcardsToSave.map((flashcard) => flashcard.index).toList(),
    //   ));
    // }
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
    final List<EditorFlashcard> updatedFlashcards = [...flashcards];
    updatedFlashcards.add(EditorFlashcard(
      key: 'flashcard${state.keyCounter + 1}',
      isCorrect: true,
      doc: createFlashcard(index: state.keyCounter + 1),
    ));
    return updatedFlashcards;
  }

  Future<bool> _canSave(Emitter<FlashcardsEditorState> emit) async {
    if (await _areEditedFlashcardsSameAsOriginal()) {
      return false;
    }
    if (await _areThereIncorrectFlashcards(emit)) {
      return false;
    }
    if (await _areThereDuplicates(emit)) {
      return false;
    }
    return await _flashcardsEditorDialogs.askForSaveConfirmation() == true;
  }

  Future<bool> _areEditedFlashcardsSameAsOriginal() async {
    final List<Flashcard>? originalFlashcards = state.group?.flashcards;
    if (originalFlashcards != null &&
        _flashcardsEditorUtils.haveChangesBeenMade(
              originalFlashcards,
              state.flashcardsWithoutLastOne,
            ) ==
            false) {
      await _flashcardsEditorDialogs.displayInfoAboutNoChanges();
      return true;
    }
    return false;
  }

  Future<bool> _areThereIncorrectFlashcards(
    Emitter<FlashcardsEditorState> emit,
  ) async {
    final List<Flashcard> incorrectFlashcards = _flashcardsEditorUtils
        .lookForIncorrectlyCompletedFlashcards(state.flashcardsWithoutLastOne);
    if (incorrectFlashcards.isNotEmpty) {
      _updateIncorrectFlashcards(incorrectFlashcards, emit);
      await _flashcardsEditorDialogs.displayInfoAboutIncorrectFlashcards();
      return true;
    }
    return false;
  }

  Future<bool> _areThereDuplicates(Emitter<FlashcardsEditorState> emit) async {
    final List<Flashcard> flashcardsToCheck =
        state.mode is FlashcardsEditorAddMode
            ? [
                ...(state.group?.flashcards ?? []),
                ...state.flashcardsWithoutLastOne,
              ]
            : state.flashcardsWithoutLastOne;
    final List<Flashcard> duplications =
        _flashcardsEditorUtils.lookForDuplicates(flashcardsToCheck);
    if (duplications.isNotEmpty) {
      _updateIncorrectFlashcards(duplications, emit);
      await _flashcardsEditorDialogs.displayInfoAboutDuplicates();
      return true;
    }
    return false;
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

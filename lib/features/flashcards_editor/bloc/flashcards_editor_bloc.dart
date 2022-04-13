import 'package:fiszkomaniak/core/flashcards/flashcards_bloc.dart';
import 'package:fiszkomaniak/core/groups/groups_bloc.dart';
import 'package:fiszkomaniak/features/flashcards_editor/bloc/flashcards_editor_event.dart';
import 'package:fiszkomaniak/features/flashcards_editor/bloc/flashcards_editor_state.dart';
import 'package:fiszkomaniak/models/flashcard_model.dart';
import 'package:fiszkomaniak/models/group_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/flashcards/flashcards_event.dart';

class FlashcardsEditorBloc
    extends Bloc<FlashcardsEditorEvent, FlashcardsEditorState> {
  late final GroupsBloc _groupsBloc;
  late final FlashcardsBloc _flashcardsBloc;

  FlashcardsEditorBloc({
    required GroupsBloc groupsBloc,
    required FlashcardsBloc flashcardsBloc,
  }) : super(const FlashcardsEditorState()) {
    _groupsBloc = groupsBloc;
    _flashcardsBloc = flashcardsBloc;
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

  void _removeFlashcard(
    FlashcardsEditorEventRemoveFlashcard event,
    Emitter<FlashcardsEditorState> emit,
  ) {
    final List<EditorFlashcard> flashcards = [...state.flashcards];
    flashcards.removeAt(event.indexOfFlashcard);
    emit(state.copyWith(flashcards: flashcards));
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
    _removeEmptyFlashcards(event.indexOfFlashcard);
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
    _removeEmptyFlashcards(event.indexOfFlashcard);
  }

  void _save(
    FlashcardsEditorEventSave event,
    Emitter<FlashcardsEditorState> emit,
  ) {
    final String? groupId = state.group?.id;
    if (groupId != null) {
      final FlashcardsEditorGroups flashcardsGroups = _getFlashcardsGroups();
      _flashcardsBloc.add(FlashcardsEventSave(
        flashcardsToUpdate: flashcardsGroups.edited,
        flashcardsToAdd: flashcardsGroups.added,
        idsOfFlashcardsToRemove: flashcardsGroups.removed,
      ));
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

  void _removeEmptyFlashcards(int currentFlashcardIndex) {
    for (int i=0; i<state.flashcards.length-1; i++) {
      if (state.flashcards[i].doc.isEmpty && currentFlashcardIndex != i) {
        add(FlashcardsEditorEventRemoveFlashcard(indexOfFlashcard: i));
      }
    }
  }

  FlashcardsEditorGroups _getFlashcardsGroups() {
    final List<Flashcard> edited = [];
    final List<Flashcard> added = [];
    final List<String> removed = [];
    final List<Flashcard> editedFlashcards =
        [...state.flashcards].map((flashcard) => flashcard.doc).toList();
    final List<String> editedFlashcardsIds =
        editedFlashcards.map((flashcard) => flashcard.id).toList();
    final List<Flashcard> initialFlashcards =
        _getFlashcardsFromCore(state.group?.id);
    final List<String> initialFlashcardsIds =
        initialFlashcards.map((flashcard) => flashcard.id).toList();
    for (final flashcard in editedFlashcards) {
      if (!flashcard.isEmpty) {
        if (initialFlashcardsIds.contains(flashcard.id)) {
          final Flashcard correspondingInitialFlashcard = initialFlashcards
              .firstWhere((element) => element.id == flashcard.id);
          if (flashcard.answer != correspondingInitialFlashcard.answer ||
              flashcard.question != correspondingInitialFlashcard.question) {
            edited.add(flashcard);
          }
        } else {
          added.add(flashcard);
        }
      } else if (initialFlashcardsIds.contains(flashcard.id)) {
        removed.add(flashcard.id);
      }
    }
    for (final initialFlashcard in initialFlashcards) {
      if (!editedFlashcardsIds.contains(initialFlashcard.id) &&
          !edited.contains(initialFlashcard) &&
          !removed.contains(initialFlashcard.id)) {
        removed.add(initialFlashcard.id);
      }
    }
    return FlashcardsEditorGroups(
      edited: edited,
      added: added,
      removed: removed,
    );
  }
}

class FlashcardsEditorGroups {
  final List<Flashcard> edited;
  final List<Flashcard> added;
  final List<String> removed;

  FlashcardsEditorGroups({
    required this.edited,
    required this.added,
    required this.removed,
  });
}

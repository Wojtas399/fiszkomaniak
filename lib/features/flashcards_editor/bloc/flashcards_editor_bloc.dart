import 'package:fiszkomaniak/core/flashcards/flashcards_bloc.dart';
import 'package:fiszkomaniak/core/flashcards/flashcards_event.dart';
import 'package:fiszkomaniak/core/groups/groups_bloc.dart';
import 'package:fiszkomaniak/features/flashcards_editor/bloc/flashcards_editor_event.dart';
import 'package:fiszkomaniak/features/flashcards_editor/bloc/flashcards_editor_state.dart';
import 'package:fiszkomaniak/models/flashcard_model.dart';
import 'package:fiszkomaniak/models/group_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
      final List<FlashcardsEditorItemParams> existingFlashcards =
          _getExistingFlashcards(group.id);
      emit(state.copyWith(
        group: group,
        flashcards: [
          ...existingFlashcards,
          FlashcardsEditorItemParams(
            index: existingFlashcards.length,
            isNew: true,
            doc: createFlashcard(groupId: group.id),
          ),
        ],
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
          FlashcardsEditorItemParams(
            index: state.flashcards.length,
            isNew: true,
            doc: createFlashcard(groupId: groupId),
          ),
        ],
      ));
    }
  }

  void _removeFlashcard(
    FlashcardsEditorEventRemoveFlashcard event,
    Emitter<FlashcardsEditorState> emit,
  ) {
    final List<FlashcardsEditorItemParams> flashcards = [...state.flashcards];
    flashcards.removeAt(event.indexOfFlashcard);
    emit(state.copyWith(flashcards: flashcards));
  }

  void _questionChanged(
    FlashcardsEditorEventQuestionChanged event,
    Emitter<FlashcardsEditorState> emit,
  ) {
    final List<FlashcardsEditorItemParams> flashcards = [...state.flashcards];
    FlashcardsEditorItemParams editedFlashcard = flashcards.firstWhere(
      (flashcard) => flashcard.index == event.indexOfFlashcard,
    );
    flashcards[editedFlashcard.index] = editedFlashcard.copyWith(
      doc: editedFlashcard.doc.copyWith(question: event.question),
    );
    emit(state.copyWith(flashcards: flashcards));
    _addFlashcardAsNeeded(event.indexOfFlashcard);
    _removeFlashcardAsNeeded(flashcards[editedFlashcard.index]);
  }

  void _answerChanged(
    FlashcardsEditorEventAnswerChanged event,
    Emitter<FlashcardsEditorState> emit,
  ) {
    final List<FlashcardsEditorItemParams> flashcards = [...state.flashcards];
    FlashcardsEditorItemParams editedFlashcard = flashcards.firstWhere(
      (flashcard) => flashcard.index == event.indexOfFlashcard,
    );
    flashcards[editedFlashcard.index] = editedFlashcard.copyWith(
      doc: editedFlashcard.doc.copyWith(answer: event.answer),
    );
    emit(state.copyWith(flashcards: flashcards));
    _addFlashcardAsNeeded(event.indexOfFlashcard);
    _removeFlashcardAsNeeded(flashcards[editedFlashcard.index]);
  }

  void _save(
    FlashcardsEditorEventSave event,
    Emitter<FlashcardsEditorState> emit,
  ) {
    final List<Flashcard> newFlashcards =
        state.newFlashcards.map((flashcard) => flashcard.doc).toList();
    _flashcardsBloc.add(FlashcardsEventAddFlashcards(
      flashcards: newFlashcards,
    ));
  }

  List<FlashcardsEditorItemParams> _getExistingFlashcards(String groupId) {
    final List<Flashcard> flashcardsFromGroup =
        _flashcardsBloc.state.getFlashcardsFromGroup(groupId).toList();
    return flashcardsFromGroup.asMap().entries.map((entry) {
      return FlashcardsEditorItemParams(
        index: entry.key,
        isNew: false,
        doc: entry.value,
      );
    }).toList();
  }

  void _addFlashcardAsNeeded(int indexOfEditedFlashcard) {
    if (indexOfEditedFlashcard == state.flashcards.length - 1) {
      add(FlashcardsEditorEventAddFlashcard());
    }
  }

  void _removeFlashcardAsNeeded(FlashcardsEditorItemParams editedFlashcard) {
    if (editedFlashcard.index == state.flashcards.length - 2 &&
        editedFlashcard.doc.question.isEmpty &&
        editedFlashcard.doc.answer.isEmpty) {
      add(FlashcardsEditorEventRemoveFlashcard(
        indexOfFlashcard: state.flashcards.length - 1,
      ));
    }
  }
}

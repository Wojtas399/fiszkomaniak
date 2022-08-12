import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/flashcard.dart';
import '../../../domain/entities/group.dart';
import '../../../domain/use_cases/flashcards/save_edited_flashcards_use_case.dart';
import '../../../domain/use_cases/groups/get_group_use_case.dart';
import '../../../models/bloc_status.dart';
import '../../../utils/utils.dart';

part 'flashcards_editor_event.dart';

part 'flashcards_editor_state.dart';

part 'flashcards_editor_utils.dart';

class FlashcardsEditorBloc
    extends Bloc<FlashcardsEditorEvent, FlashcardsEditorState>
    with FlashcardsEditorUtils {
  late final GetGroupUseCase _getGroupUseCase;
  late final SaveEditedFlashcardsUseCase _saveEditedFlashcardsUseCase;

  FlashcardsEditorBloc({
    required GetGroupUseCase getGroupUseCase,
    required SaveEditedFlashcardsUseCase saveEditedFlashcardsUseCase,
    BlocStatus status = const BlocStatusInitial(),
    Group? group,
    List<EditorFlashcard> editorFlashcards = const [],
    int keyCounter = 0,
  }) : super(
          FlashcardsEditorState(
            status: status,
            group: group,
            editorFlashcards: editorFlashcards,
            keyCounter: keyCounter,
          ),
        ) {
    _getGroupUseCase = getGroupUseCase;
    _saveEditedFlashcardsUseCase = saveEditedFlashcardsUseCase;
    on<FlashcardsEditorEventInitialize>(_initialize);
    on<FlashcardsEditorEventDeleteFlashcard>(_deleteFlashcard);
    on<FlashcardsEditorEventValueChanged>(_valueChanged);
    on<FlashcardsEditorEventSave>(_save);
  }

  Future<void> _initialize(
    FlashcardsEditorEventInitialize event,
    Emitter<FlashcardsEditorState> emit,
  ) async {
    final Group group =
        await _getGroupUseCase.execute(groupId: event.groupId).first;
    final List<EditorFlashcard> editorFlashcards =
        createInitialEditorFlashcards(group.flashcards);
    emit(state.copyWith(
      group: group,
      editorFlashcards: editorFlashcards,
      keyCounter: editorFlashcards.length - 1,
    ));
  }

  Future<void> _deleteFlashcard(
    FlashcardsEditorEventDeleteFlashcard event,
    Emitter<FlashcardsEditorState> emit,
  ) async {
    List<EditorFlashcard> updatedEditorFlashcards = [
      ...state.editorFlashcards,
    ];
    updatedEditorFlashcards.removeAt(event.flashcardIndex);
    int keyCounter = state.keyCounter;
    if (updatedEditorFlashcards.isEmpty) {
      updatedEditorFlashcards = addNewEditorFlashcard(
        updatedEditorFlashcards,
        0,
      );
      keyCounter = 0;
    }
    emit(state.copyWith(
      editorFlashcards: updatedEditorFlashcards,
      keyCounter: keyCounter,
    ));
  }

  void _valueChanged(
    FlashcardsEditorEventValueChanged event,
    Emitter<FlashcardsEditorState> emit,
  ) {
    List<EditorFlashcard> updatedEditorFlashcards = _updateEditedFlashcard(
      event.flashcardIndex,
      event.question,
      event.answer,
    );
    updatedEditorFlashcards =
        removeEmptyEditorFlashcardsApartFromLastAndEditedOne(
      updatedEditorFlashcards,
      event.flashcardIndex,
    );
    int keyCounter = state.keyCounter;
    if (event.flashcardIndex == updatedEditorFlashcards.length - 1) {
      keyCounter++;
      updatedEditorFlashcards = addNewEditorFlashcard(
        updatedEditorFlashcards,
        keyCounter,
      );
    }
    if (_isThereAtLeastOneFlashcardMarkedAsIncomplete()) {
      updatedEditorFlashcards =
          updateCompletionStatusInEditorFlashcardsMarkedAsIncomplete(
        updatedEditorFlashcards,
      );
    }
    emit(state.copyWith(
      editorFlashcards: updatedEditorFlashcards,
      keyCounter: keyCounter,
    ));
  }

  Future<void> _save(
    FlashcardsEditorEventSave event,
    Emitter<FlashcardsEditorState> emit,
  ) async {
    final Group? group = state.group;
    if (group != null && _canSave(emit)) {
      emit(state.copyWith(
        status: const BlocStatusLoading(),
      ));
      final List<Flashcard> flashcardsToSave =
          convertEditorFlashcardsToFlashcards(
        _getEditorFlashcardsWithoutLastOne(),
      );
      await _saveEditedFlashcardsUseCase.execute(
        groupId: group.id,
        flashcards: flashcardsToSave,
      );
      emit(state.copyWithInfo(
        FlashcardsEditorInfo.editedFlashcardsHaveBeenSaved,
      ));
    }
  }

  List<EditorFlashcard> _updateEditedFlashcard(
    int editedFlashcardIndex,
    String? question,
    String? answer,
  ) {
    List<EditorFlashcard> flashcards = [...state.editorFlashcards];
    EditorFlashcard editedFlashcard = flashcards[editedFlashcardIndex];
    flashcards[editedFlashcardIndex] = editedFlashcard.copyWith(
      question: question,
      answer: answer,
    );
    return flashcards;
  }

  bool _isThereAtLeastOneFlashcardMarkedAsIncomplete() {
    for (final editorFlashcard
        in Utils.removeLastElement(state.editorFlashcards)) {
      if (editorFlashcard.completionStatus ==
          EditorFlashcardCompletionStatus.incomplete) {
        return true;
      }
    }
    return false;
  }

  bool _canSave(Emitter<FlashcardsEditorState> emit) {
    if (_areEditorFlashcardsSameAsGroupFlashcards()) {
      emit(state.copyWithError(
        FlashcardsEditorError.noChangesHaveBeenMade,
      ));
      return false;
    }
    if (_areThereIncompleteFlashcards()) {
      final List<EditorFlashcard> updatedEditorFlashcards =
          updateEditorFlashcardsCompletionStatuses(
        state.editorFlashcards,
      );
      emit(state.copyWith(
        status: const BlocStatusError<FlashcardsEditorError>(
          error: FlashcardsEditorError.incompleteFlashcardsExist,
        ),
        editorFlashcards: updatedEditorFlashcards,
      ));
      return false;
    }
    return true;
  }

  List<EditorFlashcard> _getEditorFlashcardsWithoutLastOne() {
    return Utils.removeLastElement(state.editorFlashcards);
  }

  bool _areEditorFlashcardsSameAsGroupFlashcards() {
    final List<Flashcard> groupFlashcards = state.group?.flashcards ?? [];
    final List<EditorFlashcard> editorFlashcards =
        _getEditorFlashcardsWithoutLastOne();
    if (editorFlashcards.isEmpty && groupFlashcards.isNotEmpty) {
      return false;
    }
    return areEditorFlashcardsSameAsGroupFlashcards(
      groupFlashcards,
      editorFlashcards,
    );
  }

  bool _areThereIncompleteFlashcards() {
    return areThereIncompleteEditorFlashcards(
      _getEditorFlashcardsWithoutLastOne(),
    );
  }
}

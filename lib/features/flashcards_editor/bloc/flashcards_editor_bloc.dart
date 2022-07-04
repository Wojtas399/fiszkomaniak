import 'package:fiszkomaniak/domain/use_cases/flashcards/save_edited_flashcards_use_case.dart';
import 'package:fiszkomaniak/domain/use_cases/groups/get_group_use_case.dart';
import 'package:fiszkomaniak/features/flashcards_editor/flashcards_editor_dialogs.dart';
import 'package:fiszkomaniak/features/flashcards_editor/bloc/flashcards_editor_event.dart';
import 'package:fiszkomaniak/features/flashcards_editor/bloc/flashcards_editor_state.dart';
import 'package:fiszkomaniak/features/flashcards_editor/bloc/flashcards_editor_utils.dart';
import 'package:fiszkomaniak/domain/entities/flashcard.dart';
import 'package:fiszkomaniak/domain/entities/group.dart';
import 'package:fiszkomaniak/models/bloc_status.dart';
import 'package:fiszkomaniak/utils/utils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FlashcardsEditorBloc
    extends Bloc<FlashcardsEditorEvent, FlashcardsEditorState> {
  late final GetGroupUseCase _getGroupUseCase;
  late final SaveEditedFlashcardsUseCase _saveEditedFlashcardsUseCase;
  late final FlashcardsEditorDialogs _flashcardsEditorDialogs;
  late final FlashcardsEditorUtils _flashcardsEditorUtils;

  FlashcardsEditorBloc({
    required GetGroupUseCase getGroupUseCase,
    required SaveEditedFlashcardsUseCase saveEditedFlashcardsUseCase,
    required FlashcardsEditorDialogs flashcardsEditorDialogs,
    required FlashcardsEditorUtils flashcardsEditorUtils,
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
    _flashcardsEditorDialogs = flashcardsEditorDialogs;
    _flashcardsEditorUtils = flashcardsEditorUtils;
    on<FlashcardsEditorEventInitialize>(_initialize);
    on<FlashcardsEditorEventRemoveFlashcard>(_removeFlashcard);
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
        _flashcardsEditorUtils.createInitialEditorFlashcards(group.flashcards);
    emit(state.copyWith(
      group: group,
      editorFlashcards: editorFlashcards,
      keyCounter: editorFlashcards.length - 1,
    ));
  }

  Future<void> _removeFlashcard(
    FlashcardsEditorEventRemoveFlashcard event,
    Emitter<FlashcardsEditorState> emit,
  ) async {
    if (await _hasFlashcardRemovalBeenConfirmed()) {
      List<EditorFlashcard> updatedEditorFlashcards = [
        ...state.editorFlashcards,
      ];
      updatedEditorFlashcards.removeAt(event.flashcardIndex);
      int keyCounter = state.keyCounter;
      if (updatedEditorFlashcards.isEmpty) {
        updatedEditorFlashcards = _flashcardsEditorUtils.addNewEditorFlashcard(
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
    updatedEditorFlashcards = _flashcardsEditorUtils
        .removeEmptyEditorFlashcardsApartFromLastAndEditedOne(
      updatedEditorFlashcards,
      event.flashcardIndex,
    );
    int keyCounter = state.keyCounter;
    if (event.flashcardIndex == updatedEditorFlashcards.length - 1) {
      keyCounter++;
      updatedEditorFlashcards = _flashcardsEditorUtils.addNewEditorFlashcard(
        updatedEditorFlashcards,
        keyCounter,
      );
    }
    if (_isThereAtLeastOneFlashcardMarkedAsIncomplete()) {
      updatedEditorFlashcards = _flashcardsEditorUtils
          .updateCompletionStatusInEditorFlashcardsMarkedAsIncomplete(
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
    if (group != null && await _canSave(emit)) {
      emit(state.copyWith(
        status: const BlocStatusLoading(),
      ));
      final List<Flashcard> flashcardsToSave =
          _flashcardsEditorUtils.convertEditorFlashcardsToFlashcards(
        _getEditorFlashcardsWithoutLastOne(),
      );
      await _saveEditedFlashcardsUseCase.execute(
        groupId: group.id,
        flashcards: flashcardsToSave,
      );
      emit(state.copyWith(
        status: const BlocStatusComplete<FlashcardsEditorInfoType>(
          info: FlashcardsEditorInfoType.editedFlashcardsHaveBeenSaved,
        ),
      ));
    }
  }

  Future<bool> _hasFlashcardRemovalBeenConfirmed() async {
    return await _flashcardsEditorDialogs.askForDeleteConfirmation();
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

  Future<bool> _canSave(Emitter<FlashcardsEditorState> emit) async {
    if (_areEditorFlashcardsSameAsGroupFlashcards()) {
      emit(state.copyWith(
        status: const BlocStatusComplete<FlashcardsEditorInfoType>(
          info: FlashcardsEditorInfoType.noChangesHaveBeenMade,
        ),
      ));
      return false;
    }
    if (_areThereIncompleteFlashcards()) {
      final List<EditorFlashcard> updatedEditorFlashcards =
          _flashcardsEditorUtils.updateEditorFlashcardsCompletionStatuses(
        state.editorFlashcards,
      );
      emit(state.copyWith(
        status: const BlocStatusComplete<FlashcardsEditorInfoType>(
          info: FlashcardsEditorInfoType.incompleteFlashcardsExist,
        ),
        editorFlashcards: updatedEditorFlashcards,
      ));
      return false;
    }
    return await _flashcardsEditorDialogs.askForSaveConfirmation() == true;
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
    return _flashcardsEditorUtils.areEditorFlashcardsSameAsGroupFlashcards(
      groupFlashcards,
      editorFlashcards,
    );
  }

  bool _areThereIncompleteFlashcards() {
    return _flashcardsEditorUtils.areThereIncompleteEditorFlashcards(
      _getEditorFlashcardsWithoutLastOne(),
    );
  }
}

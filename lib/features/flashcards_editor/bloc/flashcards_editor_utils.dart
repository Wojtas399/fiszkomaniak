import 'package:fiszkomaniak/utils/utils.dart';
import '../../../domain/entities/flashcard.dart';
import 'flashcards_editor_state.dart';

class FlashcardsEditorUtils {
  List<EditorFlashcard> createInitialEditorFlashcards(
    List<Flashcard> flashcards,
  ) {
    List<EditorFlashcard> editorFlashcards =
        flashcards.map(_createEditorFlashcard).toList();
    return addNewEditorFlashcard(editorFlashcards, editorFlashcards.length);
  }

  List<EditorFlashcard> removeEmptyEditorFlashcardsApartFromLastAndEditedOne(
    List<EditorFlashcard> editorFlashcards,
    int indexOfEditedFlashcard,
  ) {
    final List<EditorFlashcard> updatedEditorFlashcards =
        Utils.removeLastElement(editorFlashcards);
    updatedEditorFlashcards.removeWhere(
      (editorFlashcard) =>
          editorFlashcards.indexOf(editorFlashcard) != indexOfEditedFlashcard &&
          _isFlashcardEmpty(editorFlashcard),
    );
    updatedEditorFlashcards.add(editorFlashcards.last);
    return updatedEditorFlashcards;
  }

  List<EditorFlashcard> addNewEditorFlashcard(
    List<EditorFlashcard> editorFlashcards,
    int keyNumber,
  ) {
    final List<EditorFlashcard> updatedEditorFlashcards = [...editorFlashcards];
    updatedEditorFlashcards.add(
      EditorFlashcard(
        key: 'flashcard$keyNumber',
        question: '',
        answer: '',
        flashcardStatus: FlashcardStatus.notRemembered,
        completionStatus: EditorFlashcardCompletionStatus.unknown,
      ),
    );
    return updatedEditorFlashcards;
  }

  List<EditorFlashcard>
      updateCompletionStatusInEditorFlashcardsMarkedAsIncomplete(
    List<EditorFlashcard> editorFlashcards,
  ) {
    return editorFlashcards.map(
      (editorFlashcard) {
        if (_isFlashcardMarkedAsIncomplete(editorFlashcard) &&
            _isFlashcardComplete(editorFlashcard)) {
          return editorFlashcard.copyWith(
            completionStatus: EditorFlashcardCompletionStatus.complete,
          );
        }
        return editorFlashcard;
      },
    ).toList();
  }

  List<Flashcard> convertEditorFlashcardsToFlashcards(
    List<EditorFlashcard> editorFlashcards,
  ) {
    return editorFlashcards
        .asMap()
        .entries
        .map(
          (entry) => Flashcard(
            index: entry.key,
            question: entry.value.question,
            answer: entry.value.answer,
            status: entry.value.flashcardStatus,
          ),
        )
        .toList();
  }

  List<EditorFlashcard> updateEditorFlashcardsCompletionStatuses(
    List<EditorFlashcard> editorFlashcards,
  ) {
    return editorFlashcards.asMap().entries.map(
      (entry) {
        if (_isFlashcardComplete(entry.value)) {
          return entry.value.copyWith(
            completionStatus: EditorFlashcardCompletionStatus.complete,
          );
        } else if (entry.key != editorFlashcards.length - 1) {
          return entry.value.copyWith(
            completionStatus: EditorFlashcardCompletionStatus.incomplete,
          );
        }
        return entry.value;
      },
    ).toList();
  }

  bool areEditorFlashcardsSameAsGroupFlashcards(
    List<Flashcard> groupFlashcards,
    List<EditorFlashcard> editorFlashcards,
  ) {
    final List<Flashcard> convertedEditorFlashcards =
        convertEditorFlashcardsToFlashcards(editorFlashcards);
    for (final flashcard in convertedEditorFlashcards) {
      if (!groupFlashcards.contains(flashcard)) {
        return false;
      }
    }
    return true;
  }

  bool areThereIncompleteEditorFlashcards(
    List<EditorFlashcard> editorFlashcards,
  ) {
    for (final editorFlashcard in editorFlashcards) {
      if (_isFlashcardIncomplete(editorFlashcard)) {
        return true;
      }
    }
    return false;
  }

  EditorFlashcard _createEditorFlashcard(Flashcard flashcard) {
    return EditorFlashcard(
      key: 'flashcard${flashcard.index}',
      question: flashcard.question,
      answer: flashcard.answer,
      flashcardStatus: flashcard.status,
      completionStatus: EditorFlashcardCompletionStatus.complete,
    );
  }

  bool _isFlashcardEmpty(EditorFlashcard editorFlashcard) {
    return editorFlashcard.question.isEmpty && editorFlashcard.answer.isEmpty;
  }

  bool _isFlashcardComplete(EditorFlashcard editorFlashcard) {
    return editorFlashcard.question.isNotEmpty &&
        editorFlashcard.answer.isNotEmpty;
  }

  bool _isFlashcardIncomplete(EditorFlashcard editorFlashcard) {
    return editorFlashcard.question.isEmpty || editorFlashcard.answer.isEmpty;
  }

  bool _isFlashcardMarkedAsIncomplete(EditorFlashcard editorFlashcard) {
    return editorFlashcard.completionStatus ==
        EditorFlashcardCompletionStatus.incomplete;
  }
}

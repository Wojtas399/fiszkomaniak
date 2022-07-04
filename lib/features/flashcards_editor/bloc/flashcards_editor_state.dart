import 'package:equatable/equatable.dart';
import 'package:fiszkomaniak/domain/entities/flashcard.dart';
import 'package:fiszkomaniak/domain/entities/group.dart';
import 'package:fiszkomaniak/models/bloc_status.dart';

class FlashcardsEditorState extends Equatable {
  final BlocStatus status;
  final Group? group;
  final List<EditorFlashcard> editorFlashcards;
  final int keyCounter;

  const FlashcardsEditorState({
    required this.status,
    required this.group,
    required this.editorFlashcards,
    required this.keyCounter,
  });

  @override
  List<Object> get props => [
        status,
        group ?? '',
        editorFlashcards,
        keyCounter,
      ];

  bool isEditorFlashcardMarkedAsIncomplete(EditorFlashcard editorFlashcard) {
    return editorFlashcard.completionStatus ==
        EditorFlashcardCompletionStatus.incomplete;
  }

  FlashcardsEditorState copyWith({
    BlocStatus? status,
    Group? group,
    List<EditorFlashcard>? editorFlashcards,
    int? keyCounter,
  }) {
    return FlashcardsEditorState(
      status: status ?? const BlocStatusComplete<FlashcardsEditorInfoType>(),
      group: group ?? this.group,
      editorFlashcards: editorFlashcards ?? this.editorFlashcards,
      keyCounter: keyCounter ?? this.keyCounter,
    );
  }
}

class EditorFlashcard extends Equatable {
  final String key;
  final String question;
  final String answer;
  final FlashcardStatus flashcardStatus;
  final EditorFlashcardCompletionStatus completionStatus;

  const EditorFlashcard({
    required this.key,
    required this.question,
    required this.answer,
    required this.flashcardStatus,
    required this.completionStatus,
  });

  EditorFlashcard copyWith({
    String? key,
    String? question,
    String? answer,
    EditorFlashcardCompletionStatus? completionStatus,
  }) {
    return EditorFlashcard(
      key: key ?? this.key,
      question: question ?? this.question,
      answer: answer ?? this.answer,
      flashcardStatus: flashcardStatus,
      completionStatus: completionStatus ?? this.completionStatus,
    );
  }

  @override
  List<Object> get props => [
        key,
        question,
        answer,
        flashcardStatus,
        completionStatus,
      ];
}

enum EditorFlashcardCompletionStatus {
  unknown,
  complete,
  incomplete,
}

EditorFlashcard createEditorFlashcard({
  String? key,
  String? question,
  String? answer,
  FlashcardStatus? flashcardStatus,
  EditorFlashcardCompletionStatus? completionStatus,
}) {
  return EditorFlashcard(
    key: key ?? '',
    question: question ?? '',
    answer: answer ?? '',
    flashcardStatus: flashcardStatus ?? FlashcardStatus.notRemembered,
    completionStatus:
        completionStatus ?? EditorFlashcardCompletionStatus.unknown,
  );
}

enum FlashcardsEditorInfoType {
  noChangesHaveBeenMade,
  incompleteFlashcardsExist,
  editedFlashcardsHaveBeenSaved,
}

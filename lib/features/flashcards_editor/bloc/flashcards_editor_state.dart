import 'package:equatable/equatable.dart';
import 'package:fiszkomaniak/models/flashcard_model.dart';
import 'package:fiszkomaniak/models/group_model.dart';

class FlashcardsEditorState extends Equatable {
  final Group? group;
  final List<EditorFlashcard> flashcards;
  final int keyCounter;

  List<Flashcard> get flashcardsWithoutLastOne => flashcards
      .getRange(0, flashcards.length - 1)
      .map((flashcard) => flashcard.doc)
      .toList();

  bool get areIncorrectFlashcards {
    for (final flashcard in flashcards) {
      if (!flashcard.isCorrect) {
        return true;
      }
    }
    return false;
  }

  const FlashcardsEditorState({
    this.group,
    this.flashcards = const [],
    this.keyCounter = 0,
  });

  FlashcardsEditorState copyWith({
    Group? group,
    List<EditorFlashcard>? flashcards,
    int? keyCounter,
  }) {
    return FlashcardsEditorState(
      group: group ?? this.group,
      flashcards: flashcards ?? this.flashcards,
      keyCounter: keyCounter ?? this.keyCounter,
    );
  }

  @override
  List<Object> get props => [
        group ?? createGroup(),
        flashcards,
        keyCounter,
      ];
}

class EditorFlashcard extends Equatable {
  final String key;
  final bool isCorrect;
  final Flashcard doc;

  const EditorFlashcard({
    required this.key,
    required this.isCorrect,
    required this.doc,
  });

  EditorFlashcard copyWith({
    String? key,
    bool? isCorrect,
    Flashcard? doc,
  }) {
    return EditorFlashcard(
      key: key ?? this.key,
      isCorrect: isCorrect ?? this.isCorrect,
      doc: doc ?? this.doc,
    );
  }

  @override
  List<Object> get props => [
        key,
        isCorrect,
        doc,
      ];
}

EditorFlashcard createEditorFlashcard({
  String key = '',
  bool isCorrect = true,
  Flashcard doc = const Flashcard(
    index: 0,
    question: '',
    answer: '',
    status: FlashcardStatus.notRemembered,
  ),
}) {
  return EditorFlashcard(
    key: key,
    isCorrect: isCorrect,
    doc: doc,
  );
}

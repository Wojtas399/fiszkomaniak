import 'package:equatable/equatable.dart';
import 'package:fiszkomaniak/models/flashcard_model.dart';
import 'package:fiszkomaniak/models/group_model.dart';

class FlashcardsEditorState extends Equatable {
  final Group? group;
  final List<EditorFlashcard> flashcards;
  final int keyCounter;

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
  final Flashcard doc;

  const EditorFlashcard({
    required this.key,
    required this.doc,
  });

  EditorFlashcard copyWith({
    int? index,
    String? key,
    Flashcard? doc,
  }) {
    return EditorFlashcard(
      key: key ?? this.key,
      doc: doc ?? this.doc,
    );
  }

  @override
  List<Object> get props => [
        key,
        doc,
      ];
}

EditorFlashcard createFlashcardsEditorItemParams({
  String key = '',
  Flashcard doc = const Flashcard(
    id: '',
    groupId: '',
    question: '',
    answer: '',
    status: FlashcardStatus.notRemembered,
  ),
}) {
  return EditorFlashcard(
    key: key,
    doc: doc,
  );
}

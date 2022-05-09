import 'package:fiszkomaniak/features/flashcards_editor/flashcards_editor_mode.dart';

abstract class FlashcardsEditorEvent {}

class FlashcardsEditorEventInitialize extends FlashcardsEditorEvent {
  final FlashcardsEditorMode mode;

  FlashcardsEditorEventInitialize({required this.mode});
}

class FlashcardsEditorEventRemoveFlashcard extends FlashcardsEditorEvent {
  final int indexOfFlashcard;

  FlashcardsEditorEventRemoveFlashcard({required this.indexOfFlashcard});
}

class FlashcardsEditorEventValueChanged extends FlashcardsEditorEvent {
  final int indexOfFlashcard;
  final String? question;
  final String? answer;

  FlashcardsEditorEventValueChanged({
    required this.indexOfFlashcard,
    this.question,
    this.answer,
  });
}

class FlashcardsEditorEventSave extends FlashcardsEditorEvent {}

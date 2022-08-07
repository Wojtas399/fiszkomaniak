part of 'flashcards_editor_bloc.dart';

abstract class FlashcardsEditorEvent {}

class FlashcardsEditorEventInitialize extends FlashcardsEditorEvent {
  final String groupId;

  FlashcardsEditorEventInitialize({required this.groupId});
}

class FlashcardsEditorEventRemoveFlashcard extends FlashcardsEditorEvent {
  final int flashcardIndex;

  FlashcardsEditorEventRemoveFlashcard({required this.flashcardIndex});
}

class FlashcardsEditorEventValueChanged extends FlashcardsEditorEvent {
  final int flashcardIndex;
  final String? question;
  final String? answer;

  FlashcardsEditorEventValueChanged({
    required this.flashcardIndex,
    this.question,
    this.answer,
  });
}

class FlashcardsEditorEventSave extends FlashcardsEditorEvent {}

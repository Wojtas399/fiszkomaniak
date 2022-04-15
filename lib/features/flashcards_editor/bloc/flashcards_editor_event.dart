abstract class FlashcardsEditorEvent {}

class FlashcardsEditorEventInitialize extends FlashcardsEditorEvent {
  final String groupId;

  FlashcardsEditorEventInitialize({required this.groupId});
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

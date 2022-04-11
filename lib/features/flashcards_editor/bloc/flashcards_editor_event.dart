abstract class FlashcardsEditorEvent {}

class FlashcardsEditorEventInitialize extends FlashcardsEditorEvent {
  final String groupId;

  FlashcardsEditorEventInitialize({required this.groupId});
}

class FlashcardsEditorEventAddFlashcard extends FlashcardsEditorEvent {}

class FlashcardsEditorEventRemoveFlashcard extends FlashcardsEditorEvent {
  final int indexOfFlashcard;

  FlashcardsEditorEventRemoveFlashcard({required this.indexOfFlashcard});
}

class FlashcardsEditorEventQuestionChanged extends FlashcardsEditorEvent {
  final int indexOfFlashcard;
  final String question;

  FlashcardsEditorEventQuestionChanged({
    required this.indexOfFlashcard,
    required this.question,
  });
}

class FlashcardsEditorEventAnswerChanged extends FlashcardsEditorEvent {
  final int indexOfFlashcard;
  final String answer;

  FlashcardsEditorEventAnswerChanged({
    required this.indexOfFlashcard,
    required this.answer,
  });
}

class FlashcardsEditorEventSave extends FlashcardsEditorEvent {}

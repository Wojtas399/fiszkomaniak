import 'package:equatable/equatable.dart';
import 'package:fiszkomaniak/models/flashcard_model.dart';
import 'package:fiszkomaniak/models/group_model.dart';

class FlashcardsEditorState extends Equatable {
  final Group? group;
  final List<FlashcardsEditorItemParams> flashcards;

  List<FlashcardsEditorItemParams> get newFlashcards => flashcards
      .where(
        (flashcard) =>
            flashcard.isNew &&
            flashcard.doc.question.isNotEmpty &&
            flashcard.doc.answer.isNotEmpty,
      )
      .toList();

  const FlashcardsEditorState({
    this.group,
    this.flashcards = const [],
  });

  FlashcardsEditorState copyWith({
    Group? group,
    List<FlashcardsEditorItemParams>? flashcards,
  }) {
    return FlashcardsEditorState(
      group: group ?? this.group,
      flashcards: flashcards ?? this.flashcards,
    );
  }

  @override
  List<Object> get props => [
        group ?? createGroup(),
        flashcards,
      ];
}

class FlashcardsEditorItemParams extends Equatable {
  final int index;
  final bool isNew;
  final Flashcard doc;

  const FlashcardsEditorItemParams({
    required this.index,
    required this.isNew,
    required this.doc,
  });

  FlashcardsEditorItemParams copyWith({
    int? index,
    bool? isNew,
    Flashcard? doc,
  }) {
    return FlashcardsEditorItemParams(
      index: index ?? this.index,
      isNew: isNew ?? this.isNew,
      doc: doc ?? this.doc,
    );
  }

  @override
  List<Object> get props => [
        index,
        isNew,
        doc,
      ];
}

FlashcardsEditorItemParams createFlashcardsEditorItemParams({
  int index = 0,
  bool isNew = true,
  Flashcard doc = const Flashcard(
    id: '',
    groupId: '',
    question: '',
    answer: '',
    status: FlashcardStatus.notRemembered,
  ),
}) {
  return FlashcardsEditorItemParams(
    index: index,
    isNew: isNew,
    doc: doc,
  );
}

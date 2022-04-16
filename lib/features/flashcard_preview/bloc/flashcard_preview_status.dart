import 'package:equatable/equatable.dart';

abstract class FlashcardPreviewStatus extends Equatable {
  const FlashcardPreviewStatus();

  @override
  List<Object> get props => [];
}

class FlashcardPreviewStatusInitial extends FlashcardPreviewStatus {
  const FlashcardPreviewStatusInitial();
}

class FlashcardPreviewStatusLoaded extends FlashcardPreviewStatus {}

class FlashcardPreviewStatusQuestionChanged extends FlashcardPreviewStatus {}

class FlashcardPreviewStatusAnswerChanged extends FlashcardPreviewStatus {}

class FlashcardPreviewStatusReset extends FlashcardPreviewStatus {}

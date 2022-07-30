import 'package:equatable/equatable.dart';

enum FlashcardStatus {
  remembered,
  notRemembered,
}

class Flashcard extends Equatable {
  final int index;
  final String question;
  final String answer;
  final FlashcardStatus status;

  const Flashcard({
    required this.index,
    required this.question,
    required this.answer,
    required this.status,
  });

  Flashcard copyWith({
    int? index,
    String? groupId,
    String? question,
    String? answer,
    FlashcardStatus? status,
  }) {
    return Flashcard(
      index: index ?? this.index,
      question: question ?? this.question,
      answer: answer ?? this.answer,
      status: status ?? this.status,
    );
  }

  @override
  List<Object> get props => [
        index,
        question,
        answer,
        status,
      ];

  String getId({required String groupId}) {
    return '$groupId-$index';
  }
}

Flashcard createFlashcard({
  int index = 0,
  String question = '',
  String answer = '',
  FlashcardStatus status = FlashcardStatus.notRemembered,
}) {
  return Flashcard(
    index: index,
    question: question,
    answer: answer,
    status: status,
  );
}

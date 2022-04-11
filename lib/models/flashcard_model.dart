import 'package:equatable/equatable.dart';

enum FlashcardStatus {
  remembered,
  notRemembered,
}

class Flashcard extends Equatable {
  final String id;
  final String groupId;
  final String question;
  final String answer;
  final FlashcardStatus status;

  const Flashcard({
    required this.id,
    required this.groupId,
    required this.question,
    required this.answer,
    required this.status,
  });

  Flashcard copyWith({
    String? id,
    String? groupId,
    String? question,
    String? answer,
    FlashcardStatus? status,
  }) {
    return Flashcard(
      id: id ?? this.id,
      groupId: groupId ?? this.groupId,
      question: question ?? this.question,
      answer: answer ?? this.answer,
      status: status ?? this.status,
    );
  }

  @override
  List<Object> get props => [
        id,
        question,
        answer,
        status,
        groupId,
      ];
}

Flashcard createFlashcard({
  String id = '',
  String question = '',
  String answer = '',
  FlashcardStatus status = FlashcardStatus.notRemembered,
  String groupId = '',
}) {
  return Flashcard(
    id: id,
    question: question,
    answer: answer,
    status: status,
    groupId: groupId,
  );
}

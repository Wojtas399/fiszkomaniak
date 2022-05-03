import 'package:equatable/equatable.dart';

class FlashcardDbModel extends Equatable {
  final int index;
  final String question;
  final String answer;
  final String status;

  const FlashcardDbModel({
    required this.index,
    required this.question,
    required this.answer,
    required this.status,
  });

  FlashcardDbModel.fromJson(int index, Map<String, Object?> json)
      : this(
          index: index,
          question: json['question']! as String,
          answer: json['answer']! as String,
          status: json['status']! as String,
        );

  Map<String, String?> toJson() {
    return {
      'question': question,
      'answer': answer,
      'status': status,
    }..removeWhere((key, value) => value == null);
  }

  @override
  List<Object> get props => [
        index,
        question,
        answer,
        status,
      ];
}

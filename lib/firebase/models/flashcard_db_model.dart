import 'package:equatable/equatable.dart';

class FlashcardDbModel extends Equatable {
  final String? groupId;
  final String? question;
  final String? answer;
  final String? status;

  const FlashcardDbModel({
    required this.groupId,
    required this.question,
    required this.answer,
    required this.status,
  });

  FlashcardDbModel.fromJson(Map<String, Object?> json)
      : this(
          question: json['question']! as String,
          answer: json['answer']! as String,
          groupId: json['groupId']! as String,
          status: json['status']! as String,
        );

  Map<String, String?> toJson() {
    return {
      'question': question,
      'answer': answer,
      'groupId': groupId,
      'status': status,
    }..removeWhere((key, value) => value == null);
  }

  @override
  List<Object> get props => [
        question ?? '',
        answer ?? '',
        groupId ?? '',
        status ?? '',
      ];
}

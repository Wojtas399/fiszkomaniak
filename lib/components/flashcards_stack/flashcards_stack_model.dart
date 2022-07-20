import 'package:equatable/equatable.dart';

class StackFlashcard extends Equatable {
  final int index;
  final String question;
  final String answer;

  const StackFlashcard({
    required this.index,
    required this.question,
    required this.answer,
  });

  @override
  List<Object> get props => [
        index,
        question,
        answer,
      ];
}

StackFlashcard createStackFlashcard({
  int? index,
  String? question,
  String? answer,
}) {
  return StackFlashcard(
    index: index ?? -1,
    question: question ?? '',
    answer: answer ?? '',
  );
}

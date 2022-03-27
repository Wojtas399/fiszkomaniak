import 'package:equatable/equatable.dart';

class Group extends Equatable {
  final String id;
  final String name;
  final String courseId;
  final String nameForQuestions;
  final String nameForAnswers;

  const Group({
    required this.id,
    required this.name,
    required this.courseId,
    required this.nameForQuestions,
    required this.nameForAnswers,
  });

  @override
  List<Object> get props => [
        id,
        name,
        courseId,
        nameForQuestions,
        nameForAnswers,
      ];
}

import 'package:equatable/equatable.dart';

class GroupDbModel extends Equatable {
  final String? name;
  final String? courseId;
  final String? nameForQuestions;
  final String? nameForAnswers;

  const GroupDbModel({
    required this.name,
    required this.courseId,
    required this.nameForQuestions,
    required this.nameForAnswers,
  });

  GroupDbModel.fromJson(Map<String, Object?> json)
      : this(
          name: json['name']! as String,
          courseId: json['courseId']! as String,
          nameForQuestions: json['nameForQuestions']! as String,
          nameForAnswers: json['nameForAnswers']! as String,
        );

  Map<String, String?> toJson() {
    return {
      'name': name,
      'courseId': courseId,
      'nameForQuestions': nameForQuestions,
      'nameForAnswers': nameForAnswers,
    }..removeWhere((key, value) => value == null);
  }

  @override
  List<Object> get props => [
        name ?? '',
        courseId ?? '',
        nameForQuestions ?? '',
        nameForAnswers ?? '',
      ];
}

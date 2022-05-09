import 'package:equatable/equatable.dart';
import 'package:fiszkomaniak/firebase/models/flashcard_db_model.dart';

class GroupDbModel extends Equatable {
  final String? name;
  final String? courseId;
  final String? nameForQuestions;
  final String? nameForAnswers;
  final List<FlashcardDbModel> flashcards;

  const GroupDbModel({
    this.name,
    this.courseId,
    this.nameForQuestions,
    this.nameForAnswers,
    this.flashcards = const [],
  });

  GroupDbModel.fromJson(Map<String, Object?> json)
      : this(
          name: json['name']! as String,
          courseId: json['courseId']! as String,
          nameForQuestions: json['nameForQuestions']! as String,
          nameForAnswers: json['nameForAnswers']! as String,
          flashcards: (json['flashcards']! as List)
              .asMap()
              .entries
              .map((entry) => FlashcardDbModel.fromJson(entry.key, entry.value))
              .toList(),
        );

  Map<String, Object?> toJson() {
    return {
      'name': name,
      'courseId': courseId,
      'nameForQuestions': nameForQuestions,
      'nameForAnswers': nameForAnswers,
      'flashcards': flashcards.map((flashcard) => flashcard.toJson()).toList(),
    }..removeWhere((key, value) => value == null);
  }

  @override
  List<Object> get props => [
        name ?? '',
        courseId ?? '',
        nameForQuestions ?? '',
        nameForAnswers ?? '',
        flashcards,
      ];
}

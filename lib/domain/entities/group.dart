import 'package:equatable/equatable.dart';
import 'package:fiszkomaniak/domain/entities/flashcard.dart';

class Group extends Equatable {
  final String id;
  final String name;
  final String courseId;
  final String nameForQuestions;
  final String nameForAnswers;
  final List<Flashcard> flashcards;

  const Group({
    required this.id,
    required this.name,
    required this.courseId,
    required this.nameForQuestions,
    required this.nameForAnswers,
    required this.flashcards,
  });

  Group copyWith({
    String? id,
    String? name,
    String? courseId,
    String? nameForQuestions,
    String? nameForAnswers,
    List<Flashcard>? flashcards,
  }) {
    return Group(
      id: id ?? this.id,
      name: name ?? this.name,
      courseId: courseId ?? this.courseId,
      nameForQuestions: nameForQuestions ?? this.nameForQuestions,
      nameForAnswers: nameForAnswers ?? this.nameForAnswers,
      flashcards: flashcards ?? this.flashcards,
    );
  }

  @override
  List<Object> get props => [
        id,
        name,
        courseId,
        nameForQuestions,
        nameForAnswers,
        flashcards,
      ];
}

Group createGroup({
  String id = '',
  String name = '',
  String courseId = '',
  String nameForQuestions = '',
  String nameForAnswers = '',
  List<Flashcard> flashcards = const [],
}) {
  return Group(
    id: id,
    name: name,
    courseId: courseId,
    nameForQuestions: nameForQuestions,
    nameForAnswers: nameForAnswers,
    flashcards: flashcards,
  );
}

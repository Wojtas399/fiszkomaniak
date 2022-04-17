import 'package:equatable/equatable.dart';
import 'package:fiszkomaniak/models/group_model.dart';

class GroupPreviewState extends Equatable {
  final Group? group;
  final String courseName;
  final int amountOfAllFlashcards;
  final int amountOfRememberedFlashcards;

  const GroupPreviewState({
    this.group,
    this.courseName = '',
    this.amountOfAllFlashcards = 0,
    this.amountOfRememberedFlashcards = 0,
  });

  GroupPreviewState copyWith({
    Group? group,
    String? courseName,
    int? amountOfAllFlashcards,
    int? amountOfRememberedFlashcards,
  }) {
    return GroupPreviewState(
      group: group ?? this.group,
      courseName: courseName ?? this.courseName,
      amountOfAllFlashcards:
          amountOfAllFlashcards ?? this.amountOfAllFlashcards,
      amountOfRememberedFlashcards:
          amountOfRememberedFlashcards ?? this.amountOfRememberedFlashcards,
    );
  }

  @override
  List<Object> get props => [
        group ?? createGroup(),
        courseName,
        amountOfAllFlashcards,
        amountOfRememberedFlashcards,
      ];
}

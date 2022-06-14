part of 'study_bloc.dart';

class StudyState extends Equatable {
  final List<GroupItemParams> groupsItems;

  const StudyState({
    this.groupsItems = const [],
  });

  @override
  List<Object> get props => [groupsItems];

  StudyState copyWith({
    List<GroupItemParams>? groupsItems,
  }) {
    return StudyState(
      groupsItems: groupsItems ?? this.groupsItems,
    );
  }
}

class GroupItemParams extends Equatable {
  final String groupId;
  final String groupName;
  final String courseName;
  final int amountOfAllFlashcards;
  final int amountOfRememberedFlashcards;

  const GroupItemParams({
    required this.groupId,
    required this.groupName,
    required this.courseName,
    required this.amountOfAllFlashcards,
    required this.amountOfRememberedFlashcards,
  });

  @override
  List<Object> get props => [
        groupId,
        groupName,
        courseName,
        amountOfAllFlashcards,
        amountOfRememberedFlashcards,
      ];
}

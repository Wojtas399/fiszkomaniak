part of 'group_selection_bloc.dart';

class GroupSelectionState extends Equatable {
  final BlocStatus status;
  final List<Course> allCourses;
  final List<Group> groupsFromCourse;
  final Course? selectedCourse;
  final Group? selectedGroup;

  const GroupSelectionState({
    required this.status,
    required this.allCourses,
    required this.groupsFromCourse,
    required this.selectedCourse,
    required this.selectedGroup,
  });

  @override
  List<Object> get props => [
        status,
        allCourses,
        groupsFromCourse,
        selectedCourse ?? createCourse(),
        selectedGroup ?? createGroup(),
      ];

  int get amountOfAllFlashcards => selectedGroup?.flashcards.length ?? 0;

  int get amountOfRememberedFlashcards =>
      selectedGroup?.flashcards.where(_isFlashcardRemembered).length ?? 0;

  bool get isButtonDisabled => selectedCourse == null || selectedGroup == null;

  GroupSelectionState copyWith({
    BlocStatus? status,
    List<Course>? allCourses,
    List<Group>? groupsFromCourse,
    Course? selectedCourse,
    Group? selectedGroup,
  }) {
    return GroupSelectionState(
      status: status ?? const BlocStatusInProgress(),
      allCourses: allCourses ?? this.allCourses,
      groupsFromCourse: groupsFromCourse ?? this.groupsFromCourse,
      selectedCourse: selectedCourse ?? this.selectedCourse,
      selectedGroup: selectedGroup,
    );
  }

  bool _isFlashcardRemembered(Flashcard flashcard) {
    return flashcard.status == FlashcardStatus.remembered;
  }
}

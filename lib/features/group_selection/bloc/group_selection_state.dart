part of 'group_selection_bloc.dart';

class GroupSelectionState extends Equatable {
  late final List<Course> _allCourses;
  late final List<Group> _groupsFromCourse;
  final Course? selectedCourse;
  final Group? selectedGroup;

  GroupSelectionState({
    List<Course> allCourses = const [],
    List<Group> groupsFromCourse = const [],
    this.selectedCourse,
    this.selectedGroup,
  }) {
    _allCourses = allCourses;
    _groupsFromCourse = groupsFromCourse;
  }

  Map<String, String> get coursesToSelect =>
      {for (final course in _allCourses) course.id: course.name};

  Map<String, String> get groupsFromCourseToSelect =>
      {for (final group in _groupsFromCourse) group.id: group.name};

  String? get nameForQuestions => selectedGroup?.nameForQuestions;

  String? get nameForAnswers => selectedGroup?.nameForAnswers;

  int get amountOfAllFlashcards => selectedGroup?.flashcards.length ?? 0;

  int get amountOfRememberedFlashcards =>
      selectedGroup?.flashcards
          .where((flashcard) => flashcard.status == FlashcardStatus.remembered)
          .length ??
      0;

  bool get isButtonDisabled => selectedCourse == null || selectedGroup == null;

  GroupSelectionState copyWith({
    List<Course>? allCourses,
    List<Group>? groupsFromCourse,
    Course? selectedCourse,
    Group? selectedGroup,
  }) {
    return GroupSelectionState(
      allCourses: allCourses ?? _allCourses,
      groupsFromCourse: groupsFromCourse ?? _groupsFromCourse,
      selectedCourse: selectedCourse ?? this.selectedCourse,
      selectedGroup: selectedGroup,
    );
  }

  @override
  List<Object> get props => [
        _allCourses,
        _groupsFromCourse,
        selectedCourse ?? createCourse(),
        selectedGroup ?? createGroup(),
      ];
}

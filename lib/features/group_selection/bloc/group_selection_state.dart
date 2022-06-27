part of 'group_selection_bloc.dart';

class GroupSelectionState extends Equatable {
  final BlocStatus status;
  late final List<Course> _allCourses;
  late final List<Group> _groupsFromCourse;
  final Course? selectedCourse;
  final Group? selectedGroup;

  GroupSelectionState({
    this.status = const BlocStatusInitial(),
    List<Course> allCourses = const [],
    List<Group> groupsFromCourse = const [],
    this.selectedCourse,
    this.selectedGroup,
  }) {
    _allCourses = allCourses;
    _groupsFromCourse = groupsFromCourse;
  }

  @override
  List<Object> get props => [
        status,
        _allCourses,
        _groupsFromCourse,
        selectedCourse ?? createCourse(),
        selectedGroup ?? createGroup(),
      ];

  Map<String, String> get coursesToSelect =>
      {for (final course in _allCourses) course.id: course.name};

  Map<String, String> get groupsFromCourseToSelect =>
      {for (final group in _groupsFromCourse) group.id: group.name};

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
      status: status ?? const BlocStatusComplete(),
      allCourses: allCourses ?? _allCourses,
      groupsFromCourse: groupsFromCourse ?? _groupsFromCourse,
      selectedCourse: selectedCourse ?? this.selectedCourse,
      selectedGroup: selectedGroup,
    );
  }

  bool _isFlashcardRemembered(Flashcard flashcard) {
    return flashcard.status == FlashcardStatus.remembered;
  }
}

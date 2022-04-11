import 'package:equatable/equatable.dart';
import 'package:fiszkomaniak/models/course_model.dart';
import 'package:fiszkomaniak/models/group_model.dart';

class GroupSelectionState extends Equatable {
  late final List<Course> _allCourses;
  late final List<Group> _groupsFromCourse;
  final Course? selectedCourse;
  final Group? selectedGroup;
  final int amountOfAllFlashcardsFromGroup;
  final int amountOfRememberedFlashcardsFromGroup;

  GroupSelectionState({
    List<Course> allCourses = const [],
    List<Group> groupsFromCourse = const [],
    this.selectedCourse,
    this.selectedGroup,
    this.amountOfAllFlashcardsFromGroup = 0,
    this.amountOfRememberedFlashcardsFromGroup = 0,
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

  bool get isButtonDisabled => selectedCourse == null || selectedGroup == null;

  GroupSelectionState copyWith({
    List<Course>? allCourses,
    List<Group>? groupsFromCourse,
    Course? selectedCourse,
    Group? selectedGroup,
    int? amountOfAllFlashcardsFromGroup,
    int? amountOfRememberedFlashcardsFromGroup,
  }) {
    return GroupSelectionState(
      allCourses: allCourses ?? _allCourses,
      groupsFromCourse: groupsFromCourse ?? _groupsFromCourse,
      selectedCourse: selectedCourse ?? this.selectedCourse,
      selectedGroup: selectedGroup,
      amountOfAllFlashcardsFromGroup:
          amountOfAllFlashcardsFromGroup ?? this.amountOfAllFlashcardsFromGroup,
      amountOfRememberedFlashcardsFromGroup:
          amountOfRememberedFlashcardsFromGroup ??
              this.amountOfRememberedFlashcardsFromGroup,
    );
  }

  @override
  List<Object> get props => [
        _allCourses,
        _groupsFromCourse,
        selectedCourse ?? createCourse(),
        selectedGroup ?? createGroup(),
        amountOfAllFlashcardsFromGroup,
        amountOfRememberedFlashcardsFromGroup,
      ];
}

part of 'group_creator_bloc.dart';

class GroupCreatorState extends Equatable {
  final GroupCreatorMode mode;
  final BlocStatus status;
  final Course? selectedCourse;
  final List<Course> allCourses;
  final String groupName;
  final String nameForQuestions;
  final String nameForAnswers;

  const GroupCreatorState({
    required this.mode,
    required this.status,
    required this.selectedCourse,
    required this.allCourses,
    required this.groupName,
    required this.nameForQuestions,
    required this.nameForAnswers,
  });

  @override
  List<Object> get props => [
        mode,
        status,
        selectedCourse ?? '',
        allCourses,
        groupName,
        nameForQuestions,
        nameForAnswers,
      ];

  bool get isButtonDisabled {
    final GroupCreatorMode mode = this.mode;
    bool areDataNotEntered = selectedCourse == null ||
        groupName.isEmpty ||
        nameForQuestions.isEmpty ||
        nameForAnswers.isEmpty;
    if (mode is GroupCreatorEditMode) {
      bool areTheSameData = selectedCourse?.id == mode.group.courseId &&
          groupName.trim() == mode.group.name &&
          nameForQuestions.trim() == mode.group.nameForQuestions &&
          nameForAnswers.trim() == mode.group.nameForAnswers;
      return areDataNotEntered || areTheSameData;
    }
    return areDataNotEntered;
  }

  GroupCreatorState copyWith({
    GroupCreatorMode? mode,
    BlocStatus? status,
    Course? selectedCourse,
    List<Course>? allCourses,
    String? groupName,
    String? nameForQuestions,
    String? nameForAnswers,
  }) {
    return GroupCreatorState(
      mode: mode ?? this.mode,
      status: status ?? const BlocStatusInProgress(),
      selectedCourse: selectedCourse ?? this.selectedCourse,
      allCourses: allCourses ?? this.allCourses,
      groupName: groupName ?? this.groupName,
      nameForQuestions: nameForQuestions ?? this.nameForQuestions,
      nameForAnswers: nameForAnswers ?? this.nameForAnswers,
    );
  }

  GroupCreatorState copyWithInfo(GroupCreatorInfo info) {
    return copyWith(
      status: BlocStatusComplete<GroupCreatorInfo>(
        info: info,
      ),
    );
  }

  GroupCreatorState copyWithError(GroupCreatorError error) {
    return copyWith(
      status: BlocStatusError<GroupCreatorError>(
        error: error,
      ),
    );
  }
}

enum GroupCreatorInfo {
  dataHaveBeenInitialized,
  groupHasBeenAdded,
  groupHasBeenUpdated,
}

enum GroupCreatorError {
  groupNameIsAlreadyTaken,
}

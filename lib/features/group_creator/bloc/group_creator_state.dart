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
    this.mode = const GroupCreatorCreateMode(),
    this.status = const BlocStatusInitial(),
    this.selectedCourse,
    this.allCourses = const [],
    this.groupName = '',
    this.nameForQuestions = '',
    this.nameForAnswers = '',
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
          groupName == mode.group.name &&
          nameForQuestions == mode.group.nameForQuestions &&
          nameForAnswers == mode.group.nameForAnswers;
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
      status: status ?? const BlocStatusComplete<GroupCreatorInfo>(),
      selectedCourse: selectedCourse ?? this.selectedCourse,
      allCourses: allCourses ?? this.allCourses,
      groupName: groupName ?? this.groupName,
      nameForQuestions: nameForQuestions ?? this.nameForQuestions,
      nameForAnswers: nameForAnswers ?? this.nameForAnswers,
    );
  }
}

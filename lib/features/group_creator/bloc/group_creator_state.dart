import 'package:equatable/equatable.dart';
import 'package:fiszkomaniak/features/group_creator/bloc/group_creator_status.dart';
import 'package:fiszkomaniak/models/course_model.dart';

class GroupCreatorState extends Equatable {
  final Course? selectedCourse;
  final List<Course> allCourses;
  final String groupName;
  final String nameForQuestions;
  final String nameForAnswers;
  final GroupCreatorStatus status;

  bool get isButtonDisabled =>
      selectedCourse == null ||
      groupName == '' ||
      nameForQuestions == '' ||
      nameForAnswers == '';

  const GroupCreatorState({
    this.selectedCourse,
    this.allCourses = const [],
    this.groupName = '',
    this.nameForQuestions = '',
    this.nameForAnswers = '',
    this.status = const GroupCreatorStatusInitial(),
  });

  GroupCreatorState copyWith({
    Course? selectedCourse,
    List<Course>? allCourses,
    String? groupName,
    String? nameForQuestions,
    String? nameForAnswers,
    GroupCreatorStatus? status,
  }) {
    return GroupCreatorState(
      selectedCourse: selectedCourse ?? this.selectedCourse,
      allCourses: allCourses ?? this.allCourses,
      groupName: groupName ?? this.groupName,
      nameForQuestions: nameForQuestions ?? this.nameForQuestions,
      nameForAnswers: nameForAnswers ?? this.nameForAnswers,
      status: status ?? GroupCreatorStatusEditing(),
    );
  }

  @override
  List<Object> get props => [
        selectedCourse ?? '',
        groupName,
        nameForQuestions,
        nameForAnswers,
        status,
      ];
}

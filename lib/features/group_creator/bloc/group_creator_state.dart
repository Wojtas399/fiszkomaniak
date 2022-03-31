import 'package:equatable/equatable.dart';
import 'package:fiszkomaniak/features/group_creator/bloc/group_creator_mode.dart';
import 'package:fiszkomaniak/models/course_model.dart';

class GroupCreatorState extends Equatable {
  final GroupCreatorMode mode;
  final Course? selectedCourse;
  final List<Course> allCourses;
  final String groupName;
  final String nameForQuestions;
  final String nameForAnswers;

  String get modeTitle {
    if (mode is GroupCreatorCreateMode) {
      return 'Nowa grupa';
    } else if (mode is GroupCreatorEditMode) {
      return 'Edycja grupy';
    }
    return '';
  }

  String get modeButtonText {
    if (mode is GroupCreatorCreateMode) {
      return 'utwórz';
    } else if (mode is GroupCreatorEditMode) {
      return 'zapisz';
    }
    return '';
  }

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

  const GroupCreatorState({
    this.mode = const GroupCreatorCreateMode(),
    this.selectedCourse,
    this.allCourses = const [],
    this.groupName = '',
    this.nameForQuestions = '',
    this.nameForAnswers = '',
  });

  GroupCreatorState copyWith({
    GroupCreatorMode? mode,
    Course? selectedCourse,
    List<Course>? allCourses,
    String? groupName,
    String? nameForQuestions,
    String? nameForAnswers,
  }) {
    return GroupCreatorState(
      mode: mode ?? this.mode,
      selectedCourse: selectedCourse ?? this.selectedCourse,
      allCourses: allCourses ?? this.allCourses,
      groupName: groupName ?? this.groupName,
      nameForQuestions: nameForQuestions ?? this.nameForQuestions,
      nameForAnswers: nameForAnswers ?? this.nameForAnswers,
    );
  }

  @override
  List<Object> get props => [
        mode,
        selectedCourse ?? '',
        groupName,
        nameForQuestions,
        nameForAnswers,
      ];
}

part of 'course_creator_bloc.dart';

class CourseCreatorState extends Equatable {
  final BlocStatus status;
  final CourseCreatorMode mode;
  final String courseName;

  const CourseCreatorState({
    required this.status,
    required this.mode,
    required this.courseName,
  });

  @override
  List<Object> get props => [
        status,
        mode,
        courseName,
      ];

  bool get isButtonDisabled {
    final CourseCreatorMode mode = this.mode;
    if (mode is CourseCreatorEditMode) {
      return courseName == mode.course.name || courseName.isEmpty;
    }
    return courseName.isEmpty;
  }

  CourseCreatorState copyWith({
    BlocStatus? status,
    CourseCreatorMode? mode,
    String? courseName,
  }) {
    return CourseCreatorState(
      status: status ?? const BlocStatusInProgress(),
      mode: mode ?? this.mode,
      courseName: courseName ?? this.courseName,
    );
  }

  CourseCreatorState copyWithInfoType(CourseCreatorInfoType infoType) {
    return copyWith(
      status: BlocStatusComplete<CourseCreatorInfoType>(info: infoType),
    );
  }
}

enum CourseCreatorInfoType {
  courseNameIsAlreadyTaken,
  courseHasBeenAdded,
  courseHasBeenUpdated,
}

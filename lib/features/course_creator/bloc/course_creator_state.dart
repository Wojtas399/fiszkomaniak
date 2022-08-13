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

  CourseCreatorState copyWithInfo(CourseCreatorInfo info) {
    return copyWith(
      status: BlocStatusComplete<CourseCreatorInfo>(info: info),
    );
  }

  CourseCreatorState copyWithError(CourseCreatorError error) {
    return copyWith(
      status: BlocStatusError<CourseCreatorError>(error: error),
    );
  }
}

enum CourseCreatorInfo {
  courseHasBeenAdded,
  courseHasBeenUpdated,
}

enum CourseCreatorError {
  courseNameIsAlreadyTaken,
}

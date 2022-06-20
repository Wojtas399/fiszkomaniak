part of 'course_creator_bloc.dart';

class CourseCreatorState extends Equatable {
  final BlocStatus status;
  final CourseCreatorMode mode;
  final String courseName;

  const CourseCreatorState({
    this.status = const BlocStatusInitial(),
    this.mode = const CourseCreatorCreateMode(),
    this.courseName = '',
  });

  @override
  List<Object> get props => [
        status,
        mode,
        courseName,
      ];

  CourseCreatorState copyWith({
    BlocStatus? status,
    CourseCreatorMode? mode,
    String? courseName,
  }) {
    return CourseCreatorState(
      status: status ?? const BlocStatusComplete(),
      mode: mode ?? this.mode,
      courseName: courseName ?? this.courseName,
    );
  }

  bool get isButtonDisabled {
    final CourseCreatorMode mode = this.mode;
    if (mode is CourseCreatorEditMode) {
      return courseName == mode.course.name || courseName.isEmpty;
    }
    return courseName.isEmpty;
  }
}

enum CourseCreatorInfoType {
  courseNameIsAlreadyTaken,
  courseHasBeenAdded,
  courseHasBeenUpdated,
}

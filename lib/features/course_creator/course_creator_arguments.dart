import 'package:equatable/equatable.dart';

abstract class CourseCreatorMode extends Equatable {
  const CourseCreatorMode();

  @override
  List<Object> get props => [];
}

class CourseCreatorCreateMode extends CourseCreatorMode {
  const CourseCreatorCreateMode();
}

class CourseCreatorEditMode extends CourseCreatorMode {
  final String courseId;
  final String courseName;

  const CourseCreatorEditMode({
    required this.courseId,
    required this.courseName,
  });

  @override
  List<Object> get props => [
        courseId,
        courseName,
      ];
}

import 'package:equatable/equatable.dart';
import 'package:fiszkomaniak/domain/entities/course.dart';

abstract class CourseCreatorMode extends Equatable {
  const CourseCreatorMode();

  @override
  List<Object> get props => [];
}

class CourseCreatorCreateMode extends CourseCreatorMode {
  const CourseCreatorCreateMode();
}

class CourseCreatorEditMode extends CourseCreatorMode {
  final Course course;

  const CourseCreatorEditMode({required this.course});

  @override
  List<Object> get props => [course];
}

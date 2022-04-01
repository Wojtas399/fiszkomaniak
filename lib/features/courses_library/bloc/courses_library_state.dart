import 'package:equatable/equatable.dart';
import '../../../models/course_model.dart';

class CoursesLibraryState extends Equatable {
  final List<Course> courses;

  const CoursesLibraryState({this.courses = const []});

  @override
  List<Object> get props => [courses];
}

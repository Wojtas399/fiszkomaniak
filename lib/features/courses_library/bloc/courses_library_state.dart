part of 'courses_library_bloc.dart';

class CoursesLibraryState extends Equatable {
  final List<Course> courses;

  const CoursesLibraryState({this.courses = const []});

  @override
  List<Object> get props => [courses];
}

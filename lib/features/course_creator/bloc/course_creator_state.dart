import 'package:equatable/equatable.dart';
import '../course_creator_mode.dart';

class CourseCreatorState extends Equatable {
  final CourseCreatorMode mode;
  final String courseName;

  bool get isButtonDisabled {
    final CourseCreatorMode mode = this.mode;
    if (mode is CourseCreatorEditMode) {
      return courseName == mode.course.name || courseName.isEmpty;
    }
    return courseName.isEmpty;
  }

  String get title {
    if (mode is CourseCreatorCreateMode) {
      return 'Nowy kurs';
    } else if (mode is CourseCreatorEditMode) {
      return 'Edycja kursu';
    }
    return '';
  }

  String get buttonText {
    if (mode is CourseCreatorCreateMode) {
      return 'utwórz';
    } else if (mode is CourseCreatorEditMode) {
      return 'zapisz';
    }
    return '';
  }

  const CourseCreatorState({
    this.mode = const CourseCreatorCreateMode(),
    this.courseName = '',
  });

  CourseCreatorState copyWith({
    CourseCreatorMode? mode,
    String? courseName,
  }) {
    return CourseCreatorState(
      mode: mode ?? this.mode,
      courseName: courseName ?? this.courseName,
    );
  }

  @override
  List<Object> get props => [
        mode,
        courseName,
      ];
}

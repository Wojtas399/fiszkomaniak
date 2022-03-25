import 'package:equatable/equatable.dart';
import 'package:fiszkomaniak/models/http_status_model.dart';
import '../course_creator_arguments.dart';

class CourseCreatorState extends Equatable {
  final CourseCreatorMode mode;
  final String? courseId;
  final String originalCourseName;
  final String courseName;
  final bool hasCourseNameBeenEdited;
  final HttpStatus httpStatus;

  bool get isButtonDisabled => originalCourseName == courseName;

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
    this.courseId,
    this.originalCourseName = '',
    this.courseName = '',
    this.hasCourseNameBeenEdited = false,
    this.httpStatus = const HttpStatusInitial(),
  });

  CourseCreatorState copyWith({
    CourseCreatorMode? mode,
    String? courseId,
    String? originalCourseName,
    String? courseName,
    bool? hasCourseNameBeenEdited,
    HttpStatus? httpStatus,
  }) {
    return CourseCreatorState(
      mode: mode ?? this.mode,
      courseId: courseId ?? this.courseId,
      originalCourseName: originalCourseName ?? this.originalCourseName,
      courseName: courseName ?? this.courseName,
      hasCourseNameBeenEdited:
          hasCourseNameBeenEdited ?? this.hasCourseNameBeenEdited,
      httpStatus: httpStatus ?? const HttpStatusInitial(),
    );
  }

  @override
  List<Object> get props => [
        mode,
        courseName,
        hasCourseNameBeenEdited,
        httpStatus,
      ];
}

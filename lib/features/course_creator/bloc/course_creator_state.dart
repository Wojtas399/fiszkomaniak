import 'package:equatable/equatable.dart';
import 'package:fiszkomaniak/models/http_status_model.dart';
import '../course_creator_mode.dart';

class CourseCreatorState extends Equatable {
  final CourseCreatorMode mode;
  final String courseName;
  final HttpStatus httpStatus;

  bool get isButtonDisabled {
    final CourseCreatorMode mode = this.mode;
    if (mode is CourseCreatorEditMode) {
      return courseName == mode.courseName || courseName.isEmpty;
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
    this.httpStatus = const HttpStatusInitial(),
  });

  CourseCreatorState copyWith({
    CourseCreatorMode? mode,
    String? courseName,
    HttpStatus? httpStatus,
  }) {
    return CourseCreatorState(
      mode: mode ?? this.mode,
      courseName: courseName ?? this.courseName,
      httpStatus: httpStatus ?? const HttpStatusInitial(),
    );
  }

  @override
  List<Object> get props => [
        mode,
        courseName,
        httpStatus,
      ];
}

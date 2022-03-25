abstract class CourseCreatorMode {
  const CourseCreatorMode();
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
}

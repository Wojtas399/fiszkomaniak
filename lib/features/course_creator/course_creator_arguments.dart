abstract class CourseCreatorMode {
  const CourseCreatorMode();
}

class CourseCreatorCreateMode extends CourseCreatorMode {
  const CourseCreatorCreateMode();
}

class CourseCreatorEditMode extends CourseCreatorMode {
  final String courseName;

  const CourseCreatorEditMode({required this.courseName});
}

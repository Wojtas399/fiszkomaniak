import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fiszkomaniak/firebase/models/course_db_model.dart';
import 'package:fiszkomaniak/firebase/services/fire_courses_service.dart';
import 'package:fiszkomaniak/interfaces/courses_interface.dart';
import 'package:fiszkomaniak/models/course_model.dart';
import 'package:rxdart/rxdart.dart';

class CoursesRepository implements CoursesInterface {
  final _courses$ = BehaviorSubject<List<Course>>.seeded([]);
  late final FireCoursesService _fireCoursesService;

  CoursesRepository({required FireCoursesService fireCoursesService}) {
    _fireCoursesService = fireCoursesService;
  }

  @override
  Stream<List<Course>> get allCourses$ => _courses$.stream;

  @override
  Future<void> loadCoursesByIds(List<String> coursesIds) async {
    //TODO
  }

  @override
  Future<void> loadAllCourses() async {
    final allCoursesFromDb = await _fireCoursesService.loadAllCourses();
    _courses$.add(
      allCoursesFromDb
          .map(_convertDbCourseToCourseModel)
          .whereType<Course>()
          .toList(),
    );
  }

  @override
  Future<void> addNewCourse({required String name}) async {
    await _fireCoursesService.addNewCourse(name);
  }

  @override
  Future<void> updateCourseName({
    required String courseId,
    required String newCourseName,
  }) async {
    await _fireCoursesService.updateCourseName(
      courseId: courseId,
      newName: newCourseName,
    );
  }

  @override
  Future<void> removeCourse({required String courseId}) async {
    await _fireCoursesService.removeCourse(courseId);
  }

  @override
  Stream<Course> getCourseById(String courseId) {
    if (_isCourseLoaded(courseId)) {
      return allCourses$.map(
        (courses) => courses.firstWhere((course) => course.id == courseId),
      );
    } else {
      return Rx.fromCallable(
        () async => await _loadCourseFromDb(courseId),
      ).whereType<Course>();
    }
  }

  @override
  Stream<String> getCourseNameById(String courseId) {
    return getCourseById(courseId).map((course) => course.name);
  }

  @override
  Future<bool> isThereCourseWithTheSameName(String courseName) async {
    final List<Course?> allCourses = [..._courses$.value];
    final Course? course = allCourses.firstWhere(
      (element) => element?.name == courseName,
      orElse: () => null,
    );
    if (course != null) {
      return true;
    }
    return await _fireCoursesService.isThereCourseWithTheName(
      courseName: courseName,
    );
  }

  Future<Course?> _loadCourseFromDb(String courseId) async {
    final courseFromDb = await _fireCoursesService.getCourseById(
      courseId: courseId,
    );
    final Course? course = _convertDbCourseToCourseModel(courseFromDb);
    if (course != null) {
      _addNewCourse(course);
      return course;
    }
    return null;
  }

  bool _isCourseLoaded(String courseId) {
    final List<Course> loadedCourses = _courses$.value;
    return loadedCourses.map((course) => course.id).contains(courseId);
  }

  Course? _convertDbCourseToCourseModel(DocumentSnapshot<CourseDbModel> doc) {
    final data = doc.data();
    if (data != null) {
      return Course(id: doc.id, name: data.name);
    }
    return null;
  }

  void _addNewCourse(Course course) {
    final updatedCourses = [..._courses$.value];
    updatedCourses.add(course);
    _courses$.add(updatedCourses);
  }
}

import 'package:fiszkomaniak/firebase/fire_document.dart';
import 'package:fiszkomaniak/firebase/models/course_db_model.dart';
import 'package:fiszkomaniak/firebase/services/fire_courses_service.dart';
import 'package:fiszkomaniak/interfaces/courses_interface.dart';
import 'package:fiszkomaniak/domain/entities/course.dart';
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
  Future<void> loadAllCourses() async {
    final allCoursesFromDb = await _fireCoursesService.loadAllCourses();
    _courses$.add(
      allCoursesFromDb
          .map(_convertCourseFromDbToCourseModel)
          .whereType<Course>()
          .toList(),
    );
  }

  @override
  Future<void> addNewCourse({required String name}) async {
    final courseFromDb = await _fireCoursesService.addNewCourse(name);
    if (courseFromDb != null) {
      final Course course = _convertCourseFromDbToCourseModel(courseFromDb);
      final courses = [..._courses$.value];
      courses.add(course);
      _courses$.add(courses);
    }
  }

  @override
  Future<void> updateCourseName({
    required String courseId,
    required String newCourseName,
  }) async {
    final updatedCourseFromDb = await _fireCoursesService.updateCourseName(
      courseId: courseId,
      newName: newCourseName,
    );
    if (updatedCourseFromDb != null) {
      final courses = [..._courses$.value];
      final updatedCourseIndex = courses.indexWhere(
        (course) => course.id == updatedCourseFromDb.id,
      );
      courses[updatedCourseIndex] = _convertCourseFromDbToCourseModel(
        updatedCourseFromDb,
      );
      _courses$.add(courses);
    }
  }

  @override
  Future<void> removeCourse({required String courseId}) async {
    final removedCourseId = await _fireCoursesService.removeCourse(courseId);
    final courses = [..._courses$.value];
    courses.removeWhere((course) => course.id == removedCourseId);
    _courses$.add(courses);
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
  Future<bool> isCourseNameAlreadyTaken(String courseName) async {
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
    if (courseFromDb != null) {
      final Course course = _convertCourseFromDbToCourseModel(courseFromDb);
      _addNewCourse(course);
      return course;
    }
    return null;
  }

  bool _isCourseLoaded(String courseId) {
    final List<Course> loadedCourses = _courses$.value;
    return loadedCourses.map((course) => course.id).contains(courseId);
  }

  Course _convertCourseFromDbToCourseModel(FireDocument<CourseDbModel> doc) {
    return Course(id: doc.id, name: doc.data.name);
  }

  void _addNewCourse(Course course) {
    if (!_isCourseLoaded(course.id)) {
      final updatedCourses = [..._courses$.value];
      updatedCourses.add(course);
      _courses$.add(updatedCourses);
    }
  }
}

import 'package:rxdart/rxdart.dart';
import '../../firebase/fire_document.dart';
import '../../firebase/models/course_db_model.dart';
import '../../firebase/services/fire_courses_service.dart';
import '../../interfaces/courses_interface.dart';
import '../entities/course.dart';

class CoursesRepository implements CoursesInterface {
  final _courses$ = BehaviorSubject<List<Course>>.seeded([]);
  late final FireCoursesService _fireCoursesService;

  CoursesRepository({required FireCoursesService fireCoursesService}) {
    _fireCoursesService = fireCoursesService;
  }

  @override
  Stream<List<Course>> get allCourses$ => _courses$.stream;

  @override
  Stream<Course> getCourseById(String courseId) {
    if (_isCourseLoaded(courseId)) {
      return allCourses$.map(
        (List<Course> courses) => courses.firstWhere(
          (Course course) => course.id == courseId,
        ),
      );
    } else {
      return Rx.fromCallable(
        () async => await _loadCourseFromDb(courseId),
      ).whereType<Course>();
    }
  }

  @override
  Stream<String> getCourseNameById(String courseId) {
    return getCourseById(courseId).map((Course course) => course.name);
  }

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
      _addCourseToList(course);
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
      final Course updatedCourse = _convertCourseFromDbToCourseModel(
        updatedCourseFromDb,
      );
      _updateCourseInList(updatedCourse);
    }
  }

  @override
  Future<void> deleteCourse({required String courseId}) async {
    final removedCourseId = await _fireCoursesService.removeCourse(courseId);
    _removeCourseFromList(removedCourseId);
  }

  @override
  Future<bool> isCourseNameAlreadyTaken(String courseName) async {
    final List<Course?> allCourses = [..._courses$.value];
    final Course? courseWithTheSameName = allCourses.firstWhere(
      (Course? course) => course?.name == courseName,
      orElse: () => null,
    );
    if (courseWithTheSameName != null) {
      return true;
    }
    return await _fireCoursesService.isThereCourseWithTheName(
      courseName: courseName,
    );
  }

  void _addCourseToList(Course course) {
    final List<Course> updatedCourses = [..._courses$.value];
    updatedCourses.add(course);
    _courses$.add(updatedCourses.toSet().toList());
  }

  void _updateCourseInList(Course updatedCourse) {
    final List<Course> updatedCourses = [..._courses$.value];
    final updatedCourseIndex = updatedCourses.indexWhere(
      (Course course) => course.id == updatedCourse.id,
    );
    updatedCourses[updatedCourseIndex] = updatedCourse;
    _courses$.add(updatedCourses);
  }

  void _removeCourseFromList(String courseId) {
    final List<Course> updatedCourses = [..._courses$.value];
    updatedCourses.removeWhere((Course course) => course.id == courseId);
    _courses$.add(updatedCourses);
  }

  Future<Course?> _loadCourseFromDb(String courseId) async {
    final courseFromDb = await _fireCoursesService.getCourseById(
      courseId: courseId,
    );
    if (courseFromDb != null) {
      final Course course = _convertCourseFromDbToCourseModel(courseFromDb);
      if (!_isCourseLoaded(course.id)) {
        _addCourseToList(course);
      }
      return course;
    }
    return null;
  }

  bool _isCourseLoaded(String courseId) {
    final List<Course> loadedCourses = _courses$.value;
    return loadedCourses.map((Course course) => course.id).contains(courseId);
  }

  Course _convertCourseFromDbToCourseModel(FireDocument<CourseDbModel> doc) {
    return Course(id: doc.id, name: doc.data.name);
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fiszkomaniak/firebase/fire_extensions.dart';
import 'package:fiszkomaniak/firebase/services/fire_courses_service.dart';
import 'package:fiszkomaniak/interfaces/courses_interface.dart';
import 'package:fiszkomaniak/models/course_model.dart';
import 'package:fiszkomaniak/models/changed_document.dart';
import '../firebase/models/course_db_model.dart';

class CoursesRepository implements CoursesInterface {
  late final FireCoursesService _fireCoursesService;

  CoursesRepository({required FireCoursesService fireCoursesService}) {
    _fireCoursesService = fireCoursesService;
  }

  @override
  Stream<List<ChangedDocument<Course>>> getCoursesSnapshots() {
    return _fireCoursesService
        .getCoursesSnapshots()
        .map((snapshot) => snapshot.docChanges)
        .map(
          (docChanges) => docChanges
              .map((element) => _convertFireDocumentToChangedDocumentModel(
                    element,
                  ))
              .whereType<ChangedDocument<Course>>()
              .toList(),
        );
  }

  @override
  Future<void> addNewCourse(String name) async {
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
  Future<void> removeCourse(String courseId) async {
    await _fireCoursesService.removeCourse(courseId);
  }

  ChangedDocument<Course>? _convertFireDocumentToChangedDocumentModel(
    DocumentChange<CourseDbModel> docChange,
  ) {
    final docData = docChange.doc.data();
    if (docData != null) {
      return ChangedDocument(
        changeType: docChange.type.toDbDocChangeType(),
        doc: Course(
          id: docChange.doc.id,
          name: docData.name,
        ),
      );
    }
    return null;
  }
}

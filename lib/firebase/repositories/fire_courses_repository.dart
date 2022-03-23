import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fiszkomaniak/firebase/services/fire_courses_service.dart';
import 'package:fiszkomaniak/interfaces/courses_interface.dart';
import 'package:fiszkomaniak/models/course_model.dart';
import 'package:fiszkomaniak/models/changed_document.dart';
import '../models/course_db_model.dart';

class FireCoursesRepository implements CoursesInterface {
  late final FireCoursesService _fireCoursesService;

  FireCoursesRepository({required FireCoursesService fireCoursesService}) {
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
  Future<void> changeCourseName(String newName) {
    // TODO: implement changeCourseName
    throw UnimplementedError();
  }

  @override
  Future<void> removeCourse(String id) {
    // TODO: implement removeCourse
    throw UnimplementedError();
  }

  ChangedDocument<Course>? _convertFireDocumentToChangedDocumentModel(
    DocumentChange<CourseDbModel> docChange,
  ) {
    final docData = docChange.doc.data();
    if (docData != null) {
      return ChangedDocument(
        changeType: _convertChangeType(docChange.type),
        doc: Course(
          id: docChange.doc.id,
          name: docData.name,
        ),
      );
    }
    return null;
  }

  TypeOfDocumentChange _convertChangeType(DocumentChangeType fireChangeType) {
    switch (fireChangeType) {
      case DocumentChangeType.added:
        return TypeOfDocumentChange.added;
      case DocumentChangeType.modified:
        return TypeOfDocumentChange.modified;
      case DocumentChangeType.removed:
        return TypeOfDocumentChange.removed;
    }
  }
}

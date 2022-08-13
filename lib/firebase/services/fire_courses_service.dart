import 'package:cloud_firestore/cloud_firestore.dart';
import '../fire_document.dart';
import '../fire_instances.dart';
import '../fire_references.dart';
import '../fire_utils.dart';
import '../models/course_db_model.dart';
import 'fire_groups_service.dart';
import 'fire_sessions_service.dart';

class FireCoursesService {
  Future<List<FireDocument<CourseDbModel>>> loadAllCourses() async {
    final docs = await FireReferences.coursesRefWithConverter.get();
    final coursesSnapshots =
        docs.docChanges.map((docChange) => docChange.doc).toList();
    return coursesSnapshots
        .map(_convertDocumentSnapshotToFireDocument)
        .whereType<FireDocument<CourseDbModel>>()
        .toList();
  }

  Future<FireDocument<CourseDbModel>?> getCourseById({
    required String courseId,
  }) async {
    final doc =
        await FireReferences.coursesRefWithConverter.doc(courseId).get();
    return _convertDocumentSnapshotToFireDocument(doc);
  }

  Future<bool> isThereCourseWithTheName({
    required String courseName,
  }) async {
    final query = await FireReferences.coursesRefWithConverter
        .where('name', isEqualTo: courseName)
        .get();
    return query.docs.isNotEmpty;
  }

  Future<FireDocument<CourseDbModel>?> addNewCourse(String name) async {
    final docRef = await FireReferences.coursesRefWithConverter.add(
      CourseDbModel(name: name),
    );
    final doc = await docRef.get();
    return _convertDocumentSnapshotToFireDocument(doc);
  }

  Future<FireDocument<CourseDbModel>?> updateCourseName({
    required String courseId,
    required String newName,
  }) async {
    final docRef = FireReferences.coursesRefWithConverter.doc(courseId);
    await docRef.update(CourseDbModel(name: newName).toJson());
    final doc = await docRef.get();
    return _convertDocumentSnapshotToFireDocument(doc);
  }

  Future<String> removeCourse(String courseId) async {
    final batch = FireInstances.firestore.batch();
    final course =
        await FireReferences.coursesRefWithConverter.doc(courseId).get();
    final groupsFromCourse = await FireGroupsService.getGroupsFromCourse(
      courseId,
    );
    final groupsIds = groupsFromCourse.docs.map((doc) => doc.id).toList();
    if (groupsIds.isNotEmpty) {
      final sessionsFromGroups =
          await FireSessionsService.getSessionsByGroupsIds(groupsIds);
      for (final session in sessionsFromGroups.docs) {
        batch.delete(session.reference);
      }
    }
    for (final group in groupsFromCourse.docs) {
      batch.delete(group.reference);
    }
    batch.delete(course.reference);
    await batch.commit();
    return courseId;
  }

  FireDocument<CourseDbModel>? _convertDocumentSnapshotToFireDocument(
    DocumentSnapshot<CourseDbModel> doc,
  ) {
    return FireUtils.convertDocumentSnapshotToFireDocument<CourseDbModel>(doc);
  }
}

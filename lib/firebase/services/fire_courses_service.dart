import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fiszkomaniak/firebase/fire_instances.dart';
import 'package:fiszkomaniak/firebase/fire_references.dart';
import 'package:fiszkomaniak/firebase/models/course_db_model.dart';
import 'package:fiszkomaniak/firebase/services/fire_groups_service.dart';
import 'package:fiszkomaniak/firebase/services/fire_sessions_service.dart';

class FireCoursesService {
  Future<List<DocumentSnapshot<CourseDbModel>>> loadAllCourses() async {
    final docs = await FireReferences.coursesRefWithConverter.get();
    return docs.docChanges.map((docChange) => docChange.doc).toList();
  }

  Future<DocumentSnapshot<CourseDbModel>> getCourseById({
    required String courseId,
  }) async {
    return await FireReferences.coursesRefWithConverter.doc(courseId).get();
  }

  Future<bool> isThereCourseWithTheName({
    required String courseName,
  }) async {
    final query = await FireReferences.coursesRefWithConverter
        .where('name', isEqualTo: courseName)
        .get();
    return query.docs.isNotEmpty;
  }

  Future<void> addNewCourse(String name) async {
    try {
      await FireReferences.coursesRefWithConverter.add(
        CourseDbModel(name: name),
      );
    } catch (error) {
      rethrow;
    }
  }

  Future<void> updateCourseName({
    required String courseId,
    required String newName,
  }) async {
    try {
      await FireReferences.coursesRefWithConverter
          .doc(courseId)
          .update(CourseDbModel(name: newName).toJson());
    } catch (error) {
      rethrow;
    }
  }

  Future<void> removeCourse(String courseId) async {
    try {
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
    } catch (error) {
      rethrow;
    }
  }
}

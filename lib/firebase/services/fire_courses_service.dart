import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fiszkomaniak/firebase/fire_user.dart';
import 'package:fiszkomaniak/firebase/models/course_db_model.dart';
import '../fire_instances.dart';

class FireCoursesService {
  Stream<QuerySnapshot<CourseDbModel>> getCoursesSnapshots() {
    String? loggedUserId = FireUser.getLoggedUserId();
    if (loggedUserId != null) {
      return _getCoursesRef(loggedUserId).snapshots();
    } else {
      throw FireUser.noLoggedUserMessage;
    }
  }

  Future<void> addNewCourse(String name) async {
    try {
      String? loggedUserId = FireUser.getLoggedUserId();
      if (loggedUserId != null) {
        await _getCoursesRef(loggedUserId).add(CourseDbModel(name: name));
      } else {
        throw FireUser.noLoggedUserMessage;
      }
    } catch (error) {
      rethrow;
    }
  }

  CollectionReference<CourseDbModel> _getCoursesRef(
    String userId,
  ) {
    return FireInstances.firestore
        .collection('Users')
        .doc(userId)
        .collection('Courses')
        .withConverter<CourseDbModel>(
          fromFirestore: (snapshot, _) => CourseDbModel.fromJson(
            snapshot.data()!,
          ),
          toFirestore: (data, _) => data.toJson(),
        );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fiszkomaniak/firebase/fire_utils.dart';
import 'package:fiszkomaniak/firebase/models/group_db_model.dart';
import 'package:fiszkomaniak/firebase/services/fire_groups_service.dart';
import 'package:fiszkomaniak/interfaces/groups_interface.dart';
import 'package:fiszkomaniak/models/changed_document.dart';
import 'package:fiszkomaniak/models/group_model.dart';

class GroupsRepository implements GroupsInterface {
  late final FireGroupsService _fireGroupsService;

  GroupsRepository({required FireGroupsService fireGroupsService}) {
    _fireGroupsService = fireGroupsService;
  }

  @override
  Stream<List<ChangedDocument<Group>>> getGroupsSnapshots() {
    return _fireGroupsService
        .getGroupsSnapshots()
        .map((snapshot) => snapshot.docChanges)
        .map(
          (docChanges) => docChanges
              .map((element) => _convertFireDocumentToChangedDocumentModel(
                    element,
                  ))
              .whereType<ChangedDocument<Group>>()
              .toList(),
        );
  }

  @override
  Future<void> addNewGroup({
    required String name,
    required String courseId,
    required String nameForQuestions,
    required String nameForAnswers,
  }) async {
    await _fireGroupsService.addNewGroup(GroupDbModel(
      name: name,
      courseId: courseId,
      nameForQuestions: nameForQuestions,
      nameForAnswers: nameForAnswers,
    ));
  }

  @override
  Future<void> updateGroup({
    required String groupId,
    String? name,
    String? courseId,
    String? nameForQuestion,
    String? nameForAnswers,
  }) async {
    await _fireGroupsService.updateGroup(
      groupId: groupId,
      name: name,
      courseId: courseId,
      nameForQuestions: nameForQuestion,
      nameForAnswers: nameForAnswers,
    );
  }

  @override
  Future<void> removeGroup(String groupId) async {
    await _fireGroupsService.removeGroup(groupId);
  }

  @override
  Future<void> removeGroupsFromCourse(String courseId) async {
    await _fireGroupsService.removeGroupsFromCourse(courseId);
  }

  ChangedDocument<Group>? _convertFireDocumentToChangedDocumentModel(
    DocumentChange<GroupDbModel> docChange,
  ) {
    final docData = docChange.doc.data();
    final String? name = docData?.name;
    final String? courseId = docData?.courseId;
    final String? nameForQuestions = docData?.nameForQuestions;
    final String? nameForAnswers = docData?.nameForAnswers;
    if (name != null &&
        courseId != null &&
        nameForQuestions != null &&
        nameForAnswers != null) {
      return ChangedDocument(
        changeType: FireUtils.convertChangeType(docChange.type),
        doc: Group(
          id: docChange.doc.id,
          name: name,
          courseId: courseId,
          nameForQuestions: nameForQuestions,
          nameForAnswers: nameForAnswers,
        ),
      );
    }
    return null;
  }
}

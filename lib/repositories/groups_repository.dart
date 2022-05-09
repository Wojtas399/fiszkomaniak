import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fiszkomaniak/firebase/fire_converters.dart';
import 'package:fiszkomaniak/firebase/models/flashcard_db_model.dart';
import 'package:fiszkomaniak/firebase/models/group_db_model.dart';
import 'package:fiszkomaniak/firebase/services/fire_groups_service.dart';
import 'package:fiszkomaniak/interfaces/groups_interface.dart';
import 'package:fiszkomaniak/models/changed_document.dart';
import 'package:fiszkomaniak/models/group_model.dart';
import '../models/flashcard_model.dart';

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

  ChangedDocument<Group>? _convertFireDocumentToChangedDocumentModel(
    DocumentChange<GroupDbModel> docChange,
  ) {
    final docData = docChange.doc.data();
    final String? name = docData?.name;
    final String? courseId = docData?.courseId;
    final String? nameForQuestions = docData?.nameForQuestions;
    final String? nameForAnswers = docData?.nameForAnswers;
    final List<FlashcardDbModel>? flashcards = docData?.flashcards;
    if (name != null &&
        courseId != null &&
        nameForQuestions != null &&
        nameForAnswers != null &&
        flashcards != null) {
      return ChangedDocument(
        changeType: FireConverters.convertChangeType(docChange.type),
        doc: Group(
          id: docChange.doc.id,
          name: name,
          courseId: courseId,
          nameForQuestions: nameForQuestions,
          nameForAnswers: nameForAnswers,
          flashcards: flashcards
              .asMap()
              .entries
              .map(
                (flashcard) => _convertFireFlashcardDocumentToFlashcardModel(
                  flashcard.key,
                  flashcard.value,
                ),
              )
              .toList(),
        ),
      );
    }
    return null;
  }

  Flashcard _convertFireFlashcardDocumentToFlashcardModel(
    int index,
    FlashcardDbModel flashcardDbModel,
  ) {
    final String question = flashcardDbModel.question;
    final String answer = flashcardDbModel.answer;
    final FlashcardStatus status = _convertStringToFlashcardStatus(
      flashcardDbModel.status,
    );
    return Flashcard(
      index: index,
      question: question,
      answer: answer,
      status: status,
    );
  }

  FlashcardStatus _convertStringToFlashcardStatus(String value) {
    switch (value) {
      case 'remembered':
        return FlashcardStatus.remembered;
      case 'notRemembered':
        return FlashcardStatus.notRemembered;
      default:
        return FlashcardStatus.remembered;
    }
  }
}

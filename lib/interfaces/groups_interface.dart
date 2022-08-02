import '../domain/entities/group.dart';
import '../domain/entities/flashcard.dart';

abstract class GroupsInterface {
  Stream<List<Group>> get allGroups$;

  Stream<Group> getGroupById({required String groupId});

  Stream<List<Group>> getGroupsByCourseId({required String courseId});

  Stream<String> getGroupName({required String groupId});

  Future<void> loadAllGroups();

  Future<void> addNewGroup({
    required String name,
    required String courseId,
    required String nameForQuestions,
    required String nameForAnswers,
  });

  Future<void> updateGroup({
    required String groupId,
    String? name,
    String? courseId,
    String? nameForQuestion,
    String? nameForAnswers,
  });

  Future<void> removeGroup(String groupId);

  Future<bool> isGroupNameInCourseAlreadyTaken({
    required String groupName,
    required String courseId,
  });

  Future<void> saveEditedFlashcards({
    required String groupId,
    required List<Flashcard> flashcards,
  });

  Future<void> setGivenFlashcardsAsRememberedAndRemainingAsNotRemembered({
    required String groupId,
    required List<int> flashcardsIndexes,
  });

  Future<void> updateFlashcard({
    required String groupId,
    required Flashcard flashcard,
  });

  Future<void> removeFlashcard({
    required String groupId,
    required int flashcardIndex,
  });
}

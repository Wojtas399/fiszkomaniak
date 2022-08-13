import 'package:rxdart/rxdart.dart';
import '../../firebase/fire_document.dart';
import '../../firebase/fire_extensions.dart';
import '../../firebase/models/flashcard_db_model.dart';
import '../../firebase/models/group_db_model.dart';
import '../../firebase/services/fire_flashcards_service.dart';
import '../../firebase/services/fire_groups_service.dart';
import '../../interfaces/groups_interface.dart';
import '../entities/flashcard.dart';
import '../entities/group.dart';

class GroupsRepository implements GroupsInterface {
  late final FireGroupsService _fireGroupsService;
  late final FireFlashcardsService _fireFlashcardsService;
  final _allGroups$ = BehaviorSubject<List<Group>>.seeded([]);

  GroupsRepository({
    required FireGroupsService fireGroupsService,
    required FireFlashcardsService fireFlashcardsService,
  }) {
    _fireGroupsService = fireGroupsService;
    _fireFlashcardsService = fireFlashcardsService;
  }

  @override
  Stream<List<Group>> get allGroups$ => _allGroups$.stream;

  @override
  Stream<Group> getGroupById({required String groupId}) {
    if (_isGroupLoaded(groupId)) {
      return allGroups$.map(
        (List<Group> groups) {
          final List<Group?> groupsForSearching = [...groups];
          return groupsForSearching.firstWhere(
            (Group? group) => group?.id == groupId,
            orElse: () => null,
          );
        },
      ).whereType<Group>();
    }
    return Rx.fromCallable(() async => await _loadGroupFromDb(groupId))
        .whereType<Group>()
        .doOnData((Group group) => _addGroupToList(group));
  }

  @override
  Stream<List<Group>> getGroupsByCourseId({required String courseId}) {
    return allGroups$.map(
      (List<Group> groups) => groups
          .where(
            (Group group) => group.courseId == courseId,
          )
          .toList(),
    );
  }

  @override
  Stream<String> getGroupName({required String groupId}) {
    return getGroupById(groupId: groupId).map((Group group) => group.name);
  }

  @override
  Future<void> loadAllGroups() async {
    final groups = await _fireGroupsService.loadAllGroups();
    _allGroups$.add(
      groups.map(_convertGroupDbModelToGroup).whereType<Group>().toList(),
    );
  }

  @override
  Future<void> addNewGroup({
    required String name,
    required String courseId,
    required String nameForQuestions,
    required String nameForAnswers,
  }) async {
    final groupFromDb = await _fireGroupsService.addNewGroup(GroupDbModel(
      name: name,
      courseId: courseId,
      nameForQuestions: nameForQuestions,
      nameForAnswers: nameForAnswers,
      flashcards: const [],
    ));
    final Group? group = _convertGroupDbModelToGroup(groupFromDb);
    if (group != null) {
      _addGroupToList(group);
    }
  }

  @override
  Future<void> updateGroup({
    required String groupId,
    String? name,
    String? courseId,
    String? nameForQuestion,
    String? nameForAnswers,
  }) async {
    final updatedGroupFromDb = await _fireGroupsService.updateGroup(
      groupId: groupId,
      name: name,
      courseId: courseId,
      nameForQuestions: nameForQuestion,
      nameForAnswers: nameForAnswers,
    );
    final Group? updatedGroup = _convertGroupDbModelToGroup(updatedGroupFromDb);
    if (updatedGroup != null) {
      _updateGroupInList(updatedGroup);
    }
  }

  @override
  Future<void> deleteGroup(String groupId) async {
    final removedGroupId = await _fireGroupsService.removeGroup(groupId);
    _removeGroupFromList(removedGroupId);
  }

  @override
  Future<bool> isGroupNameInCourseAlreadyTaken({
    required String groupName,
    required String courseId,
  }) async {
    final List<Group?> allGroups = [..._allGroups$.value];
    final Group? group = allGroups.firstWhere(
      (group) => group?.courseId == courseId && group?.name == groupName,
      orElse: () => null,
    );
    if (group != null) {
      return true;
    }
    return await _fireGroupsService.isGroupNameInCourseAlreadyTaken(
      groupName: groupName,
      courseId: courseId,
    );
  }

  @override
  Future<void> saveEditedFlashcards({
    required String groupId,
    required List<Flashcard> flashcards,
  }) async {
    final updatedGroupFromDb = await _fireFlashcardsService.setFlashcards(
      groupId,
      flashcards.map(_convertFlashcardToDbModel).toList(),
    );
    final Group? updatedGroup = _convertGroupDbModelToGroup(updatedGroupFromDb);
    if (updatedGroup != null) {
      _updateGroupInList(updatedGroup);
    }
  }

  @override
  Future<void> setGivenFlashcardsAsRememberedAndRemainingAsNotRemembered({
    required String groupId,
    required List<int> flashcardsIndexes,
  }) async {
    final updatedGroupFromDb = await _fireFlashcardsService
        .setGivenFlashcardsAsRememberedAndRemainingAsNotRemembered(
      groupId: groupId,
      indexesOfRememberedFlashcards: flashcardsIndexes,
    );
    final Group? updatedGroup = _convertGroupDbModelToGroup(updatedGroupFromDb);
    if (updatedGroup != null) {
      _updateGroupInList(updatedGroup);
    }
  }

  @override
  Future<void> updateFlashcard({
    required String groupId,
    required Flashcard flashcard,
  }) async {
    final updatedGroupFromDb = await _fireFlashcardsService.updateFlashcard(
      groupId,
      _convertFlashcardToDbModel(flashcard),
    );
    final Group? updatedGroup = _convertGroupDbModelToGroup(updatedGroupFromDb);
    if (updatedGroup != null) {
      _updateGroupInList(updatedGroup);
    }
  }

  @override
  Future<void> deleteFlashcard({
    required String groupId,
    required int flashcardIndex,
  }) async {
    final updatedGroupFromDb = await _fireFlashcardsService.removeFlashcard(
      groupId,
      flashcardIndex,
    );
    final Group? updatedGroup = _convertGroupDbModelToGroup(updatedGroupFromDb);
    if (updatedGroup != null) {
      _updateGroupInList(updatedGroup);
    }
  }

  void _addGroupToList(Group group) {
    final List<Group> updatedGroups = [..._allGroups$.value];
    updatedGroups.add(group);
    _allGroups$.add(updatedGroups.toSet().toList());
  }

  void _updateGroupInList(Group updatedGroup) {
    final updatedGroups = [..._allGroups$.value];
    final updatedGroupIndex = updatedGroups.indexWhere(
      (Group group) => group.id == updatedGroup.id,
    );
    updatedGroups[updatedGroupIndex] = updatedGroup;
    _allGroups$.add(updatedGroups);
  }

  void _removeGroupFromList(String groupId) {
    final List<Group> updatedGroups = [..._allGroups$.value];
    updatedGroups.removeWhere((Group group) => group.id == groupId);
    _allGroups$.add(updatedGroups);
  }

  bool _isGroupLoaded(String groupId) {
    return _allGroups$.value.map((group) => group.id).contains(groupId);
  }

  Future<Group?> _loadGroupFromDb(String groupId) async {
    final dbGroup = await _fireGroupsService.loadGroupById(
      groupId: groupId,
    );
    return _convertGroupDbModelToGroup(dbGroup);
  }

  Group? _convertGroupDbModelToGroup(FireDocument<GroupDbModel>? group) {
    final String? groupId = group?.id;
    final groupData = group?.data;
    final String? name = groupData?.name;
    final String? courseId = groupData?.courseId;
    final String? nameForQuestions = groupData?.nameForQuestions;
    final String? nameForAnswers = groupData?.nameForAnswers;
    final List<FlashcardDbModel>? flashcards = groupData?.flashcards;
    if (groupId != null &&
        groupData != null &&
        name != null &&
        courseId != null &&
        nameForQuestions != null &&
        nameForAnswers != null &&
        flashcards != null) {
      return Group(
        id: groupId,
        name: name,
        courseId: courseId,
        nameForQuestions: nameForQuestions,
        nameForAnswers: nameForAnswers,
        flashcards: flashcards
            .map(_convertFlashcardDbModelToFlashcard)
            .whereType<Flashcard>()
            .toList(),
      );
    }
    return null;
  }

  FlashcardDbModel _convertFlashcardToDbModel(Flashcard flashcard) {
    return FlashcardDbModel(
      index: flashcard.index,
      question: flashcard.question,
      answer: flashcard.answer,
      status: flashcard.status.toDbString(),
    );
  }

  Flashcard? _convertFlashcardDbModelToFlashcard(FlashcardDbModel flashcard) {
    final FlashcardStatus? flashcardStatus =
        flashcard.status.toFlashcardStatus();
    if (flashcardStatus != null) {
      return Flashcard(
        index: flashcard.index,
        question: flashcard.question,
        answer: flashcard.answer,
        status: flashcardStatus,
      );
    }
    return null;
  }
}

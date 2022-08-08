import 'package:fiszkomaniak/firebase/fire_document.dart';
import 'package:fiszkomaniak/firebase/fire_extensions.dart';
import 'package:fiszkomaniak/firebase/models/flashcard_db_model.dart';
import 'package:fiszkomaniak/firebase/models/group_db_model.dart';
import 'package:fiszkomaniak/firebase/services/fire_flashcards_service.dart';
import 'package:fiszkomaniak/firebase/services/fire_groups_service.dart';
import 'package:fiszkomaniak/interfaces/groups_interface.dart';
import 'package:fiszkomaniak/domain/entities/group.dart';
import 'package:fiszkomaniak/domain/entities/flashcard.dart';
import 'package:rxdart/rxdart.dart';

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
        .doOnData((group) => _addGroupsToStream([group]));
  }

  @override
  Stream<List<Group>> getGroupsByCourseId({required String courseId}) {
    return allGroups$.map(
      (groups) => groups.where((group) => group.courseId == courseId).toList(),
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
    ));
    final Group? group = _convertGroupDbModelToGroup(groupFromDb);
    if (group != null) {
      _addGroupsToStream([group]);
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
    _updateGroupInStream(updatedGroupFromDb);
  }

  @override
  Future<void> removeGroup(String groupId) async {
    final removedGroupId = await _fireGroupsService.removeGroup(groupId);
    final groups = [..._allGroups$.value];
    groups.removeWhere((group) => group.id == removedGroupId);
    _allGroups$.add(groups);
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
    _updateGroupInStream(updatedGroupFromDb);
  }

  @override
  Future<void> setGivenFlashcardsAsRememberedAndRemainingAsNotRemembered({
    required String groupId,
    required List<int> flashcardsIndexes,
  }) async {
    final groupFromDb = await _fireFlashcardsService
        .setGivenFlashcardsAsRememberedAndRemainingAsNotRemembered(
      groupId: groupId,
      indexesOfRememberedFlashcards: flashcardsIndexes,
    );
    _updateGroupInStream(groupFromDb);
  }

  @override
  Future<void> updateFlashcard({
    required String groupId,
    required Flashcard flashcard,
  }) async {
    final groupFromDb = await _fireFlashcardsService.updateFlashcard(
      groupId,
      _convertFlashcardToDbModel(flashcard),
    );
    _updateGroupInStream(groupFromDb);
  }

  @override
  Future<void> removeFlashcard({
    required String groupId,
    required int flashcardIndex,
  }) async {
    final groupFromDb = await _fireFlashcardsService.removeFlashcard(
      groupId,
      flashcardIndex,
    );
    _updateGroupInStream(groupFromDb);
  }

  bool _isGroupLoaded(String groupId) {
    return _allGroups$.value.map((group) => group.id).contains(groupId);
  }

  Future<Group?> _loadGroupFromDb(String groupId) async {
    final groupFromDb = await _fireGroupsService.loadGroupById(
      groupId: groupId,
    );
    return _convertGroupDbModelToGroup(groupFromDb);
  }

  void _addGroupsToStream(List<Group> groups) {
    final List<Group> updatedGroups = [..._allGroups$.value];
    updatedGroups.addAll(groups);
    _allGroups$.add(updatedGroups.toSet().toList());
  }

  Group? _convertGroupDbModelToGroup(FireDocument<GroupDbModel>? group) {
    final String? groupId = group?.id;
    final groupData = group?.data;
    final String? name = groupData?.name;
    final String? courseId = groupData?.courseId;
    final String? nameForQuestions = groupData?.nameForQuestions;
    final String? nameForAnswers = groupData?.nameForAnswers;
    if (groupId != null &&
        groupData != null &&
        name != null &&
        courseId != null &&
        nameForQuestions != null &&
        nameForAnswers != null) {
      return Group(
        id: groupId,
        name: name,
        courseId: courseId,
        nameForQuestions: nameForQuestions,
        nameForAnswers: nameForAnswers,
        flashcards: groupData.flashcards
            .map(_convertFlashcardDbModelToFlashcard)
            .whereType<Flashcard>()
            .toList(),
      );
    }
    return null;
  }

  void _updateGroupInStream(FireDocument<GroupDbModel>? groupFromDb) {
    final Group? updatedGroup = _convertGroupDbModelToGroup(groupFromDb);
    if (updatedGroup != null) {
      final groups = [..._allGroups$.value];
      final updatedGroupIndex = groups.indexWhere(
        (group) => group.id == updatedGroup.id,
      );
      groups[updatedGroupIndex] = updatedGroup;
      _allGroups$.add(groups);
    }
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

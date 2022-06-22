import 'package:fiszkomaniak/firebase/fire_document.dart';
import 'package:fiszkomaniak/firebase/fire_extensions.dart';
import 'package:fiszkomaniak/firebase/models/flashcard_db_model.dart';
import 'package:fiszkomaniak/firebase/models/group_db_model.dart';
import 'package:fiszkomaniak/firebase/services/fire_groups_service.dart';
import 'package:fiszkomaniak/interfaces/groups_interface.dart';
import 'package:fiszkomaniak/domain/entities/group.dart';
import 'package:rxdart/rxdart.dart';
import '../../models/flashcard_model.dart';

class GroupsRepository implements GroupsInterface {
  late final FireGroupsService _fireGroupsService;
  final _allGroups$ = BehaviorSubject<List<Group>>.seeded([]);

  GroupsRepository({required FireGroupsService fireGroupsService}) {
    _fireGroupsService = fireGroupsService;
  }

  @override
  Stream<List<Group>> get allGroups$ => _allGroups$.stream;

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
  Stream<Group> getGroupById({required String groupId}) {
    if (_isGroupLoaded(groupId)) {
      return allGroups$.map(
        (groups) => groups.firstWhere((group) => group.id == groupId),
      );
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
}

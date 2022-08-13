import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:fiszkomaniak/domain/entities/flashcard.dart';
import 'package:fiszkomaniak/domain/entities/group.dart';
import 'package:fiszkomaniak/domain/repositories/groups_repository.dart';
import 'package:fiszkomaniak/firebase/fire_document.dart';
import 'package:fiszkomaniak/firebase/models/flashcard_db_model.dart';
import 'package:fiszkomaniak/firebase/models/group_db_model.dart';
import 'package:fiszkomaniak/firebase/services/fire_flashcards_service.dart';
import 'package:fiszkomaniak/firebase/services/fire_groups_service.dart';

class MockFireGroupsService extends Mock implements FireGroupsService {}

class MockFireFlashcardsService extends Mock implements FireFlashcardsService {}

void main() {
  final fireGroupsService = MockFireGroupsService();
  final fireFlashcardsService = MockFireFlashcardsService();
  late GroupsRepository repository;

  setUp(() {
    repository = GroupsRepository(
      fireGroupsService: fireGroupsService,
      fireFlashcardsService: fireFlashcardsService,
    );
  });

  tearDown(() {
    reset(fireGroupsService);
    reset(fireFlashcardsService);
  });

  test(
    'initial groups stream should contains empty array',
    () async {
      final Stream<List<Group>> allGroups$ = repository.allGroups$;

      expect(await allGroups$.first, []);
    },
  );

  test(
    'get group by id, should only return group if it has been already loaded',
    () async {
      final FireDocument<GroupDbModel> groupFromDb = FireDocument(
        id: 'g1',
        data: createGroupDbModel(name: 'group 1', courseId: 'c1'),
      );
      when(
        () => fireGroupsService.loadAllGroups(),
      ).thenAnswer((_) async => [groupFromDb]);

      await repository.loadAllGroups();
      final Stream<Group> group$ = repository.getGroupById(groupId: 'g1');

      expect(
        await group$.first,
        createGroup(
          id: 'g1',
          name: 'group 1',
          courseId: 'c1',
        ),
      );
    },
  );

  test(
    'get group by id, should load group from db if it has not been loaded yet',
    () async {
      final FireDocument<GroupDbModel> groupFromDb = FireDocument(
        id: 'g1',
        data: createGroupDbModel(name: 'group 1', courseId: 'c1'),
      );
      when(
        () => fireGroupsService.loadGroupById(groupId: 'g1'),
      ).thenAnswer((_) async => groupFromDb);

      final Stream<Group> group$ = repository.getGroupById(groupId: 'g1');

      expect(
        await group$.first,
        createGroup(id: 'g1', name: 'group 1', courseId: 'c1'),
      );
      verify(
        () => fireGroupsService.loadGroupById(groupId: 'g1'),
      ).called(1);
    },
  );

  test(
    'get group by id, returned stream should be empty if group does not exist',
    () async {
      when(
        () => fireGroupsService.loadGroupById(groupId: 'g1'),
      ).thenAnswer((_) async => null);

      final Stream<Group> group$ = repository.getGroupById(groupId: 'g1');

      expect(await group$.isEmpty, true);
      verify(
        () => fireGroupsService.loadGroupById(groupId: 'g1'),
      ).called(1);
    },
  );

  test(
    'get groups by course id, should return all groups from specific course',
    () async {
      final List<FireDocument<GroupDbModel>> groupsFromDb = [
        FireDocument(id: 'g1', data: createGroupDbModel(courseId: 'c1')),
        FireDocument(id: 'g2', data: createGroupDbModel(courseId: 'c2')),
        FireDocument(id: 'g3', data: createGroupDbModel(courseId: 'c3')),
        FireDocument(id: 'g4', data: createGroupDbModel(courseId: 'c1')),
        FireDocument(id: 'g5', data: createGroupDbModel(courseId: 'c2')),
      ];
      when(
        () => fireGroupsService.loadAllGroups(),
      ).thenAnswer((_) async => groupsFromDb);

      await repository.loadAllGroups();
      final Stream<List<Group>> groupsFromCourse$ =
          repository.getGroupsByCourseId(courseId: 'c1');

      expect(
        await groupsFromCourse$.first,
        [
          createGroup(id: 'g1', courseId: 'c1'),
          createGroup(id: 'g4', courseId: 'c1'),
        ],
      );
    },
  );

  test(
    'get group name, should return stream which contains name of specific group',
    () async {
      final FireDocument<GroupDbModel> groupFromDb = FireDocument(
        id: 'g1',
        data: createGroupDbModel(name: 'group 1', courseId: 'c1'),
      );
      when(
        () => fireGroupsService.loadAllGroups(),
      ).thenAnswer((_) async => [groupFromDb]);

      await repository.loadAllGroups();
      final Stream<String> groupName$ = repository.getGroupName(groupId: 'g1');

      expect(
        await groupName$.first,
        groupFromDb.data.name,
      );
    },
  );

  test(
    'load all groups, should load all groups from db and assign them to stream',
    () async {
      final List<FireDocument<GroupDbModel>> groupsFromDb = [
        FireDocument(id: 'g1', data: createGroupDbModel(name: 'group 1')),
        FireDocument(id: 'g2', data: createGroupDbModel(name: 'group 2')),
        FireDocument(id: 'g3', data: createGroupDbModel(name: 'group 3')),
      ];
      when(
        () => fireGroupsService.loadAllGroups(),
      ).thenAnswer((_) async => groupsFromDb);

      await repository.loadAllGroups();

      expect(
        await repository.allGroups$.first,
        [
          createGroup(id: 'g1', name: 'group 1'),
          createGroup(id: 'g2', name: 'group 2'),
          createGroup(id: 'g3', name: 'group 3'),
        ],
      );
      verify(
        () => fireGroupsService.loadAllGroups(),
      ).called(1);
    },
  );

  test(
    'add new group, should add new group to db and to all groups stream',
    () async {
      final FireDocument<GroupDbModel> groupFromDb = FireDocument(
        id: 'g1',
        data: createGroupDbModel(name: 'group 1', courseId: 'c1'),
      );
      when(
        () => fireGroupsService.addNewGroup(
          const GroupDbModel(
            name: 'group 1',
            courseId: 'c1',
            nameForQuestions: 'questions',
            nameForAnswers: 'answers',
            flashcards: [],
          ),
        ),
      ).thenAnswer((_) async => groupFromDb);

      await repository.addNewGroup(
        name: 'group 1',
        courseId: 'c1',
        nameForQuestions: 'questions',
        nameForAnswers: 'answers',
      );

      verify(
        () => fireGroupsService.addNewGroup(
          const GroupDbModel(
            name: 'group 1',
            courseId: 'c1',
            nameForQuestions: 'questions',
            nameForAnswers: 'answers',
            flashcards: [],
          ),
        ),
      ).called(1);
      expect(
        await repository.allGroups$.first,
        [createGroup(id: 'g1', name: 'group 1', courseId: 'c1')],
      );
    },
  );

  test(
    'update group, should update group in db and group in all groups stream',
    () async {
      final FireDocument<GroupDbModel> groupFromDb = FireDocument(
        id: 'g1',
        data: createGroupDbModel(name: 'group 1'),
      );
      final FireDocument<GroupDbModel> updatedGroupFromDb = FireDocument(
        id: 'g1',
        data: createGroupDbModel(name: 'new group name'),
      );
      when(
        () => fireGroupsService.loadAllGroups(),
      ).thenAnswer((_) async => [groupFromDb]);
      when(
        () => fireGroupsService.updateGroup(
          groupId: 'g1',
          name: 'new group name',
        ),
      ).thenAnswer((_) async => updatedGroupFromDb);

      await repository.loadAllGroups();
      await repository.updateGroup(groupId: 'g1', name: 'new group name');

      verify(
        () => fireGroupsService.updateGroup(
          groupId: 'g1',
          name: 'new group name',
        ),
      ).called(1);
      expect(
        await repository.allGroups$.first,
        [createGroup(id: 'g1', name: 'new group name')],
      );
    },
  );

  test(
    'delete group, should call methods responsible for deleting group from db and from all groups stream',
    () async {
      final FireDocument<GroupDbModel> groupFromDb = FireDocument(
        id: 'g1',
        data: createGroupDbModel(name: 'group 1'),
      );
      when(
        () => fireGroupsService.loadAllGroups(),
      ).thenAnswer((_) async => [groupFromDb]);
      when(
        () => fireGroupsService.removeGroup('g1'),
      ).thenAnswer((_) async => 'g1');

      await repository.loadAllGroups();
      await repository.deleteGroup('g1');

      verify(
        () => fireGroupsService.removeGroup('g1'),
      ).called(1);
      expect(await repository.allGroups$.first, []);
    },
  );

  test(
    'is group name in course already taken, should return true if group with the same name has been already loaded',
    () async {
      final FireDocument<GroupDbModel> groupFromDb = FireDocument(
        id: 'g1',
        data: createGroupDbModel(name: 'group 1', courseId: 'c1'),
      );
      when(
        () => fireGroupsService.loadAllGroups(),
      ).thenAnswer((_) async => [groupFromDb]);

      await repository.loadAllGroups();
      final bool result = await repository.isGroupNameInCourseAlreadyTaken(
        groupName: 'group 1',
        courseId: 'c1',
      );

      expect(result, true);
    },
  );

  test(
    'is group name in course already taken, should return db response if group with the same name has not been loaded yet',
    () async {
      when(
        () => fireGroupsService.isGroupNameInCourseAlreadyTaken(
          groupName: 'group 1',
          courseId: 'c1',
        ),
      ).thenAnswer((_) async => false);

      final bool result = await repository.isGroupNameInCourseAlreadyTaken(
        groupName: 'group 1',
        courseId: 'c1',
      );

      expect(result, false);
      verify(
        () => fireGroupsService.isGroupNameInCourseAlreadyTaken(
          groupName: 'group 1',
          courseId: 'c1',
        ),
      ).called(1);
    },
  );

  group(
    'flashcards operations',
    () {
      final List<FlashcardDbModel> dbFlashcards = [
        createFlashcardDbModel(
          index: 0,
          question: 'q0',
          answer: 'a0',
          status: 'notRemembered',
        ),
      ];
      final FireDocument<GroupDbModel> dbGroup = FireDocument(
        id: 'g1',
        data: createGroupDbModel(flashcards: dbFlashcards),
      );

      setUp(() {
        when(
          () => fireGroupsService.loadAllGroups(),
        ).thenAnswer((_) async => [dbGroup]);
      });

      test(
        'save edited flashcards, should call method responsible for saving flashcards and should update all groups stream',
        () async {
          final List<Flashcard> editedFlashcards = [
            createFlashcard(
              index: 0,
              question: 'question0',
              answer: 'answer0',
              status: FlashcardStatus.notRemembered,
            ),
          ];
          final List<FlashcardDbModel> dbEditedFlashcards = [
            createFlashcardDbModel(
              index: 0,
              question: 'question0',
              answer: 'answer0',
              status: 'notRemembered',
            ),
          ];
          final FireDocument<GroupDbModel> dbUpdatedGroup = FireDocument(
            id: 'g1',
            data: createGroupDbModel(flashcards: dbEditedFlashcards),
          );
          final Group updatedGroup = createGroup(
            id: 'g1',
            flashcards: editedFlashcards,
          );
          when(
            () => fireFlashcardsService.setFlashcards(
              'g1',
              dbEditedFlashcards,
            ),
          ).thenAnswer((_) async => dbUpdatedGroup);

          await repository.loadAllGroups();
          await repository.saveEditedFlashcards(
            groupId: 'g1',
            flashcards: editedFlashcards,
          );

          final List<Group> groups = await repository.allGroups$.first;
          expect(groups, [updatedGroup]);
          verify(
            () => fireFlashcardsService.setFlashcards(
              'g1',
              dbEditedFlashcards,
            ),
          ).called(1);
        },
      );

      test(
        'set given flashcards as remembered and remaining as not remembered, should call method responsible for marking flashcards as remembered and should update all groups stream',
        () async {
          final List<FlashcardDbModel> dbUpdatedFlashcards = [
            createFlashcardDbModel(
              index: 0,
              question: 'q0',
              answer: 'a0',
              status: 'remembered',
            ),
          ];
          final FireDocument<GroupDbModel> dbUpdatedGroup = FireDocument(
            id: 'g1',
            data: createGroupDbModel(flashcards: dbUpdatedFlashcards),
          );
          final Group updatedGroup = createGroup(
            id: 'g1',
            flashcards: [
              createFlashcard(
                index: 0,
                question: 'q0',
                answer: 'a0',
                status: FlashcardStatus.remembered,
              ),
            ],
          );
          when(
            () => fireFlashcardsService
                .setGivenFlashcardsAsRememberedAndRemainingAsNotRemembered(
              groupId: 'g1',
              indexesOfRememberedFlashcards: [0],
            ),
          ).thenAnswer((_) async => dbUpdatedGroup);

          await repository.loadAllGroups();
          await repository
              .setGivenFlashcardsAsRememberedAndRemainingAsNotRemembered(
            groupId: 'g1',
            flashcardsIndexes: [0],
          );

          final List<Group> groups = await repository.allGroups$.first;
          expect(groups, [updatedGroup]);
          verify(
            () => fireFlashcardsService
                .setGivenFlashcardsAsRememberedAndRemainingAsNotRemembered(
              groupId: 'g1',
              indexesOfRememberedFlashcards: [0],
            ),
          ).called(1);
        },
      );

      test(
        'update flashcard, should call method responsible for updating flashcard and should update all groups stream',
        () async {
          final Flashcard updatedFlashcard = createFlashcard(
            index: 0,
            question: 'question0',
            answer: 'answer0',
            status: FlashcardStatus.notRemembered,
          );
          final FlashcardDbModel dbUpdatedFlashcard = createFlashcardDbModel(
            index: 0,
            question: 'question0',
            answer: 'answer0',
            status: 'notRemembered',
          );
          final FireDocument<GroupDbModel> dbUpdatedGroup = FireDocument(
            id: 'g1',
            data: createGroupDbModel(flashcards: [dbUpdatedFlashcard]),
          );
          final Group updatedGroup = createGroup(
            id: 'g1',
            flashcards: [updatedFlashcard],
          );
          when(
            () => fireFlashcardsService.updateFlashcard(
              'g1',
              dbUpdatedFlashcard,
            ),
          ).thenAnswer((_) async => dbUpdatedGroup);

          await repository.loadAllGroups();
          await repository.updateFlashcard(
            groupId: 'g1',
            flashcard: updatedFlashcard,
          );

          final List<Group> groups = await repository.allGroups$.first;
          expect(groups, [updatedGroup]);
          verify(
            () => fireFlashcardsService.updateFlashcard(
              'g1',
              dbUpdatedFlashcard,
            ),
          ).called(1);
        },
      );

      test(
        'delete flashcard, should call method responsible for deleting flashcard from db and should update all groups stream',
        () async {
          final FireDocument<GroupDbModel> dbUpdatedGroup = FireDocument(
            id: 'g1',
            data: createGroupDbModel(),
          );
          final Group updatedGroup = createGroup(id: 'g1');

          when(
            () => fireFlashcardsService.removeFlashcard('g1', 0),
          ).thenAnswer((_) async => dbUpdatedGroup);

          await repository.loadAllGroups();
          await repository.deleteFlashcard(groupId: 'g1', flashcardIndex: 0);

          final List<Group> groups = await repository.allGroups$.first;
          expect(groups, [updatedGroup]);
          verify(
            () => fireFlashcardsService.removeFlashcard('g1', 0),
          ).called(1);
        },
      );
    },
  );
}

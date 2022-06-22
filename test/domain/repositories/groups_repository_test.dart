import 'package:fiszkomaniak/domain/entities/group.dart';
import 'package:fiszkomaniak/domain/repositories/groups_repository.dart';
import 'package:fiszkomaniak/firebase/fire_document.dart';
import 'package:fiszkomaniak/firebase/models/group_db_model.dart';
import 'package:fiszkomaniak/firebase/services/fire_groups_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockFireGroupsService extends Mock implements FireGroupsService {}

void main() {
  final fireGroupsService = MockFireGroupsService();
  late GroupsRepository repository;

  setUp(() {
    repository = GroupsRepository(fireGroupsService: fireGroupsService);
  });

  tearDown(() {
    reset(fireGroupsService);
  });

  test(
    'initial groups stream should contains empty array',
    () async {
      final Stream<List<Group>> allGroups$ = repository.allGroups$;

      expect(await allGroups$.first, []);
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
    },
  );

  //TODO: write tests for other methods from this repository
}

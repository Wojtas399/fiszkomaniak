import 'package:fiszkomaniak/firebase/models/group_db_model.dart';
import 'package:fiszkomaniak/firebase/repositories/groups_repository.dart';
import 'package:fiszkomaniak/firebase/services/fire_groups_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockFireGroupsService extends Mock implements FireGroupsService {}

void main() {
  final FireGroupsService fireGroupsService = MockFireGroupsService();
  late GroupsRepository repository;

  setUp(() {
    repository = GroupsRepository(fireGroupsService: fireGroupsService);
  });

  tearDown(() {
    reset(fireGroupsService);
  });

  test('add new group', () async {
    when(
      () => fireGroupsService.addNewGroup(const GroupDbModel(
        name: 'name',
        courseId: 'courseId',
        nameForQuestions: 'nameForQuestions',
        nameForAnswers: 'nameForAnswers',
      )),
    ).thenAnswer((_) async => '');

    await repository.addNewGroup(
      name: 'name',
      courseId: 'courseId',
      nameForQuestions: 'nameForQuestions',
      nameForAnswers: 'nameForAnswers',
    );

    verify(
      () => fireGroupsService.addNewGroup(const GroupDbModel(
        name: 'name',
        courseId: 'courseId',
        nameForQuestions: 'nameForQuestions',
        nameForAnswers: 'nameForAnswers',
      )),
    ).called(1);
  });

  test('update group', () async {
    when(
      () => fireGroupsService.updateGroup(groupId: 'g1', name: 'new name'),
    ).thenAnswer((_) async => '');

    await repository.updateGroup(groupId: 'g1', name: 'new name');

    verify(
      () => fireGroupsService.updateGroup(groupId: 'g1', name: 'new name'),
    ).called(1);
  });

  test('remove group', () async {
    when(() => fireGroupsService.removeGroup('g1')).thenAnswer((_) async => '');

    await repository.removeGroup('g1');

    verify(() => fireGroupsService.removeGroup('g1')).called(1);
  });

  test('remove groups from course', () async {
    when(
      () => fireGroupsService.removeGroupsFromCourse('c1'),
    ).thenAnswer((_) async => '');

    await repository.removeGroupsFromCourse('c1');

    verify(() => fireGroupsService.removeGroupsFromCourse('c1')).called(1);
  });
}

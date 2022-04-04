import 'package:bloc_test/bloc_test.dart';
import 'package:fiszkomaniak/components/dialogs/dialogs.dart';
import 'package:fiszkomaniak/core/groups/groups_bloc.dart';
import 'package:fiszkomaniak/core/groups/groups_event.dart';
import 'package:fiszkomaniak/core/groups/groups_state.dart';
import 'package:fiszkomaniak/features/group_preview/bloc/group_preview_bloc.dart';
import 'package:fiszkomaniak/features/group_preview/bloc/group_preview_event.dart';
import 'package:fiszkomaniak/features/group_preview/bloc/group_preview_state.dart';
import 'package:fiszkomaniak/models/group_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGroupsBloc extends Mock implements GroupsBloc {}

class MockDialogs extends Mock implements Dialogs {}

void main() {
  final GroupsBloc groupsBloc = MockGroupsBloc();
  final Dialogs dialogs = MockDialogs();
  late GroupPreviewBloc bloc;
  final List<Group> groups = [
    createGroup(id: 'g1'),
    createGroup(id: 'g2'),
    createGroup(id: 'g3'),
  ];
  void mockConfirmationAnswer(bool answer) {
    when(
      () => dialogs.askForConfirmation(
        title: 'Czy na pewno chcesz usunąć grupę?',
        text:
            'Usunięcie grupy spowoduje również usunięcie wszystkich fiszek należących do niej.',
        confirmButtonText: 'Usuń',
      ),
    ).thenAnswer((_) async => answer);
  }

  setUp(() {
    bloc = GroupPreviewBloc(groupsBloc: groupsBloc, dialogs: dialogs);
    final GroupsState groupsState = GroupsState(allGroups: groups);
    when(() => groupsBloc.state).thenReturn(groupsState);
    when(() => groupsBloc.stream).thenAnswer((_) => Stream.value(groupsState));
  });

  tearDown(() {
    reset(groupsBloc);
  });

  blocTest(
    'initialize',
    build: () => bloc,
    act: (_) => bloc.add(GroupPreviewEventInitialize(groupId: 'g1')),
    expect: () => [
      GroupPreviewState(group: groups[0]),
    ],
  );

  blocTest(
    'on group updated, group exists',
    build: () => bloc,
    act: (_) => bloc.add(GroupPreviewEventGroupUpdated(groupId: 'g1')),
    expect: () => [
      GroupPreviewState(group: createGroup(id: 'g1')),
    ],
    verify: (_) {
      verify(() => groupsBloc.state.getGroupById('g1')).called(1);
    },
  );

  blocTest(
    'on group updated, group does not exist',
    build: () => bloc,
    act: (_) => bloc.add(GroupPreviewEventGroupUpdated(groupId: 'g4')),
    expect: () => [],
    verify: (_) {
      verify(() => groupsBloc.state.getGroupById('g4')).called(1);
    },
  );

  blocTest(
    'remove, group exists, confirmed',
    build: () => bloc,
    setUp: () => mockConfirmationAnswer(true),
    act: (_) {
      bloc.add(GroupPreviewEventGroupUpdated(groupId: 'g1'));
      bloc.add(GroupPreviewEventRemove());
    },
    expect: () => [
      GroupPreviewState(group: groups[0]),
    ],
    verify: (_) {
      verify(
        () => groupsBloc.add(GroupsEventRemoveGroup(groupId: 'g1')),
      ).called(1);
    },
  );

  blocTest(
    'remove, group exists, cancelled',
    build: () => bloc,
    setUp: () => mockConfirmationAnswer(false),
    act: (_) {
      bloc.add(GroupPreviewEventGroupUpdated(groupId: 'g1'));
      bloc.add(GroupPreviewEventRemove());
    },
    expect: () => [
      GroupPreviewState(group: groups[0]),
    ],
    verify: (_) {
      verifyNever(() => groupsBloc.add(GroupsEventRemoveGroup(groupId: 'g1')));
    },
  );

  blocTest(
    'remove, group does not exist',
    build: () => bloc,
    setUp: () => mockConfirmationAnswer(true),
    act: (_) {
      bloc.add(GroupPreviewEventRemove());
    },
    expect: () => [],
    verify: (_) {
      verifyNever(() => groupsBloc.add(GroupsEventRemoveGroup(groupId: 'g1')));
    },
  );
}

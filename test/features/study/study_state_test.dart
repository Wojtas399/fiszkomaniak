import 'package:fiszkomaniak/components/group_item/group_item.dart';
import 'package:fiszkomaniak/features/study/bloc/study_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late StudyState state;

  setUp(() {
    state = const StudyState();
  });

  test(
    'initial state',
    () {
      expect(state.groupsItemsParams, []);
    },
  );

  test(
    'copy with groups items params',
    () {
      final List<GroupItemParams> expectedParams = [
        createGroupItemParams(id: 'g1', name: 'group 1'),
        createGroupItemParams(id: 'g2', name: 'group 2'),
      ];

      final state2 = state.copyWith(groupsItemsParams: expectedParams);
      final state3 = state2.copyWith();

      expect(state2.groupsItemsParams, expectedParams);
      expect(state3.groupsItemsParams, expectedParams);
    },
  );

  test(
    'are groups, should be false if there is no groups',
    () {
      expect(state.areGroups, false);
    },
  );

  test(
    'are groups, should be true if there is at least one group',
    () {
      state = state.copyWith(groupsItemsParams: [
        createGroupItemParams(id: 'g1'),
      ]);

      expect(state.areGroups, true);
    },
  );
}

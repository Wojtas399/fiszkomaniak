import 'package:fiszkomaniak/features/sessions_list/bloc/sessions_list_bloc.dart';
import 'package:fiszkomaniak/models/bloc_status.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late SessionsListState state;

  setUp(
    () => state = const SessionsListState(
      status: BlocStatusInitial(),
      sessionsItemsParams: [],
    ),
  );

  test(
    'copy with status',
    () {
      const BlocStatus expectedStatus = BlocStatusLoading();

      final state2 = state.copyWith(status: expectedStatus);
      final state3 = state2.copyWith();

      expect(state2.status, expectedStatus);
      expect(state3.status, const BlocStatusComplete());
    },
  );

  test(
    'copy with sessions items params',
    () {
      final List<SessionItemParams> expectedParams = [
        createSessionItemParams(sessionId: 's1'),
        createSessionItemParams(sessionId: 's2'),
      ];

      final state2 = state.copyWith(sessionsItemsParams: expectedParams);
      final state3 = state2.copyWith();

      expect(state2.sessionsItemsParams, expectedParams);
      expect(state3.sessionsItemsParams, expectedParams);
    },
  );
}

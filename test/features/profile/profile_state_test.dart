import 'package:flutter_test/flutter_test.dart';
import 'package:fiszkomaniak/domain/entities/user.dart';
import 'package:fiszkomaniak/features/profile/bloc/profile_bloc.dart';
import 'package:fiszkomaniak/models/bloc_status.dart';

void main() {
  late ProfileState state;

  setUp(
    () => state = const ProfileState(
      status: BlocStatusInitial(),
      user: null,
      daysStreak: 0,
      amountOfRememberedFlashcards: 0,
    ),
  );

  test(
    'avatar url, should return url of user avatar',
    () {
      final User user = createUser(avatarUrl: 'avatar/url');

      state = state.copyWith(user: user);

      expect(state.avatarUrl, user.avatarUrl);
    },
  );

  test(
    'copy with status',
    () {
      const BlocStatus expectedStatus = BlocStatusLoading();

      state = state.copyWith(status: expectedStatus);
      final state2 = state.copyWith();

      expect(state.status, expectedStatus);
      expect(state2.status, const BlocStatusInProgress());
    },
  );

  test(
    'copy with user',
    () {
      final User expectedUser = createUser(username: 'username');

      state = state.copyWith(user: expectedUser);
      final state2 = state.copyWith();

      expect(state.user, expectedUser);
      expect(state2.user, expectedUser);
    },
  );

  test(
    'copy with days streak',
    () {
      const int expectedAmount = 20;

      state = state.copyWith(daysStreak: expectedAmount);
      final state2 = state.copyWith();

      expect(state.daysStreak, expectedAmount);
      expect(state2.daysStreak, expectedAmount);
    },
  );

  test(
    'copy with amount of remembered flashcards',
    () {
      const int expectedAmount = 200;

      state = state.copyWith(amountOfRememberedFlashcards: expectedAmount);
      final state2 = state.copyWith();

      expect(state.amountOfRememberedFlashcards, expectedAmount);
      expect(state2.amountOfRememberedFlashcards, expectedAmount);
    },
  );

  test(
    'copy with info',
    () {
      const ProfileInfo expectedInfo = ProfileInfo.userHasBeenSignedOut;

      state = state.copyWithInfo(expectedInfo);

      expect(
        state.status,
        const BlocStatusComplete<ProfileInfo>(info: expectedInfo),
      );
    },
  );

  test(
    'copy with error',
    () {
      const ProfileError expectedError = ProfileError.wrongPassword;

      state = state.copyWithError(expectedError);

      expect(
        state.status,
        const BlocStatusError<ProfileError>(error: expectedError),
      );
    },
  );
}

import 'package:fiszkomaniak/features/profile/bloc/profile_bloc.dart';
import 'package:fiszkomaniak/models/user_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late ProfileState state;

  setUp(() {
    state = const ProfileState();
  });

  test('initial state', () {
    expect(state.loggedUserData, null);
  });

  test('copy with data', () {
    final User userData = createUser(avatarUrl: 'avatar/url');

    final ProfileState state2 = state.copyWith(loggedUserData: userData);
    final ProfileState state3 = state2.copyWith();

    expect(state2.loggedUserData, userData);
    expect(state3.loggedUserData, userData);
  });
}

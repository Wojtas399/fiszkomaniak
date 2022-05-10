import 'package:fiszkomaniak/features/profile/bloc/profile_bloc.dart';
import 'package:fiszkomaniak/models/user_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late ProfileState state;

  setUp(() {
    state = const ProfileState();
  });

  test('initial state', () {
    expect(state.userData, null);
  });

  test('copy with data', () {
    final User userData = createUser(avatarUrl: 'avatar/url');

    final ProfileState state2 = state.copyWith(userData: userData);
    final ProfileState state3 = state2.copyWith();

    expect(state2.userData, userData);
    expect(state3.userData, userData);
  });
}

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
    expect(state.amountOfDaysInARow, 0);
    expect(state.amountOfAllFlashcards, 0);
  });

  test('copy with data', () {
    final User userData = createUser(avatarUrl: 'avatar/url');

    final ProfileState state2 = state.copyWith(loggedUserData: userData);
    final ProfileState state3 = state2.copyWith();

    expect(state2.loggedUserData, userData);
    expect(state3.loggedUserData, userData);
  });

  test('copy with amount of days in a row', () {
    const int amount = 4;

    final ProfileState state2 = state.copyWith(amountOfDaysInARow: amount);
    final ProfileState state3 = state2.copyWith();

    expect(state2.amountOfDaysInARow, amount);
    expect(state3.amountOfDaysInARow, amount);
  });

  test('copy with amount of all flashcards', () {
    const int amount = 100;

    final ProfileState state2 = state.copyWith(amountOfAllFlashcards: amount);
    final ProfileState state3 = state2.copyWith();

    expect(state2.amountOfAllFlashcards, amount);
    expect(state3.amountOfAllFlashcards, amount);
  });
}

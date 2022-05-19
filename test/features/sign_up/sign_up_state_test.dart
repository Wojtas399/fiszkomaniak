import 'package:fiszkomaniak/features/sign_up/bloc/sign_up_state.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late SignUpState state;

  setUp(() {
    state = const SignUpState();
  });

  test('initial state', () {
    expect(state.username, '');
    expect(state.email, '');
    expect(state.password, '');
    expect(state.passwordConfirmation, '');
  });

  test('copy with username', () {
    const String username = 'username';

    final SignUpState state2 = state.copyWith(username: username);
    final SignUpState state3 = state2.copyWith();

    expect(state2.username, username);
    expect(state3.username, username);
  });

  test('copy with email', () {
    const String email = 'email';

    final SignUpState state2 = state.copyWith(email: email);
    final SignUpState state3 = state2.copyWith();

    expect(state2.email, email);
    expect(state3.email, email);
  });

  test('copy with password', () {
    const String password = 'password';

    final SignUpState state2 = state.copyWith(password: password);
    final SignUpState state3 = state2.copyWith();

    expect(state2.password, password);
    expect(state3.password, password);
  });

  test('copy with password confirmation', () {
    const String passwordConfirmation = 'password confirmation';

    final SignUpState state2 = state.copyWith(
      passwordConfirmation: passwordConfirmation,
    );
    final SignUpState state3 = state2.copyWith();

    expect(state2.passwordConfirmation, passwordConfirmation);
    expect(state3.passwordConfirmation, passwordConfirmation);
  });

  test('is correct password confirmation, passwords are not the same', () {
    state = state.copyWith(
      password: 'password',
      passwordConfirmation: 'pass',
    );

    expect(state.isCorrectPasswordConfirmation, false);
  });

  test('is correct password confirmation, passwords are the same', () {
    state = state.copyWith(
      password: 'password',
      passwordConfirmation: 'password',
    );

    expect(state.isCorrectPasswordConfirmation, true);
  });

  test('is button disabled, incorrect username', () {
    state = state.copyWith(
      username: 'use',
      email: 'email@example.com',
      password: 'password',
      passwordConfirmation: 'password',
    );

    expect(state.isDisabledButton, true);
  });

  test('is button disabled, incorrect email', () {
    state = state.copyWith(
      username: 'username',
      email: 'email@example',
      password: 'password',
      passwordConfirmation: 'password',
    );

    expect(state.isDisabledButton, true);
  });

  test('is button disabled, incorrect password', () {
    state = state.copyWith(
      username: 'username',
      email: 'email@example.com',
      password: 'passw',
      passwordConfirmation: 'password',
    );

    expect(state.isDisabledButton, true);
  });

  test('is button disabled, incorrect password confirmation', () {
    state = state.copyWith(
      username: 'username',
      email: 'email@example.com',
      password: 'password',
      passwordConfirmation: 'password123',
    );

    expect(state.isDisabledButton, true);
  });

  test('is button disabled, all values are correct', () {
    state = state.copyWith(
      username: 'username',
      email: 'email@example.com',
      password: 'password',
      passwordConfirmation: 'password',
    );

    expect(state.isDisabledButton, false);
  });
}

import 'package:fiszkomaniak/features/sign_in/bloc/sign_in_state.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late SignInState state;

  setUp(() {
    state = const SignInState();
  });

  test('initial state', () {
    expect(state.email, '');
    expect(state.password, '');
  });

  test('copy with email', () {
    const String email = 'email';

    final SignInState state2 = state.copyWith(email: email);
    final SignInState state3 = state2.copyWith();

    expect(state2.email, email);
    expect(state3.email, email);
  });

  test('copy with password', () {
    const String password = 'password';

    final SignInState state2 = state.copyWith(password: password);
    final SignInState state3 = state2.copyWith();

    expect(state2.password, password);
    expect(state3.password, password);
  });

  test('is button disabled, email is empty', () {
    state = state.copyWith(password: 'password');

    expect(state.isButtonDisabled, true);
  });

  test('is button disabled, password is empty', () {
    state = state.copyWith(email: 'email');

    expect(state.isButtonDisabled, true);
  });

  test('is button disabled, email and password are not empty', () {
    state = state.copyWith(email: 'email', password: 'password');

    expect(state.isButtonDisabled, false);
  });
}

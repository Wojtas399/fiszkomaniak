import 'package:fiszkomaniak/validators/email_validator.dart';
import 'package:flutter_test/flutter_test.dart';

class EmailValidatorMixin with EmailValidator {}

void main() {
  final mixin = EmailValidatorMixin();

  test(
    'should return false if email does not have monkey mark',
    () {
      final bool isCorrect = mixin.isEmailValid('emailexample.com');

      expect(isCorrect, false);
    },
  );

  test(
    'should return false if email does not have domain name',
    () {
      final bool isCorrect = mixin.isEmailValid('email@example.');

      expect(isCorrect, false);
    },
  );

  test(
    'should return false if email is too short',
    () {
      final bool isCorrect = mixin.isEmailValid('em');

      expect(isCorrect, false);
    },
  );

  test(
    'should return true if email is correct',
    () {
      final bool isCorrect = mixin.isEmailValid('email@example.com');

      expect(isCorrect, true);
    },
  );
}

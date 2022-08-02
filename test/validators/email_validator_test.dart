import 'package:flutter_test/flutter_test.dart';
import 'package:fiszkomaniak/validators/email_validator.dart';

void main() {
  final validator = EmailValidator();

  test(
    'should not be valid if does not have monkey mark',
    () {
      final bool isValid = validator.isValid('emailexample.com');

      expect(isValid, false);
    },
  );

  test(
    'should not be valid if does not have domain name',
    () {
      final bool isValid = validator.isValid('email@example.');

      expect(isValid, false);
    },
  );

  test(
    'should not be valid if is too short',
    () {
      final bool isValid = validator.isValid('em');

      expect(isValid, false);
    },
  );

  test(
    'should be valid if matches to email template',
    () {
      final bool isValid = validator.isValid('email@example.com');

      expect(isValid, true);
    },
  );
}

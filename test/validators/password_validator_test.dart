import 'package:fiszkomaniak/validators/password_validator.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final validator = PasswordValidator();

  test(
    'should be valid if has length longer or equal to 6 letters',
    () {
      final bool isValid = validator.isValid('passwo');

      expect(isValid, true);
    },
  );

  test(
    'should not be valid if has length shorter than 6 letters',
    () {
      final bool isValid = validator.isValid('pass');

      expect(isValid, false);
    },
  );
}

import 'package:fiszkomaniak/validators/username_validator.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final validator = UsernameValidator();

  test(
    'should be valid if has length longer or equal to 4 letters',
    () {
      final bool isValid = validator.isValid('user');

      expect(isValid, true);
    },
  );

  test(
    'should not be valid if has length shorter than 4 letters',
    () {
      final bool isValid = validator.isValid('us');

      expect(isValid, false);
    },
  );
}

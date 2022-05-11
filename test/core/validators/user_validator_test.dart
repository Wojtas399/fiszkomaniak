import 'package:fiszkomaniak/core/validators/user_validator.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('is username correct', () {
    test('length is shorter than 4 letters, should be false', () {
      final bool isCorrect = UserValidator.isUsernameCorrect('use');

      expect(isCorrect, false);
    });

    test('length is longer or equal to 4 letters, should be true', () {
      final bool isCorrect = UserValidator.isUsernameCorrect('username');

      expect(isCorrect, true);
    });
  });

  group('is email correct', () {
    test('does not include monkey mark, should be false', () {
      final bool isCorrect = UserValidator.isEmailCorrect(
        'jan.kowalski.example.com',
      );

      expect(isCorrect, false);
    });

    test('does not include domain extension, should be false', () {
      final bool isCorrect = UserValidator.isEmailCorrect(
        'jan.kowalski@example.',
      );

      expect(isCorrect, false);
    });

    test('has a dot after monkey mark, should be false', () {
      final bool isCorrect = UserValidator.isEmailCorrect(
        'jan.kowalski@.example.com',
      );

      expect(isCorrect, false);
    });

    test('correct email, should be true', () {
      final bool isCorrect = UserValidator.isEmailCorrect(
        'jan.kowalski@example.com',
      );

      expect(isCorrect, true);
    });
  });

  group('is password correct', () {
    test('length is shorter than 6 letters, should be false', () {
      final bool isCorrect = UserValidator.isPasswordCorrect('passw');

      expect(isCorrect, false);
    });

    test('length is longer or equal to 6 letters, should be true', () {
      final bool isCorrect = UserValidator.isPasswordCorrect('passwd');

      expect(isCorrect, true);
    });
  });
}

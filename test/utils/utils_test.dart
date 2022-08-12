import 'package:flutter_test/flutter_test.dart';
import 'package:fiszkomaniak/utils/utils.dart';

void main() {
  test(
    'two digits, should add 0 before number if given number has one digit',
    () {
      const int givenNumber = 5;
      const String expectedNumber = '05';

      final String number = Utils.twoDigits(givenNumber);

      expect(number, expectedNumber);
    },
  );

  test(
    'two digits, should return the same number as string if given number has two or more digits',
    () {
      const int givenNumber = 50;
      const String expectedNumber = '50';

      final String number = Utils.twoDigits(givenNumber);

      expect(number, expectedNumber);
    },
  );

  test(
    'remove last element',
    () {
      const List<int> givenElements = [1, 2, 3, 4];
      const List<int> expectedElements = [1, 2, 3];

      final List<int> elements = Utils.removeLastElement(givenElements);

      expect(elements, expectedElements);
    },
  );
}

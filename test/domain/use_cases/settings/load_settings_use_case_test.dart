import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:fiszkomaniak/domain/use_cases/settings/load_settings_use_case.dart';
import 'package:fiszkomaniak/interfaces/settings_interface.dart';

class MockSettingsInterface extends Mock implements SettingsInterface {}

void main() {
  final settingsInterface = MockSettingsInterface();
  final useCase = LoadSettingsUseCase(settingsInterface: settingsInterface);

  test(
    'should call method responsible for loading settings',
    () async {
      when(
        () => settingsInterface.loadSettings(),
      ).thenAnswer((_) async => '');

      await useCase.execute();

      verify(
        () => settingsInterface.loadSettings(),
      ).called(1);
    },
  );
}

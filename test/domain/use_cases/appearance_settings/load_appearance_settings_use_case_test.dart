import 'package:fiszkomaniak/domain/use_cases/appearance_settings/load_appearance_settings_use_case.dart';
import 'package:fiszkomaniak/interfaces/appearance_settings_interface.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAppearanceSettingsInterface extends Mock
    implements AppearanceSettingsInterface {}

void main() {
  final appearanceSettingsInterface = MockAppearanceSettingsInterface();
  final useCase = LoadAppearanceSettingsUseCase(
    appearanceSettingsInterface: appearanceSettingsInterface,
  );

  test(
    'should call method responsible for loading appearance settings',
    () async {
      when(
        () => appearanceSettingsInterface.loadSettings(),
      ).thenAnswer((_) async => '');

      await useCase.execute();

      verify(() => appearanceSettingsInterface.loadSettings()).called(1);
    },
  );
}

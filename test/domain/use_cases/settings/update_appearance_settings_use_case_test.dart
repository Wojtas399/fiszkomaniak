import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:fiszkomaniak/domain/use_cases/settings/update_appearance_settings_use_case.dart';
import 'package:fiszkomaniak/interfaces/settings_interface.dart';

class MockSettingsInterface extends Mock implements SettingsInterface {}

void main() {
  final settingsInterface = MockSettingsInterface();
  final useCase = UpdateAppearanceSettingsUseCase(
    settingsInterface: settingsInterface,
  );

  test(
    'should call method responsible for updating appearance settings',
    () async {
      when(
        () => settingsInterface.updateAppearanceSettings(
          isDarkModeOn: false,
        ),
      ).thenAnswer((_) async => '');

      await useCase.execute(isDarkModeOn: false);

      verify(
        () => settingsInterface.updateAppearanceSettings(isDarkModeOn: false),
      ).called(1);
    },
  );
}

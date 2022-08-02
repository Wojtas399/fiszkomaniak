import 'package:fiszkomaniak/domain/use_cases/appearance_settings/update_appearance_settings_use_case.dart';
import 'package:fiszkomaniak/interfaces/appearance_settings_interface.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAppearanceSettingsInterface extends Mock
    implements AppearanceSettingsInterface {}

void main() {
  final appearanceSettingsInterface = MockAppearanceSettingsInterface();
  final useCase = UpdateAppearanceSettingsUseCase(
    appearanceSettingsInterface: appearanceSettingsInterface,
  );

  test(
    'should call method responsible for updating appearance settings',
    () async {
      when(
        () => appearanceSettingsInterface.updateSettings(
          isDarkModeOn: false,
          isDarkModeCompatibilityWithSystemOn: true,
          isSessionTimerInvisibilityOn: false,
        ),
      ).thenAnswer((_) async => '');

      await useCase.execute(
        isDarkModeOn: false,
        isDarkModeCompatibilityWithSystemOn: true,
        isSessionTimerInvisibilityOn: false,
      );

      verify(
        () => appearanceSettingsInterface.updateSettings(
          isDarkModeOn: false,
          isDarkModeCompatibilityWithSystemOn: true,
          isSessionTimerInvisibilityOn: false,
        ),
      ).called(1);
    },
  );
}

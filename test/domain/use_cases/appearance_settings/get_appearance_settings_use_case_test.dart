import 'package:fiszkomaniak/domain/entities/appearance_settings.dart';
import 'package:fiszkomaniak/domain/use_cases/appearance_settings/get_appearance_settings_use_case.dart';
import 'package:fiszkomaniak/interfaces/appearance_settings_interface.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAppearanceSettingsInterface extends Mock
    implements AppearanceSettingsInterface {}

void main() {
  final appearanceSettingsInterface = MockAppearanceSettingsInterface();
  final useCase = GetAppearanceSettingsUseCase(
    appearanceSettingsInterface: appearanceSettingsInterface,
  );

  test(
    'should return stream which include appearance settings',
    () async {
      const AppearanceSettings expectedSettings = AppearanceSettings(
        isDarkModeOn: false,
        isDarkModeCompatibilityWithSystemOn: true,
        isSessionTimerInvisibilityOn: false,
      );
      when(
        () => appearanceSettingsInterface.appearanceSettings$,
      ).thenAnswer((_) => Stream.value(expectedSettings));

      final settings = await useCase.execute().first;

      expect(settings, expectedSettings);
    },
  );
}

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:fiszkomaniak/domain/entities/settings.dart';
import 'package:fiszkomaniak/domain/use_cases/settings/get_settings_use_case.dart';
import 'package:fiszkomaniak/interfaces/settings_interface.dart';

class MockSettingsInterface extends Mock implements SettingsInterface {}

void main() {
  final settingsInterface = MockSettingsInterface();
  final useCase = GetSettingsUseCase(settingsInterface: settingsInterface);

  test(
    'should return stream which contains settings',
    () async {
      final Settings expectedSettings = createSettings();
      when(
        () => settingsInterface.settings$,
      ).thenAnswer((_) => Stream.value(expectedSettings));

      final Stream<Settings> settings$ = useCase.execute();

      expect(await settings$.first, expectedSettings);
    },
  );
}

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:fiszkomaniak/domain/use_cases/settings/update_notifications_settings_use_case.dart';
import 'package:fiszkomaniak/interfaces/settings_interface.dart';

class MockSettingsInterface extends Mock implements SettingsInterface {}

void main() {
  final settingsInterface = MockSettingsInterface();
  final useCase = UpdateNotificationsSettingsUseCase(
    settingsInterface: settingsInterface,
  );

  test(
    'should call method responsible for updating notifications settings',
    () async {
      when(
        () => settingsInterface.updateNotificationsSettings(
          areLossOfDaysStreakNotificationsOn: false,
        ),
      ).thenAnswer((_) async => '');

      await useCase.execute(
        areLossOfDaysStreakNotificationsOn: false,
      );

      verify(
        () => settingsInterface.updateNotificationsSettings(
          areLossOfDaysStreakNotificationsOn: false,
        ),
      ).called(1);
    },
  );
}

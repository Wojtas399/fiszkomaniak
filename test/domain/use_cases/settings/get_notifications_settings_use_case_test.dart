import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:fiszkomaniak/domain/entities/settings.dart';
import 'package:fiszkomaniak/domain/use_cases/settings/get_notifications_settings_use_case.dart';
import 'package:fiszkomaniak/interfaces/settings_interface.dart';

class MockSettingsInterface extends Mock implements SettingsInterface {}

void main() {
  final settingsInterface = MockSettingsInterface();
  final useCase = GetNotificationsSettingsUseCase(
    settingsInterface: settingsInterface,
  );

  test(
    'should return stream which contains notifications settings',
    () async {
      final NotificationsSettings expectedSettings = createNotificationsSettings();
      when(
        () => settingsInterface.notificationsSettings$,
      ).thenAnswer((_) => Stream.value(expectedSettings));

      final Stream<NotificationsSettings> settings$ = useCase.execute();

      expect(await settings$.first, expectedSettings);
    },
  );
}

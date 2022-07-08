import 'package:fiszkomaniak/domain/use_cases/notifications_settings/load_notifications_settings_use_case.dart';
import 'package:fiszkomaniak/interfaces/notifications_settings_interface.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockNotificationsSettingsInterface extends Mock
    implements NotificationsSettingsInterface {}

void main() {
  final notificationsSettingsInterface = MockNotificationsSettingsInterface();
  final useCase = LoadNotificationsSettingsUseCase(
    notificationsSettingsInterface: notificationsSettingsInterface,
  );

  test(
    'should call method responsible for loading notifications settings',
    () async {
      when(
        () => notificationsSettingsInterface.loadSettings(),
      ).thenAnswer((_) async => '');

      await useCase.execute();

      verify(() => notificationsSettingsInterface.loadSettings()).called(1);
    },
  );
}

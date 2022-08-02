import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:fiszkomaniak/domain/use_cases/notifications/initialize_notifications_settings_use_case.dart';
import 'package:fiszkomaniak/interfaces/notifications_interface.dart';

class MockNotificationsInterface extends Mock
    implements NotificationsInterface {}

void main() {
  final notificationsInterface = MockNotificationsInterface();
  final useCase = InitializeNotificationsSettingsUseCase(
    notificationsInterface: notificationsInterface,
  );

  test(
    'should call method responsible for initializing notifications settings',
    () async {
      when(
        () => notificationsInterface.initializeSettings(),
      ).thenAnswer((_) async => '');

      await useCase.execute();

      verify(
        () => notificationsInterface.initializeSettings(),
      ).called(1);
    },
  );
}

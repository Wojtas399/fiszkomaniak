import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:fiszkomaniak/interfaces/local_notifications_interface.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/notification_model.dart';

part 'local_notifications_state.dart';

part 'local_notifications_event.dart';

class LocalNotificationsBloc
    extends Bloc<LocalNotificationsEvent, LocalNotificationsState> {
  late final LocalNotificationsInterface _localNotificationsInterface;
  StreamSubscription? _notificationsListener;

  LocalNotificationsBloc({
    required LocalNotificationsInterface localNotificationsInterface,
  }) : super(const LocalNotificationsStateInitial()) {
    _localNotificationsInterface = localNotificationsInterface;
    on<LocalNotificationsEventInitialize>(_initialize);
    on<LocalNotificationsEventNotificationSelected>(_notificationSelected);
  }

  @override
  Future<void> close() {
    _notificationsListener?.cancel();
    return super.close();
  }

  Future<void> _initialize(
    LocalNotificationsEventInitialize event,
    Emitter<LocalNotificationsState> emit,
  ) async {
    try {
      final NotificationType? notification =
          await _localNotificationsInterface.didNotificationLaunchApp();
      if (notification != null) {
        add(LocalNotificationsEventNotificationSelected(type: notification));
      }
      await _localNotificationsInterface.initializeSettings(
        onNotificationSelected: (NotificationType type) {
          add(LocalNotificationsEventNotificationSelected(type: type));
        },
      );
      emit(LocalNotificationsStateLoaded());
    } catch (error) {
      emit(LocalNotificationsStateError(message: error.toString()));
    }
  }

  void _notificationSelected(
    LocalNotificationsEventNotificationSelected event,
    Emitter<LocalNotificationsState> emit,
  ) {
    final NotificationType type = event.type;
    if (type is NotificationTypeSession) {
      emit(LocalNotificationsStateSessionSelected(sessionId: type.sessionId));
    } else if (type is NotificationTypeDayStreakLose) {
      //TODO
    }
  }
}

import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:fiszkomaniak/interfaces/notifications_interface.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/notification_model.dart';

part 'notifications_state.dart';

part 'notifications_event.dart';

class NotificationsBloc extends Bloc<NotificationsEvent, NotificationsState> {
  late final NotificationsInterface _notificationsInterface;
  StreamSubscription? _notificationsListener;

  NotificationsBloc({
    required NotificationsInterface notificationsInterface,
  }) : super(const NotificationsStateInitial()) {
    _notificationsInterface = notificationsInterface;
    on<NotificationsEventInitialize>(_initialize);
    on<NotificationsEventNotificationSelected>(_notificationSelected);
  }

  @override
  Future<void> close() {
    _notificationsListener?.cancel();
    return super.close();
  }

  Future<void> _initialize(
    NotificationsEventInitialize event,
    Emitter<NotificationsState> emit,
  ) async {
    try {
      final NotificationType? notification =
          await _notificationsInterface.didNotificationLaunchApp();
      if (notification != null) {
        add(NotificationsEventNotificationSelected(type: notification));
      }
      await _notificationsInterface.initializeSettings(
        onNotificationSelected: (NotificationType type) {
          add(NotificationsEventNotificationSelected(type: type));
        },
      );
      emit(NotificationsStateLoaded());
    } catch (error) {
      emit(NotificationsStateError(message: error.toString()));
    }
  }

  void _notificationSelected(
    NotificationsEventNotificationSelected event,
    Emitter<NotificationsState> emit,
  ) {
    final NotificationType type = event.type;
    if (type is NotificationTypeSession) {
      emit(NotificationsStateSessionSelected(sessionId: type.sessionId));
    } else if (type is NotificationTypeDayStreakLose) {
      //TODO
    }
  }
}

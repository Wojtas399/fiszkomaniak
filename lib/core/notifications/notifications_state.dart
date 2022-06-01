part of 'notifications_bloc.dart';

class NotificationsState extends Equatable {
  final NotificationsStatus status;
  final bool areScheduledNotificationsOn;
  final bool areDefaultNotificationsOn;
  final bool areDaysStreakLoseNotificationsOn;

  const NotificationsState({
    this.status = const NotificationsStatusInitial(),
    this.areScheduledNotificationsOn = false,
    this.areDefaultNotificationsOn = false,
    this.areDaysStreakLoseNotificationsOn = false,
  });

  @override
  List<Object> get props => [
        status,
        areScheduledNotificationsOn,
        areDefaultNotificationsOn,
        areDaysStreakLoseNotificationsOn,
      ];

  NotificationsState copyWith({
    NotificationsStatus? status,
    bool? areScheduledNotificationsOn,
    bool? areDefaultNotificationsOn,
    bool? areDaysStreakLoseNotificationsOn,
  }) {
    return NotificationsState(
      status: status ?? NotificationsStatusLoaded(),
      areScheduledNotificationsOn:
          areScheduledNotificationsOn ?? this.areScheduledNotificationsOn,
      areDefaultNotificationsOn:
          areDefaultNotificationsOn ?? this.areDefaultNotificationsOn,
      areDaysStreakLoseNotificationsOn: areDaysStreakLoseNotificationsOn ??
          this.areDaysStreakLoseNotificationsOn,
    );
  }
}

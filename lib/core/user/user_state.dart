part of 'user_bloc.dart';

class UserState extends Equatable {
  final InitializationStatus initializationStatus;
  final UserStatus status;
  final User? loggedUser;

  const UserState({
    this.initializationStatus = InitializationStatus.loading,
    this.status = const UserStatusInitial(),
    this.loggedUser,
  });

  @override
  List<Object> get props => [
        initializationStatus,
        status,
        loggedUser ?? '',
      ];

  List<Date> get _daysInARow {
    final List<Date>? dates = loggedUser?.days.map((day) => day.date).toList();
    if (dates != null) {
      return DateUtils.getDaysInARow(Date.now(), dates);
    }
    return [];
  }

  int get amountOfDaysInARow => _daysInARow.length;

  UserState copyWith({
    InitializationStatus? initializationStatus,
    UserStatus? status,
    User? loggedUser,
  }) {
    return UserState(
      initializationStatus: initializationStatus ?? this.initializationStatus,
      status: status ?? UserStatusLoaded(),
      loggedUser: loggedUser ?? this.loggedUser,
    );
  }
}

part of 'user_bloc.dart';

class UserState extends Equatable {
  final UserStatus status;
  final User? loggedUser;

  const UserState({
    this.status = const UserStatusInitial(),
    this.loggedUser,
  });

  @override
  List<Object> get props => [
        status,
        loggedUser ?? '',
      ];

  List<DateTime> get _daysInARow {
    final List<DateTime>? dates =
        loggedUser?.days.map((day) => day.date).toList();
    if (dates != null) {
      return DateUtils.getDaysInARow(DateTime.now(), dates);
    }
    return [];
  }

  int get amountOfDaysInARow => _daysInARow.length;

  UserState copyWith({
    UserStatus? status,
    User? loggedUser,
  }) {
    return UserState(
      status: status ?? UserStatusLoaded(),
      loggedUser: loggedUser ?? this.loggedUser,
    );
  }
}

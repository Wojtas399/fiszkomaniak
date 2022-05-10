import 'package:equatable/equatable.dart';
import 'package:fiszkomaniak/models/day_model.dart';

class User extends Equatable {
  final String? avatarUrl;
  final List<Day> days;

  const User({
    required this.avatarUrl,
    required this.days,
  });

  @override
  List<Object> get props => [
        avatarUrl ?? '',
        days,
      ];
}

User createUser({
  String? avatarUrl,
  List<Day>? days,
}) {
  return User(
    avatarUrl: avatarUrl ?? '',
    days: days ?? [],
  );
}

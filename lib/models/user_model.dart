import 'package:equatable/equatable.dart';
import 'package:fiszkomaniak/models/day_model.dart';

class User extends Equatable {
  final String email;
  final String username;
  final String? avatarUrl;
  final List<Day> days;

  const User({
    required this.email,
    required this.username,
    required this.avatarUrl,
    required this.days,
  });

  @override
  List<Object> get props => [
        email,
        username,
        avatarUrl ?? '',
        days,
      ];
}

User createUser({
  String? email,
  String? username,
  String? avatarUrl,
  List<Day>? days,
}) {
  return User(
    email: email ?? '',
    username: username ?? '',
    avatarUrl: avatarUrl ?? '',
    days: days ?? [],
  );
}

import 'package:equatable/equatable.dart';
import 'package:fiszkomaniak/models/day_model.dart';

class User extends Equatable {
  final String email;
  final String username;
  final List<Day> days;

  const User({
    required this.email,
    required this.username,
    required this.days,
  });

  @override
  List<Object> get props => [
        email,
        username,
        days,
      ];

  User copyWith({
    String? email,
    String? username,
    List<Day>? days,
  }) {
    return User(
      email: email ?? this.email,
      username: username ?? this.username,
      days: days ?? this.days,
    );
  }
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
    days: days ?? [],
  );
}

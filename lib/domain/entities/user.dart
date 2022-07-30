import 'package:equatable/equatable.dart';
import 'day.dart';

class User extends Equatable {
  final String? avatarUrl;
  final String email;
  final String username;
  final List<Day> days;

  const User({
    required this.avatarUrl,
    required this.email,
    required this.username,
    required this.days,
  });

  @override
  List<Object> get props => [
        avatarUrl ?? '',
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
      avatarUrl: avatarUrl,
      email: email ?? this.email,
      username: username ?? this.username,
      days: days ?? this.days,
    );
  }

  User copyWithAvatarUrl(String? avatarUrl) {
    return User(
      avatarUrl: avatarUrl,
      email: email,
      username: username,
      days: days,
    );
  }
}

User createUser({
  String? avatarUrl,
  String? email,
  String? username,
  List<Day>? days,
}) {
  return User(
    avatarUrl: avatarUrl,
    email: email ?? '',
    username: username ?? '',
    days: days ?? [],
  );
}

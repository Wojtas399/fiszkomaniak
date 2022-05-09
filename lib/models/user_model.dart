import 'package:equatable/equatable.dart';
import 'package:fiszkomaniak/models/day_model.dart';

class User extends Equatable {
  final List<Day> days;

  const User({required this.days});

  @override
  List<Object> get props => [days];
}

User createUser({List<Day>? days}) {
  return User(days: days ?? []);
}

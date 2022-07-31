import 'package:equatable/equatable.dart';
import 'day_db_model.dart';

class UserDbModel extends Equatable {
  final String username;
  final List<DayDbModel>? days;

  const UserDbModel({
    required this.username,
    this.days,
  });

  UserDbModel.fromJson(Map<String, Object?> json)
      : this(
          username: json['username']! as String,
          days: (json['days'] as List?)
              ?.map((day) => DayDbModel.fromJson(day))
              .toList(),
        );

  Map<String, Object?> toJson() {
    return {
      'username': username,
      'days': days?.map((day) => day.toJson()).toList(),
    }..removeWhere((key, value) => value == null);
  }

  UserDbModel copyWith({
    String? username,
    List<DayDbModel>? days,
  }) {
    return UserDbModel(
      username: username ?? this.username,
      days: days ?? this.days,
    );
  }

  @override
  List<Object> get props => [
        username,
        days ?? '',
      ];
}

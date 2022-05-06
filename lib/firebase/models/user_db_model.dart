import 'package:equatable/equatable.dart';
import 'package:fiszkomaniak/firebase/models/day_db_model.dart';

class UserDbModel extends Equatable {
  final String username;
  final String? avatarPath;
  final List<DayDbModel>? days;

  const UserDbModel({
    required this.username,
    this.avatarPath,
    this.days,
  });

  UserDbModel.fromJson(Map<String, Object?> json)
      : this(
            username: json['username']! as String,
            avatarPath: json['avatarPath'] as String?,
            days: (json['days'] as List?)
                ?.map((day) => DayDbModel.fromJson(day))
                .toList());

  Map<String, Object?> toJson() {
    return {
      'username': username,
      'avatarPath': avatarPath,
      'days': days?.map((day) => day.toJson()).toList(),
    }..removeWhere((key, value) => value == null);
  }

  UserDbModel copyWith({
    String? username,
    String? avatarPath,
    List<DayDbModel>? days,
  }) {
    return UserDbModel(
      username: username ?? this.username,
      avatarPath: avatarPath ?? this.avatarPath,
      days: days ?? this.days,
    );
  }

  @override
  List<Object> get props => [
        username,
        avatarPath ?? '',
        days ?? '',
      ];
}

class UserDBModel {
  final String username;
  final String avatarPath;

  UserDBModel({
    required this.username,
    required this.avatarPath,
  });

  UserDBModel.fromJson(Map<String, Object?> json)
      : this(
          username: json['username']! as String,
          avatarPath: json['avatarPath']! as String,
        );

  Map<String, Object?> toJson() {
    return {
      'username': username,
      'avatarPath': avatarPath,
    };
  }
}

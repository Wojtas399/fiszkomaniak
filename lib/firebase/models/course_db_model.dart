class CourseDbModel {
  final String name;

  CourseDbModel({required this.name});

  CourseDbModel.fromJson(Map<String, Object?> json)
      : this(name: json['name']! as String);

  Map<String, Object?> toJson() {
    return {'name': name};
  }
}

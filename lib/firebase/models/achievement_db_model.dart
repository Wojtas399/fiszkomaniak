import 'package:equatable/equatable.dart';

class AchievementDbModel extends Equatable {
  final List<String>? completedElementsIds;
  final List<AchievementConditionDbModel>? conditions;

  const AchievementDbModel({
    this.completedElementsIds,
    this.conditions,
  });

  AchievementDbModel.fromJson(Map<String, Object?> json)
      : this(
          completedElementsIds: (json['completedElementsIds']! as List)
              .map((id) => '$id')
              .toList(),
          conditions: (json['conditions']! as List)
              .asMap()
              .entries
              .map((entry) => AchievementConditionDbModel.fromJson(entry.value))
              .toList(),
        );

  Map<String, Object?> toJson() {
    return {
      'completedElementsIds': completedElementsIds,
      'conditions': conditions?.map((condition) => condition.toJson()).toList(),
    }..removeWhere((key, value) => value == null);
  }

  @override
  List<Object> get props => [
        completedElementsIds ?? '',
        conditions ?? '',
      ];
}

class AchievementConditionDbModel extends Equatable {
  final int? conditionValue;
  final String? status;

  const AchievementConditionDbModel({
    this.conditionValue,
    this.status,
  });

  AchievementConditionDbModel.fromJson(Map<String, Object?> json)
      : this(
          conditionValue: json['conditionValue']! as int,
          status: json['status']! as String,
        );

  Map<String, Object?> toJson() {
    return {
      'conditionValue': conditionValue,
      'status': status,
    }..removeWhere((key, value) => value == null);
  }

  AchievementConditionDbModel copyWithStatus(String? newStatus) {
    return AchievementConditionDbModel(
      conditionValue: conditionValue,
      status: newStatus ?? status,
    );
  }

  @override
  List<Object> get props => [
        conditionValue ?? 0,
        status ?? '',
      ];
}

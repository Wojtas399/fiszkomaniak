import 'package:equatable/equatable.dart';

class DayFlashcardDbModel extends Equatable {
  final String groupId;
  final int flashcardIndex;

  const DayFlashcardDbModel({
    required this.groupId,
    required this.flashcardIndex,
  });

  DayFlashcardDbModel.fromJson(Map<String, Object?> json)
      : this(
          groupId: json['groupId']! as String,
          flashcardIndex: json['flashcardIndex']! as int,
        );

  Map<String, Object?> toJson() {
    return {
      'groupId': groupId,
      'flashcardIndex': flashcardIndex,
    };
  }

  @override
  List<Object> get props => [groupId, flashcardIndex];
}

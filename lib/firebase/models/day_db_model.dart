import 'package:equatable/equatable.dart';

class DayDbModel extends Equatable {
  final String date;
  final List<String> rememberedFlashcardsIds;

  const DayDbModel({
    required this.date,
    required this.rememberedFlashcardsIds,
  });

  DayDbModel.fromJson(Map<String, Object?> json)
      : this(
          date: json['date']! as String,
          rememberedFlashcardsIds: (json['rememberedFlashcardsIds']! as List)
              .map((flashcardId) => flashcardId.toString())
              .toList(),
        );

  Map<String, Object> toJson() {
    return {
      'date': date,
      'rememberedFlashcardsIds': rememberedFlashcardsIds,
    };
  }

  DayDbModel copyWith({
    String? date,
    List<String>? rememberedFlashcardsIds,
  }) {
    return DayDbModel(
      date: date ?? this.date,
      rememberedFlashcardsIds:
          rememberedFlashcardsIds ?? this.rememberedFlashcardsIds,
    );
  }

  @override
  List<Object> get props => [
        date,
        rememberedFlashcardsIds,
      ];
}

DayDbModel createDayDbModel({
  String date = '',
  List<String> rememberedFlashcardsIds = const [],
}) {
  return DayDbModel(
    date: date,
    rememberedFlashcardsIds: rememberedFlashcardsIds,
  );
}

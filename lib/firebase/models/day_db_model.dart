import 'package:equatable/equatable.dart';
import 'day_flashcard_db_model.dart';

class DayDbModel extends Equatable {
  final String date;
  final List<DayFlashcardDbModel> rememberedFlashcards;

  const DayDbModel({
    required this.date,
    required this.rememberedFlashcards,
  });

  DayDbModel.fromJson(Map<String, Object?> json)
      : this(
          date: json['date']! as String,
          rememberedFlashcards: (json['rememberedFlashcards']! as List)
              .map((flashcard) => DayFlashcardDbModel.fromJson(flashcard))
              .toList(),
        );

  Map<String, Object> toJson() {
    return {
      'date': date,
      'rememberedFlashcards':
          rememberedFlashcards.map((flashcard) => flashcard.toJson()).toList(),
    };
  }

  DayDbModel copyWith({
    String? date,
    List<DayFlashcardDbModel>? rememberedFlashcards,
  }) {
    return DayDbModel(
      date: date ?? this.date,
      rememberedFlashcards: rememberedFlashcards ?? this.rememberedFlashcards,
    );
  }

  @override
  List<Object> get props => [
        date,
        rememberedFlashcards,
      ];
}

import 'package:equatable/equatable.dart';

class DayFlashcard extends Equatable {
  final String groupId;
  final int flashcardIndex;

  const DayFlashcard({
    required this.groupId,
    required this.flashcardIndex,
  });

  @override
  List<Object> get props => [groupId, flashcardIndex];
}

DayFlashcard createDayFlashcard({
  String? groupId,
  int? flashcardIndex,
}) {
  return DayFlashcard(
    groupId: groupId ?? '',
    flashcardIndex: flashcardIndex ?? 0,
  );
}

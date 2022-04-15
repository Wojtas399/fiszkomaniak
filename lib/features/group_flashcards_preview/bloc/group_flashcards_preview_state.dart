import 'package:equatable/equatable.dart';
import 'package:fiszkomaniak/models/flashcard_model.dart';

class GroupFlashcardsPreviewState extends Equatable {
  final String? groupId;
  final String? groupName;
  final List<Flashcard> flashcardsFromGroup;

  const GroupFlashcardsPreviewState({
    this.groupId,
    this.groupName,
    this.flashcardsFromGroup = const [],
  });

  GroupFlashcardsPreviewState copyWith({
    String? groupId,
    String? groupName,
    List<Flashcard>? flashcardsFromGroup,
  }) {
    return GroupFlashcardsPreviewState(
      groupId: groupId ?? this.groupId,
      groupName: groupName ?? this.groupName,
      flashcardsFromGroup: flashcardsFromGroup ?? this.flashcardsFromGroup,
    );
  }

  @override
  List<Object> get props => [
        groupId ?? '',
        groupName ?? '',
        flashcardsFromGroup,
      ];
}

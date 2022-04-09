import 'package:equatable/equatable.dart';

class FlashcardsEditorState extends Equatable {
  final String groupId;
  final String groupName;

  const FlashcardsEditorState({
    this.groupId = '',
    this.groupName = '',
  });

  FlashcardsEditorState copyWith({
    String? groupId,
    String? groupName,
  }) {
    return FlashcardsEditorState(
      groupId: groupId ?? this.groupId,
      groupName: groupName ?? this.groupName,
    );
  }

  @override
  List<Object> get props => [
        groupId,
        groupName,
      ];
}

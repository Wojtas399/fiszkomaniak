import 'package:equatable/equatable.dart';

class FlashcardsPreviewState extends Equatable {
  final String groupId;
  final String groupName;

  const FlashcardsPreviewState({
    this.groupId = '',
    this.groupName = '',
  });

  FlashcardsPreviewState copyWith({
    String? groupId,
    String? groupName,
  }) {
    return FlashcardsPreviewState(
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

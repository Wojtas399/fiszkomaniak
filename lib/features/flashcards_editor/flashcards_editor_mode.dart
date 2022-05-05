import 'package:equatable/equatable.dart';

abstract class FlashcardsEditorMode extends Equatable {
  final String groupId;

  const FlashcardsEditorMode({required this.groupId});

  @override
  List<Object> get props => [groupId];
}

class FlashcardsEditorAddMode extends FlashcardsEditorMode {
  const FlashcardsEditorAddMode({required String groupId})
      : super(groupId: groupId);
}

class FlashcardsEditorEditMode extends FlashcardsEditorMode {
  const FlashcardsEditorEditMode({required String groupId})
      : super(groupId: groupId);
}

import 'package:equatable/equatable.dart';
import 'package:fiszkomaniak/models/group_model.dart';

abstract class GroupCreatorMode extends Equatable {
  const GroupCreatorMode();

  @override
  List<Object> get props => [];
}

class GroupCreatorCreateMode extends GroupCreatorMode {
  const GroupCreatorCreateMode();
}

class GroupCreatorEditMode extends GroupCreatorMode {
  final Group group;

  const GroupCreatorEditMode({required this.group});

  @override
  List<Object> get props => [group];
}

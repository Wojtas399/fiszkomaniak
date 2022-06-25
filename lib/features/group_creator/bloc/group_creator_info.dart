import 'package:equatable/equatable.dart';

abstract class GroupCreatorInfo extends Equatable {
  const GroupCreatorInfo();

  @override
  List<Object> get props => [];
}

class GroupCreatorInfoGroupNameIsAlreadyTaken extends GroupCreatorInfo {
  const GroupCreatorInfoGroupNameIsAlreadyTaken();
}

class GroupCreatorInfoGroupHasBeenAdded extends GroupCreatorInfo {
  const GroupCreatorInfoGroupHasBeenAdded();
}

class GroupCreatorInfoGroupHasBeenUpdated extends GroupCreatorInfo {
  final String groupId;

  const GroupCreatorInfoGroupHasBeenUpdated({required this.groupId});

  @override
  List<Object> get props => [groupId];
}

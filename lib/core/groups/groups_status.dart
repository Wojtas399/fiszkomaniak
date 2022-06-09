part of 'groups_bloc.dart';

abstract class GroupsStatus extends Equatable {
  const GroupsStatus();

  @override
  List<Object> get props => [];
}

class GroupsStatusInitial extends GroupsStatus {
  const GroupsStatusInitial();
}

class GroupsStatusLoading extends GroupsStatus {}

class GroupsStatusLoaded extends GroupsStatus {}

class GroupsStatusGroupAdded extends GroupsStatus {}

class GroupsStatusGroupUpdated extends GroupsStatus {}

class GroupsStatusGroupRemoved extends GroupsStatus {}

class GroupsStatusError extends GroupsStatus {
  final String message;

  const GroupsStatusError({required this.message});

  @override
  List<Object> get props => [message];
}

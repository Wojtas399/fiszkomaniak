import 'package:equatable/equatable.dart';

abstract class GroupCreatorStatus extends Equatable {
  const GroupCreatorStatus();

  @override
  List<Object> get props => [];
}

class GroupCreatorStatusInitial extends GroupCreatorStatus {
  const GroupCreatorStatusInitial();
}

class GroupCreatorStatusEditing extends GroupCreatorStatus {}

class GroupCreatorStatusLoading extends GroupCreatorStatus {}

class GroupCreatorStatusGroupAdded extends GroupCreatorStatus {}

class GroupCreatorStatusError extends GroupCreatorStatus {
  final String message;

  const GroupCreatorStatusError({required this.message});

  @override
  List<Object> get props => [];
}

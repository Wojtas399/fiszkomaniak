part of 'study_bloc.dart';

abstract class StudyEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class StudyEventInitialize extends StudyEvent {}

class StudyEventGroupsItemsChanged extends StudyEvent {
  final List<GroupItemParams> groupsItemsParams;

  StudyEventGroupsItemsChanged({required this.groupsItemsParams});

  @override
  List<Object> get props => [groupsItemsParams];
}

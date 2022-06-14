part of 'study_bloc.dart';

abstract class StudyEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class StudyEventInitialize extends StudyEvent {}

class StudyEventGroupsItemsChanged extends StudyEvent {
  final List<GroupItemParams> groupsItems;

  StudyEventGroupsItemsChanged({required this.groupsItems});

  @override
  List<Object> get props => [groupsItems];
}

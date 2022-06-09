part of 'groups_bloc.dart';

abstract class GroupsEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class GroupsEventInitialize extends GroupsEvent {}

class GroupsEventGroupsChanged extends GroupsEvent {
  final List<Group> addedGroups;
  final List<Group> updatedGroups;
  final List<Group> deletedGroups;

  GroupsEventGroupsChanged({
    required this.addedGroups,
    required this.updatedGroups,
    required this.deletedGroups,
  });

  @override
  List<Object> get props => [
        addedGroups,
        updatedGroups,
        deletedGroups,
      ];
}

class GroupsEventAddGroup extends GroupsEvent {
  final String name;
  final String courseId;
  final String nameForQuestions;
  final String nameForAnswers;

  GroupsEventAddGroup({
    required this.name,
    required this.courseId,
    required this.nameForQuestions,
    required this.nameForAnswers,
  });

  @override
  List<Object> get props => [
        name,
        courseId,
        nameForQuestions,
        nameForAnswers,
      ];
}

class GroupsEventUpdateGroup extends GroupsEvent {
  final String groupId;
  final String? name;
  final String? courseId;
  final String? nameForQuestions;
  final String? nameForAnswers;

  GroupsEventUpdateGroup({
    required this.groupId,
    this.name,
    this.courseId,
    this.nameForQuestions,
    this.nameForAnswers,
  });

  @override
  List<Object> get props => [
        groupId,
        name ?? '',
        courseId ?? '',
        nameForQuestions ?? '',
        nameForAnswers ?? ''
      ];
}

class GroupsEventRemoveGroup extends GroupsEvent {
  final String groupId;

  GroupsEventRemoveGroup({required this.groupId});

  @override
  List<Object> get props => [groupId];
}

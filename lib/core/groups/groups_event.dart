import 'package:equatable/equatable.dart';
import 'package:fiszkomaniak/models/group_model.dart';

abstract class GroupsEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class GroupsEventInitialize extends GroupsEvent {}

class GroupsEventGroupAdded extends GroupsEvent {
  final Group group;

  GroupsEventGroupAdded({required this.group});

  @override
  List<Object> get props => [group];
}

class GroupsEventGroupUpdated extends GroupsEvent {
  final Group group;

  GroupsEventGroupUpdated({required this.group});

  @override
  List<Object> get props => [group];
}

class GroupsEventGroupRemoved extends GroupsEvent {
  final String groupId;

  GroupsEventGroupRemoved({required this.groupId});

  @override
  List<Object> get props => [groupId];
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

class GroupsEventRemoveGroupsFromCourse extends GroupsEvent {
  final String courseId;

  GroupsEventRemoveGroupsFromCourse({required this.courseId});

  @override
  List<Object> get props => [courseId];
}

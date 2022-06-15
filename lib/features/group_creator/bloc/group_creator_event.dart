part of 'group_creator_bloc.dart';

abstract class GroupCreatorEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class GroupCreatorEventInitialize extends GroupCreatorEvent {
  final GroupCreatorMode mode;

  GroupCreatorEventInitialize({required this.mode});

  @override
  List<Object> get props => [mode];
}

class GroupCreatorEventCourseChanged extends GroupCreatorEvent {
  final Course course;

  GroupCreatorEventCourseChanged({required this.course});

  @override
  List<Object> get props => [course];
}

class GroupCreatorEventGroupNameChanged extends GroupCreatorEvent {
  final String groupName;

  GroupCreatorEventGroupNameChanged({required this.groupName});

  @override
  List<Object> get props => [groupName];
}

class GroupCreatorEventNameForQuestionsChanged extends GroupCreatorEvent {
  final String nameForQuestions;

  GroupCreatorEventNameForQuestionsChanged({required this.nameForQuestions});

  @override
  List<Object> get props => [nameForQuestions];
}

class GroupCreatorEventNameForAnswersChanged extends GroupCreatorEvent {
  final String nameForAnswers;

  GroupCreatorEventNameForAnswersChanged({required this.nameForAnswers});

  @override
  List<Object> get props => [nameForAnswers];
}

class GroupCreatorEventSubmit extends GroupCreatorEvent {}

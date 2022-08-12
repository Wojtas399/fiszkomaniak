part of 'group_creator_bloc.dart';

abstract class GroupCreatorEvent {}

class GroupCreatorEventInitialize extends GroupCreatorEvent {
  final GroupCreatorMode mode;

  GroupCreatorEventInitialize({required this.mode});
}

class GroupCreatorEventCourseChanged extends GroupCreatorEvent {
  final Course course;

  GroupCreatorEventCourseChanged({required this.course});
}

class GroupCreatorEventGroupNameChanged extends GroupCreatorEvent {
  final String groupName;

  GroupCreatorEventGroupNameChanged({required this.groupName});
}

class GroupCreatorEventNameForQuestionsChanged extends GroupCreatorEvent {
  final String nameForQuestions;

  GroupCreatorEventNameForQuestionsChanged({required this.nameForQuestions});
}

class GroupCreatorEventNameForAnswersChanged extends GroupCreatorEvent {
  final String nameForAnswers;

  GroupCreatorEventNameForAnswersChanged({required this.nameForAnswers});
}

class GroupCreatorEventSubmit extends GroupCreatorEvent {}

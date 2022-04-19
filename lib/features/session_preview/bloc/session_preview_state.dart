import 'package:equatable/equatable.dart';
import 'package:fiszkomaniak/models/session_model.dart';
import '../../../models/group_model.dart';

class SessionPreviewState extends Equatable {
  final Session? session;
  final Group? group;
  final String? courseName;

  String? get nameForQuestions => session?.areQuestionsAndAnswersSwapped == true
      ? group?.nameForAnswers
      : group?.nameForQuestions;

  String? get nameForAnswers => session?.areQuestionsAndAnswersSwapped == true
      ? group?.nameForQuestions
      : group?.nameForAnswers;

  const SessionPreviewState({
    this.session,
    this.group,
    this.courseName,
  });

  SessionPreviewState copyWith({
    Session? session,
    Group? group,
    String? courseName,
  }) {
    return SessionPreviewState(
      session: session ?? this.session,
      group: group ?? this.group,
      courseName: courseName ?? this.courseName,
    );
  }

  @override
  List<Object> get props => [
        session ?? createSession(),
        group ?? createGroup(),
        courseName ?? '',
      ];
}

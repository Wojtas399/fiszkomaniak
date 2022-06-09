import 'package:equatable/equatable.dart';

abstract class SessionPreviewMode extends Equatable {}

class SessionPreviewModeNormal extends SessionPreviewMode {
  final String sessionId;

  SessionPreviewModeNormal({required this.sessionId});

  @override
  List<Object> get props => [sessionId];

  SessionPreviewModeNormal copyWith({String? sessionId}) {
    return SessionPreviewModeNormal(sessionId: sessionId ?? this.sessionId);
  }
}

class SessionPreviewModeQuick extends SessionPreviewMode {
  final String groupId;

  SessionPreviewModeQuick({required this.groupId});

  @override
  List<Object> get props => [groupId];
}

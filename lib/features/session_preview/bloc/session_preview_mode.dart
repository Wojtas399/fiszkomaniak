import 'package:equatable/equatable.dart';

abstract class SessionPreviewMode extends Equatable {}

class SessionPreviewModeNormal extends SessionPreviewMode {
  final String sessionId;

  SessionPreviewModeNormal({required this.sessionId});

  @override
  List<Object> get props => [sessionId];
}

class SessionPreviewModeQuick extends SessionPreviewMode {
  final String groupId;

  SessionPreviewModeQuick({required this.groupId});

  @override
  List<Object> get props => [groupId];
}

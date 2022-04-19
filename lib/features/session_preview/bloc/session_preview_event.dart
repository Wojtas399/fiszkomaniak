abstract class SessionPreviewEvent {}

class SessionPreviewEventInitialize extends SessionPreviewEvent {
  final String sessionId;

  SessionPreviewEventInitialize({required this.sessionId});
}

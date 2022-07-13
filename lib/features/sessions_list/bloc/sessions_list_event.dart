part of 'sessions_list_bloc.dart';

abstract class SessionsListEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class SessionsListEventInitialize extends SessionsListEvent {}

class SessionsListEventSessionsItemsParamsUpdated extends SessionsListEvent {
  final List<SessionItemParams> sessionsItemsParams;

  SessionsListEventSessionsItemsParamsUpdated({
    required this.sessionsItemsParams,
  });

  @override
  List<Object> get props => [sessionsItemsParams];
}

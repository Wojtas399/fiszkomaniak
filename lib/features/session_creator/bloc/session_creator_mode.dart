import 'package:equatable/equatable.dart';
import 'package:fiszkomaniak/models/session_model.dart';

abstract class SessionCreatorMode extends Equatable {
  const SessionCreatorMode();

  @override
  List<Object> get props => [];
}

class SessionCreatorCreateMode extends SessionCreatorMode {
  const SessionCreatorCreateMode();
}

class SessionCreatorEditMode extends SessionCreatorMode {
  final Session session;

  const SessionCreatorEditMode({required this.session});

  @override
  List<Object> get props => [session];
}

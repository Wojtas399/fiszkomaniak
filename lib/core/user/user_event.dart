import 'package:equatable/equatable.dart';
import 'package:fiszkomaniak/models/user_model.dart';

abstract class UserEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class UserEventInitialize extends UserEvent {}

class UserEventLoggedUserUpdated extends UserEvent {
  final User updatedLoggedUser;

  UserEventLoggedUserUpdated({required this.updatedLoggedUser});

  @override
  List<Object> get props => [updatedLoggedUser];
}

class UserEventSaveNewRememberedFlashcards extends UserEvent {
  final String groupId;
  final List<int> rememberedFlashcardsIndexes;

  UserEventSaveNewRememberedFlashcards({
    required this.groupId,
    required this.rememberedFlashcardsIndexes,
  });

  @override
  List<Object> get props => [
        groupId,
        rememberedFlashcardsIndexes,
      ];
}

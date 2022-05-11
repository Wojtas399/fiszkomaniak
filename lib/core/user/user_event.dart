part of 'user_bloc.dart';

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

class UserEventSaveNewAvatar extends UserEvent {
  final String imageFullPath;

  UserEventSaveNewAvatar({required this.imageFullPath});

  @override
  List<Object> get props => [imageFullPath];
}

class UserEventRemoveAvatar extends UserEvent {}

class UserEventChangeUsername extends UserEvent {
  final String newUsername;

  UserEventChangeUsername({required this.newUsername});

  @override
  List<Object> get props => [newUsername];
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

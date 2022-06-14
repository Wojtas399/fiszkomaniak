part of 'profile_bloc.dart';

class ProfileState extends Equatable {
  final String loggedUserAvatarUrl;
  final User? loggedUserData;
  final int amountOfDaysInARow;
  final int amountOfAllFlashcards;

  const ProfileState({
    this.loggedUserAvatarUrl = '',
    this.loggedUserData,
    this.amountOfDaysInARow = 0,
    this.amountOfAllFlashcards = 0,
  });

  @override
  List<Object> get props => [
        loggedUserAvatarUrl,
        loggedUserData ?? '',
        amountOfDaysInARow,
        amountOfAllFlashcards,
      ];

  ProfileState copyWith({
    String? loggedUserAvatarUrl,
    User? loggedUserData,
    int? amountOfDaysInARow,
    int? amountOfAllFlashcards,
  }) {
    return ProfileState(
      loggedUserAvatarUrl: loggedUserAvatarUrl ?? this.loggedUserAvatarUrl,
      loggedUserData: loggedUserData ?? this.loggedUserData,
      amountOfDaysInARow: amountOfDaysInARow ?? this.amountOfDaysInARow,
      amountOfAllFlashcards:
          amountOfAllFlashcards ?? this.amountOfAllFlashcards,
    );
  }
}

enum AvatarActions {
  edit,
  delete,
}

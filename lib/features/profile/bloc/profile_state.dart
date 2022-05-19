part of 'profile_bloc.dart';

class ProfileState extends Equatable {
  final User? loggedUserData;
  final int amountOfDaysInARow;
  final int amountOfAllFlashcards;

  const ProfileState({
    this.loggedUserData,
    this.amountOfDaysInARow = 0,
    this.amountOfAllFlashcards = 0,
  });

  @override
  List<Object> get props => [
        loggedUserData ?? '',
        amountOfDaysInARow,
        amountOfAllFlashcards,
      ];

  ProfileState copyWith({
    User? loggedUserData,
    int? amountOfDaysInARow,
    int? amountOfAllFlashcards,
  }) {
    return ProfileState(
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

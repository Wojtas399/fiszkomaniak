part of 'profile_bloc.dart';

class ProfileState extends Equatable {
  final BlocStatus status;
  final User? user;
  final int amountOfDaysStreak;
  final int amountOfAllFlashcards;

  const ProfileState({
    required this.status,
    required this.user,
    required this.amountOfDaysStreak,
    required this.amountOfAllFlashcards,
  });

  @override
  List<Object> get props => [
        status,
        user ?? '',
        amountOfDaysStreak,
        amountOfAllFlashcards,
      ];

  String? get avatarUrl => user?.avatarUrl;

  ProfileState copyWith({
    BlocStatus? status,
    User? user,
    int? amountOfDaysStreak,
    int? amountOfAllFlashcards,
  }) {
    return ProfileState(
      status: status ?? const BlocStatusComplete(),
      user: user ?? this.user,
      amountOfDaysStreak: amountOfDaysStreak ?? this.amountOfDaysStreak,
      amountOfAllFlashcards:
          amountOfAllFlashcards ?? this.amountOfAllFlashcards,
    );
  }

  ProfileState copyWithInfoType(ProfileInfoType infoType) {
    return copyWith(
      status: BlocStatusComplete<ProfileInfoType>(info: infoType),
    );
  }

  ProfileState copyWithErrorType(ProfileErrorType errorType) {
    return copyWith(
      status: BlocStatusError<ProfileErrorType>(errorType: errorType),
    );
  }
}

enum ProfileInfoType {
  avatarHasBeenUpdated,
  avatarHasBeenDeleted,
  usernameHasBeenUpdated,
  passwordHasBeenUpdated,
  userHasBeenSignedOut,
  userAccountHasBeenDeleted,
}

enum ProfileErrorType {
  wrongPassword,
}

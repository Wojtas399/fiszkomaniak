part of 'profile_bloc.dart';

class ProfileState extends Equatable {
  final BlocStatus status;
  final User? user;
  final int daysStreak;
  final int amountOfAllFlashcards;

  const ProfileState({
    required this.status,
    required this.user,
    required this.daysStreak,
    required this.amountOfAllFlashcards,
  });

  @override
  List<Object> get props => [
        status,
        user ?? '',
        daysStreak,
        amountOfAllFlashcards,
      ];

  String? get avatarUrl => user?.avatarUrl;

  ProfileState copyWith({
    BlocStatus? status,
    User? user,
    int? daysStreak,
    int? amountOfAllFlashcards,
  }) {
    return ProfileState(
      status: status ?? const BlocStatusComplete(),
      user: user ?? this.user,
      daysStreak: daysStreak ?? this.daysStreak,
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

class ProfileStateListenedParams extends Equatable {
  final User? user;
  final int allFlashcardsAmount;
  final int daysStreak;

  const ProfileStateListenedParams({
    required this.user,
    required this.allFlashcardsAmount,
    required this.daysStreak,
  });

  @override
  List<Object> get props => [
        user ?? '',
        allFlashcardsAmount,
        daysStreak,
      ];
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

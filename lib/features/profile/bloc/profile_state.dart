part of 'profile_bloc.dart';

class ProfileState extends Equatable {
  final BlocStatus status;
  final User? user;
  final int daysStreak;
  final int amountOfRememberedFlashcards;

  const ProfileState({
    required this.status,
    required this.user,
    required this.daysStreak,
    required this.amountOfRememberedFlashcards,
  });

  @override
  List<Object> get props => [
        status,
        user ?? '',
        daysStreak,
        amountOfRememberedFlashcards,
      ];

  String? get avatarUrl => user?.avatarUrl;

  ProfileState copyWith({
    BlocStatus? status,
    User? user,
    int? daysStreak,
    int? amountOfRememberedFlashcards,
  }) {
    return ProfileState(
      status: status ?? const BlocStatusInProgress(),
      user: user ?? this.user,
      daysStreak: daysStreak ?? this.daysStreak,
      amountOfRememberedFlashcards:
          amountOfRememberedFlashcards ?? this.amountOfRememberedFlashcards,
    );
  }

  ProfileState copyWithInfo(ProfileInfo info) {
    return copyWith(
      status: BlocStatusComplete<ProfileInfo>(info: info),
    );
  }

  ProfileState copyWithError(ProfileError error) {
    return copyWith(
      status: BlocStatusError<ProfileError>(error: error),
    );
  }
}

class ProfileStateListenedParams extends Equatable {
  final User? user;
  final int amountOfRememberedFlashcards;
  final int daysStreak;

  const ProfileStateListenedParams({
    required this.user,
    required this.amountOfRememberedFlashcards,
    required this.daysStreak,
  });

  @override
  List<Object> get props => [
        user ?? '',
        amountOfRememberedFlashcards,
        daysStreak,
      ];
}

enum ProfileInfo {
  avatarHasBeenUpdated,
  avatarHasBeenDeleted,
  usernameHasBeenUpdated,
  passwordHasBeenUpdated,
  userHasBeenSignedOut,
  userAccountHasBeenDeleted,
}

enum ProfileError {
  wrongPassword,
}

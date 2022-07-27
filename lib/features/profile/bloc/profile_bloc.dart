import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/user.dart';
import '../../../domain/use_cases/auth/sign_out_use_case.dart';
import '../../../domain/use_cases/auth/update_password_use_case.dart';
import '../../../domain/use_cases/user/get_user_use_case.dart';
import '../../../domain/use_cases/auth/delete_logged_user_account_use_case.dart';
import '../../../domain/use_cases/user/delete_avatar_use_case.dart';
import '../../../domain/use_cases/user/update_avatar_use_case.dart';
import '../../../domain/use_cases/user/update_user_username_use_case.dart';
import '../../../exceptions/auth_exceptions.dart';
import '../../../features/profile/profile_dialogs.dart';
import '../../../models/bloc_status.dart';

part 'profile_event.dart';

part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  late final UpdateUserUsernameUseCase _updateUserUsernameUseCase;
  late final UpdatePasswordUseCase _updatePasswordUseCase;
  late final SignOutUseCase _signOutUseCase;
  late final DeleteLoggedUserAccountUseCase _deleteLoggedUserAccountUseCase;
  late final GetUserUseCase _getUserUseCase;
  late final UpdateAvatarUseCase _updateAvatarUseCase;
  late final DeleteAvatarUseCase _deleteAvatarUseCase;

  // late final AchievementsBloc _achievementsBloc;
  late final ProfileDialogs _profileDialogs;
  StreamSubscription<User?>? _userListener;

  // StreamSubscription<AchievementsState>? _achievementsStateListener;

  ProfileBloc({
    required UpdateUserUsernameUseCase updateUserUsernameUseCase,
    required UpdatePasswordUseCase updatePasswordUseCase,
    required SignOutUseCase signOutUseCase,
    required DeleteLoggedUserAccountUseCase deleteLoggedUserAccountUseCase,
    required GetUserUseCase getUserUseCase,
    required UpdateAvatarUseCase updateAvatarUseCase,
    required DeleteAvatarUseCase deleteAvatarUseCase,
    // required AchievementsBloc achievementsBloc,
    required ProfileDialogs profileDialogs,
    BlocStatus status = const BlocStatusInitial(),
    User? user,
    int amountOfDaysStreak = 0,
    int amountOfAllFlashcards = 0,
  }) : super(
          ProfileState(
            status: status,
            user: user,
            amountOfDaysStreak: amountOfDaysStreak,
            amountOfAllFlashcards: amountOfAllFlashcards,
          ),
        ) {
    _updateUserUsernameUseCase = updateUserUsernameUseCase;
    _updatePasswordUseCase = updatePasswordUseCase;
    _signOutUseCase = signOutUseCase;
    _deleteLoggedUserAccountUseCase = deleteLoggedUserAccountUseCase;
    _getUserUseCase = getUserUseCase;
    _updateAvatarUseCase = updateAvatarUseCase;
    _deleteAvatarUseCase = deleteAvatarUseCase;
    // _achievementsBloc = achievementsBloc;
    _profileDialogs = profileDialogs;
    on<ProfileEventInitialize>(_initialize);
    on<ProfileEventUserChanged>(_userChanged);
    on<ProfileEventAchievementsStateUpdated>(_achievementsStateUpdated);
    on<ProfileEventChangeAvatar>(_changeAvatar);
    on<ProfileEventDeleteAvatar>(_deleteAvatar);
    on<ProfileEventChangeUsername>(_changeUsername);
    on<ProfileEventChangePassword>(_changePassword);
    on<ProfileEventSignOut>(_signOut);
    on<ProfileEventDeleteAccount>(_deleteAccount);
  }

  @override
  Future<void> close() {
    _userListener?.cancel();
    // _achievementsStateListener?.cancel();
    return super.close();
  }

  void _initialize(
    ProfileEventInitialize event,
    Emitter<ProfileState> emit,
  ) {
    // emit(state.copyWith(
    //   amountOfDaysStreak: _achievementsBloc.state.daysStreak,
    //   amountOfAllFlashcards: _achievementsBloc.state.allFlashcardsAmount,
    // ));
    _setUserListener();
    // _setAchievementsStateListener();
  }

  void _userChanged(
    ProfileEventUserChanged event,
    Emitter<ProfileState> emit,
  ) {
    emit(state.copyWith(
      user: event.user,
    ));
  }

  void _achievementsStateUpdated(
    ProfileEventAchievementsStateUpdated event,
    Emitter<ProfileState> emit,
  ) {
    // emit(state.copyWith(
    //   amountOfDaysStreak: event.daysStreak,
    //   amountOfAllFlashcards: event.allFlashcardsAmount,
    // ));
  }

  Future<void> _changeAvatar(
    ProfileEventChangeAvatar event,
    Emitter<ProfileState> emit,
  ) async {
    if (await _hasNewAvatarBeenConfirmed(event.imagePath)) {
      emit(state.copyWith(
        status: const BlocStatusLoading(),
      ));
      await _updateAvatarUseCase.execute(imagePath: event.imagePath);
      emit(state.copyWithInfoType(
        ProfileInfoType.avatarHasBeenUpdated,
      ));
    }
  }

  Future<void> _deleteAvatar(
    ProfileEventDeleteAvatar event,
    Emitter<ProfileState> emit,
  ) async {
    if (await _hasAvatarDeletionBeenConfirmed()) {
      emit(state.copyWith(
        status: const BlocStatusLoading(),
      ));
      await _deleteAvatarUseCase.execute();
      emit(state.copyWithInfoType(
        ProfileInfoType.avatarHasBeenDeleted,
      ));
    }
  }

  Future<void> _changeUsername(
    ProfileEventChangeUsername event,
    Emitter<ProfileState> emit,
  ) async {
    emit(state.copyWith(
      status: const BlocStatusLoading(),
    ));
    await _updateUserUsernameUseCase.execute(username: event.newUsername);
    emit(state.copyWithInfoType(
      ProfileInfoType.usernameHasBeenUpdated,
    ));
  }

  Future<void> _changePassword(
    ProfileEventChangePassword event,
    Emitter<ProfileState> emit,
  ) async {
    try {
      emit(state.copyWith(
        status: const BlocStatusLoading(),
      ));
      await _updatePasswordUseCase.execute(
        currentPassword: event.currentPassword,
        newPassword: event.newPassword,
      );
      emit(state.copyWithInfoType(
        ProfileInfoType.passwordHasBeenUpdated,
      ));
    } on AuthException catch (exception) {
      if (exception == AuthException.wrongPassword) {
        emit(state.copyWithErrorType(
          ProfileErrorType.wrongPassword,
        ));
      }
    }
  }

  Future<void> _signOut(
    ProfileEventSignOut event,
    Emitter<ProfileState> emit,
  ) async {
    if (await _hasSignOutBeenConfirmed()) {
      emit(state.copyWith(
        status: const BlocStatusLoading(),
      ));
      await _signOutUseCase.execute();
      emit(state.copyWithInfoType(
        ProfileInfoType.userHasBeenSignedOut,
      ));
    }
  }

  Future<void> _deleteAccount(
    ProfileEventDeleteAccount event,
    Emitter<ProfileState> emit,
  ) async {
    final String? password =
        await _profileDialogs.askForAccountDeletionConfirmationPassword();
    if (password != null) {
      try {
        emit(state.copyWith(
          status: const BlocStatusLoading(),
        ));
        await _deleteLoggedUserAccountUseCase.execute(password: password);
        emit(state.copyWithInfoType(
          ProfileInfoType.userAccountHasBeenDeleted,
        ));
      } on AuthException catch (exception) {
        if (exception == AuthException.wrongPassword) {
          emit(state.copyWithErrorType(
            ProfileErrorType.wrongPassword,
          ));
        }
      }
    }
  }

  void _setUserListener() {
    _userListener ??= _getUserUseCase.execute().listen(
      (user) {
        if (user != null) {
          add(ProfileEventUserChanged(user: user));
        }
      },
    );
  }

  void _setAchievementsStateListener() {
    // _achievementsStateListener ??= _achievementsBloc.stream.listen((state) {
    //   add(ProfileEventAchievementsStateUpdated(
    //     daysStreak: state.daysStreak,
    //     allFlashcardsAmount: state.allFlashcardsAmount,
    //   ));
    // });
  }

  Future<bool> _hasNewAvatarBeenConfirmed(String imgPath) async {
    return await _profileDialogs.askForNewAvatarConfirmation(imgPath);
  }

  Future<bool> _hasAvatarDeletionBeenConfirmed() async {
    return await _profileDialogs.askForAvatarDeletionConfirmation();
  }

  Future<bool> _hasSignOutBeenConfirmed() async {
    return await _profileDialogs.askForSignOutConfirmation();
  }
}

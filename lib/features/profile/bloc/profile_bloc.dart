import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';
import '../../../domain/entities/user.dart';
import '../../../domain/use_cases/achievements/get_all_flashcards_amount_use_case.dart';
import '../../../domain/use_cases/achievements/load_all_flashcards_amount_use_case.dart';
import '../../../domain/use_cases/auth/sign_out_use_case.dart';
import '../../../domain/use_cases/auth/update_password_use_case.dart';
import '../../../domain/use_cases/user/get_user_use_case.dart';
import '../../../domain/use_cases/auth/delete_logged_user_account_use_case.dart';
import '../../../domain/use_cases/user/delete_avatar_use_case.dart';
import '../../../domain/use_cases/user/get_days_streak_use_case.dart';
import '../../../domain/use_cases/user/update_avatar_use_case.dart';
import '../../../domain/use_cases/user/update_user_username_use_case.dart';
import '../../../exceptions/auth_exceptions.dart';
import '../../../features/profile/profile_dialogs.dart';
import '../../../models/bloc_status.dart';

part 'profile_event.dart';

part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  late final LoadAllFlashcardsAmountUseCase _loadAllFlashcardsAmountUseCase;
  late final GetUserUseCase _getUserUseCase;
  late final GetAllFlashcardsAmountUseCase _getAllFlashcardsAmountUseCase;
  late final GetDaysStreakUseCase _getDaysStreakUseCase;
  late final UpdateUserUsernameUseCase _updateUserUsernameUseCase;
  late final UpdatePasswordUseCase _updatePasswordUseCase;
  late final UpdateAvatarUseCase _updateAvatarUseCase;
  late final SignOutUseCase _signOutUseCase;
  late final DeleteLoggedUserAccountUseCase _deleteLoggedUserAccountUseCase;
  late final DeleteAvatarUseCase _deleteAvatarUseCase;
  late final ProfileDialogs _profileDialogs;
  StreamSubscription<ProfileStateListenedParams>? _paramsListener;

  ProfileBloc({
    required LoadAllFlashcardsAmountUseCase loadAllFlashcardsAmountUseCase,
    required GetUserUseCase getUserUseCase,
    required GetAllFlashcardsAmountUseCase getAllFlashcardsAmountUseCase,
    required GetDaysStreakUseCase getDaysStreakUseCase,
    required UpdateUserUsernameUseCase updateUserUsernameUseCase,
    required UpdatePasswordUseCase updatePasswordUseCase,
    required UpdateAvatarUseCase updateAvatarUseCase,
    required SignOutUseCase signOutUseCase,
    required DeleteLoggedUserAccountUseCase deleteLoggedUserAccountUseCase,
    required DeleteAvatarUseCase deleteAvatarUseCase,
    required ProfileDialogs profileDialogs,
    BlocStatus status = const BlocStatusInitial(),
    User? user,
    int daysStreak = 0,
    int amountOfAllFlashcards = 0,
  }) : super(
          ProfileState(
            status: status,
            user: user,
            daysStreak: daysStreak,
            amountOfAllFlashcards: amountOfAllFlashcards,
          ),
        ) {
    _loadAllFlashcardsAmountUseCase = loadAllFlashcardsAmountUseCase;
    _getUserUseCase = getUserUseCase;
    _getAllFlashcardsAmountUseCase = getAllFlashcardsAmountUseCase;
    _getDaysStreakUseCase = getDaysStreakUseCase;
    _updateUserUsernameUseCase = updateUserUsernameUseCase;
    _updatePasswordUseCase = updatePasswordUseCase;
    _updateAvatarUseCase = updateAvatarUseCase;
    _signOutUseCase = signOutUseCase;
    _deleteLoggedUserAccountUseCase = deleteLoggedUserAccountUseCase;
    _deleteAvatarUseCase = deleteAvatarUseCase;
    _profileDialogs = profileDialogs;
    on<ProfileEventInitialize>(_initialize);
    on<ProfileEventListenedParamsUpdated>(_listenedParamsUpdated);
    on<ProfileEventChangeAvatar>(_changeAvatar);
    on<ProfileEventDeleteAvatar>(_deleteAvatar);
    on<ProfileEventChangeUsername>(_changeUsername);
    on<ProfileEventChangePassword>(_changePassword);
    on<ProfileEventSignOut>(_signOut);
    on<ProfileEventDeleteAccount>(_deleteAccount);
  }

  @override
  Future<void> close() {
    _paramsListener?.cancel();
    return super.close();
  }

  Future<void> _initialize(
    ProfileEventInitialize event,
    Emitter<ProfileState> emit,
  ) async {
    await _loadAllFlashcardsAmountUseCase.execute();
    _setParamsListener();
  }

  void _listenedParamsUpdated(
    ProfileEventListenedParamsUpdated event,
    Emitter<ProfileState> emit,
  ) {
    emit(state.copyWith(
      user: event.params.user,
      daysStreak: event.params.daysStreak,
      amountOfAllFlashcards: event.params.allFlashcardsAmount,
    ));
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

  void _setParamsListener() {
    _paramsListener ??= Rx.combineLatest3(
      _getUserUseCase.execute(),
      _getAllFlashcardsAmountUseCase.execute(),
      _getDaysStreakUseCase.execute(),
      (
        User? user,
        int allFlashcardsAmount,
        int daysStreak,
      ) =>
          ProfileStateListenedParams(
        user: user,
        allFlashcardsAmount: allFlashcardsAmount,
        daysStreak: daysStreak,
      ),
    ).listen(
      (params) => add(ProfileEventListenedParamsUpdated(params: params)),
    );
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

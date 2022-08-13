import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';
import '../../../domain/entities/user.dart';
import '../../../domain/use_cases/achievements/get_remembered_flashcards_amount_use_case.dart';
import '../../../domain/use_cases/achievements/load_remembered_flashcards_amount_use_case.dart';
import '../../../domain/use_cases/auth/sign_out_use_case.dart';
import '../../../domain/use_cases/auth/update_password_use_case.dart';
import '../../../domain/use_cases/user/get_user_use_case.dart';
import '../../../domain/use_cases/auth/delete_logged_user_account_use_case.dart';
import '../../../domain/use_cases/user/delete_avatar_use_case.dart';
import '../../../domain/use_cases/user/get_days_streak_use_case.dart';
import '../../../domain/use_cases/user/update_avatar_use_case.dart';
import '../../../domain/use_cases/user/update_user_username_use_case.dart';
import '../../../exceptions/auth_exceptions.dart';
import '../../../models/bloc_status.dart';

part 'profile_event.dart';

part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  late final LoadRememberedFlashcardsAmountUseCase
      _loadRememberedFlashcardsAmountUseCase;
  late final GetUserUseCase _getUserUseCase;
  late final GetRememberedFlashcardsAmountUseCase
      _getRememberedFlashcardsAmountUseCase;
  late final GetDaysStreakUseCase _getDaysStreakUseCase;
  late final UpdateUserUsernameUseCase _updateUserUsernameUseCase;
  late final UpdatePasswordUseCase _updatePasswordUseCase;
  late final UpdateAvatarUseCase _updateAvatarUseCase;
  late final SignOutUseCase _signOutUseCase;
  late final DeleteLoggedUserAccountUseCase _deleteLoggedUserAccountUseCase;
  late final DeleteAvatarUseCase _deleteAvatarUseCase;
  StreamSubscription<ProfileStateListenedParams>? _paramsListener;

  ProfileBloc({
    required LoadRememberedFlashcardsAmountUseCase
        loadRememberedFlashcardsAmountUseCase,
    required GetUserUseCase getUserUseCase,
    required GetRememberedFlashcardsAmountUseCase
        getRememberedFlashcardsAmountUseCase,
    required GetDaysStreakUseCase getDaysStreakUseCase,
    required UpdateUserUsernameUseCase updateUserUsernameUseCase,
    required UpdatePasswordUseCase updatePasswordUseCase,
    required UpdateAvatarUseCase updateAvatarUseCase,
    required SignOutUseCase signOutUseCase,
    required DeleteLoggedUserAccountUseCase deleteLoggedUserAccountUseCase,
    required DeleteAvatarUseCase deleteAvatarUseCase,
    BlocStatus status = const BlocStatusInitial(),
    User? user,
    int daysStreak = 0,
    int amountOfRememberedFlashcards = 0,
  }) : super(
          ProfileState(
            status: status,
            user: user,
            daysStreak: daysStreak,
            amountOfRememberedFlashcards: amountOfRememberedFlashcards,
          ),
        ) {
    _loadRememberedFlashcardsAmountUseCase =
        loadRememberedFlashcardsAmountUseCase;
    _getUserUseCase = getUserUseCase;
    _getRememberedFlashcardsAmountUseCase =
        getRememberedFlashcardsAmountUseCase;
    _getDaysStreakUseCase = getDaysStreakUseCase;
    _updateUserUsernameUseCase = updateUserUsernameUseCase;
    _updatePasswordUseCase = updatePasswordUseCase;
    _updateAvatarUseCase = updateAvatarUseCase;
    _signOutUseCase = signOutUseCase;
    _deleteLoggedUserAccountUseCase = deleteLoggedUserAccountUseCase;
    _deleteAvatarUseCase = deleteAvatarUseCase;
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
    await _loadRememberedFlashcardsAmountUseCase.execute();
    _setParamsListener();
  }

  void _listenedParamsUpdated(
    ProfileEventListenedParamsUpdated event,
    Emitter<ProfileState> emit,
  ) {
    emit(state.copyWith(
      user: event.params.user,
      daysStreak: event.params.daysStreak,
      amountOfRememberedFlashcards: event.params.amountOfRememberedFlashcards,
    ));
  }

  Future<void> _changeAvatar(
    ProfileEventChangeAvatar event,
    Emitter<ProfileState> emit,
  ) async {
    emit(state.copyWith(
      status: const BlocStatusLoading(),
    ));
    await _updateAvatarUseCase.execute(imagePath: event.imagePath);
    emit(state.copyWithInfo(
      ProfileInfo.avatarHasBeenUpdated,
    ));
  }

  Future<void> _deleteAvatar(
    ProfileEventDeleteAvatar event,
    Emitter<ProfileState> emit,
  ) async {
    emit(state.copyWith(
      status: const BlocStatusLoading(),
    ));
    await _deleteAvatarUseCase.execute();
    emit(state.copyWithInfo(
      ProfileInfo.avatarHasBeenDeleted,
    ));
  }

  Future<void> _changeUsername(
    ProfileEventChangeUsername event,
    Emitter<ProfileState> emit,
  ) async {
    emit(state.copyWith(
      status: const BlocStatusLoading(),
    ));
    await _updateUserUsernameUseCase.execute(username: event.newUsername);
    emit(state.copyWithInfo(
      ProfileInfo.usernameHasBeenUpdated,
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
      emit(state.copyWithInfo(
        ProfileInfo.passwordHasBeenUpdated,
      ));
    } on AuthException catch (exception) {
      if (exception == AuthException.wrongPassword) {
        emit(state.copyWithError(
          ProfileError.wrongPassword,
        ));
      }
    }
  }

  Future<void> _signOut(
    ProfileEventSignOut event,
    Emitter<ProfileState> emit,
  ) async {
    emit(state.copyWith(
      status: const BlocStatusLoading(),
    ));
    await _signOutUseCase.execute();
    emit(state.copyWithInfo(
      ProfileInfo.userHasBeenSignedOut,
    ));
  }

  Future<void> _deleteAccount(
    ProfileEventDeleteAccount event,
    Emitter<ProfileState> emit,
  ) async {
    try {
      emit(state.copyWith(
        status: const BlocStatusLoading(),
      ));
      await _deleteLoggedUserAccountUseCase.execute(
        password: event.password,
      );
      emit(state.copyWithInfo(
        ProfileInfo.userAccountHasBeenDeleted,
      ));
    } on AuthException catch (exception) {
      if (exception == AuthException.wrongPassword) {
        emit(state.copyWithError(
          ProfileError.wrongPassword,
        ));
      }
    }
  }

  void _setParamsListener() {
    _paramsListener ??= Rx.combineLatest3(
      _getUserUseCase.execute(),
      _getRememberedFlashcardsAmountUseCase.execute(),
      _getDaysStreakUseCase.execute(),
      (
        User? user,
        int amountOfRememberedFlashcards,
        int daysStreak,
      ) =>
          ProfileStateListenedParams(
        user: user,
        amountOfRememberedFlashcards: amountOfRememberedFlashcards,
        daysStreak: daysStreak,
      ),
    ).listen(
      (params) => add(ProfileEventListenedParamsUpdated(params: params)),
    );
  }
}

import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:fiszkomaniak/core/achievements/achievements_bloc.dart';
import 'package:fiszkomaniak/features/profile/components/password_editor/bloc/password_editor_bloc.dart';
import 'package:fiszkomaniak/features/profile/profile_dialogs.dart';
import 'package:fiszkomaniak/interfaces/user_interface.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/auth/auth_bloc.dart';
import '../../../models/user_model.dart';

part 'profile_event.dart';

part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  late final UserInterface _userInterface;
  late final AuthBloc _authBloc;
  late final AchievementsBloc _achievementsBloc;
  late final ProfileDialogs _profileDialogs;
  late final ImagePicker _imagePicker;
  StreamSubscription<String>? _loggedUserAvatarUrlListener;
  StreamSubscription<User>? _loggedUserDataListener;
  StreamSubscription<AchievementsState>? _achievementsStateListener;

  ProfileBloc({
    required UserInterface userInterface,
    required AuthBloc authBloc,
    required AchievementsBloc achievementsBloc,
    required ProfileDialogs profileDialogs,
    required ImagePicker imagePicker,
  }) : super(const ProfileState()) {
    _userInterface = userInterface;
    _achievementsBloc = achievementsBloc;
    _profileDialogs = profileDialogs;
    _imagePicker = imagePicker;
    on<ProfileEventInitialize>(_initialize);
    on<ProfileEventLoggedUserAvatarUrlChanged>(_loggedUserAvatarUrlChanged);
    on<ProfileEventLoggedUserDataChanged>(_loggedUserDataChanged);
    on<ProfileEventAchievementsStateUpdated>(_achievementsStateUpdated);
    on<ProfileEventModifyAvatar>(_modifyAvatar);
    on<ProfileEventChangeUsername>(_changeUsername);
    on<ProfileEventChangePassword>(_changePassword);
    on<ProfileEventSignOut>(_signOut);
    on<ProfileEventRemoveAccount>(_removeAccount);
  }

  @override
  Future<void> close() {
    _loggedUserAvatarUrlListener?.cancel();
    _loggedUserDataListener?.cancel();
    _achievementsStateListener?.cancel();
    return super.close();
  }

  void _initialize(
    ProfileEventInitialize event,
    Emitter<ProfileState> emit,
  ) {
    _setLoggedUserAvatarUrlListener();
    _setLoggedUserDataListener();
    _userInterface.loadLoggedUserAvatar();
    _userInterface.loadLoggedUserData();
    emit(state.copyWith(
      amountOfDaysInARow: _achievementsBloc.state.daysStreak,
      amountOfAllFlashcards: _achievementsBloc.state.allFlashcardsAmount,
    ));
    _setAchievementsStateListener();
  }

  void _loggedUserAvatarUrlChanged(
    ProfileEventLoggedUserAvatarUrlChanged event,
    Emitter<ProfileState> emit,
  ) {
    emit(state.copyWith(
      loggedUserAvatarUrl: event.newLoggedUserAvatarUrl,
    ));
  }

  void _loggedUserDataChanged(
    ProfileEventLoggedUserDataChanged event,
    Emitter<ProfileState> emit,
  ) {
    emit(state.copyWith(
      loggedUserData: event.newLoggedUserData,
    ));
  }

  void _achievementsStateUpdated(
    ProfileEventAchievementsStateUpdated event,
    Emitter<ProfileState> emit,
  ) {
    emit(state.copyWith(
      amountOfDaysInARow: event.daysStreak,
      amountOfAllFlashcards: event.allFlashcardsAmount,
    ));
  }

  Future<void> _modifyAvatar(
    ProfileEventModifyAvatar event,
    Emitter<ProfileState> emit,
  ) async {
    if (state.loggedUserAvatarUrl != '') {
      await _editAvatar();
    } else {
      final AvatarActions? action = await _profileDialogs.askForAvatarAction();
      if (action == AvatarActions.edit) {
        await _editAvatar();
      } else if (action == AvatarActions.delete) {
        await _deleteAvatar();
      }
    }
  }

  Future<void> _changeUsername(
    ProfileEventChangeUsername event,
    Emitter<ProfileState> emit,
  ) async {
    final String? currentUsername = state.loggedUserData?.username;
    if (currentUsername != null) {
      final String? newUsername = await _profileDialogs.askForNewUsername(
        currentUsername,
      );
      if (newUsername != null) {
        _userInterface.saveNewUsername(newUsername: newUsername);
      }
    }
  }

  Future<void> _changePassword(
    ProfileEventChangePassword event,
    Emitter<ProfileState> emit,
  ) async {
    final PasswordEditorReturns? passwordEditorReturnedValues =
        await _profileDialogs.askForNewPassword();
    if (passwordEditorReturnedValues != null) {
      _authBloc.add(AuthEventChangePassword(
        currentPassword: passwordEditorReturnedValues.currentPassword,
        newPassword: passwordEditorReturnedValues.newPassword,
      ));
    }
  }

  Future<void> _signOut(
    ProfileEventSignOut event,
    Emitter<ProfileState> emit,
  ) async {
    final bool confirmation = await _profileDialogs.askForSignOutConfirmation();
    if (confirmation) {
      _authBloc.add(AuthEventSignOut());
    }
  }

  Future<void> _removeAccount(
    ProfileEventRemoveAccount event,
    Emitter<ProfileState> emit,
  ) async {
    final String? password =
        await _profileDialogs.askForRemoveAccountConfirmationPassword();
    if (password != null) {
      _authBloc.add(AuthEventRemoveLoggedUser(password: password));
    }
  }

  void _setLoggedUserAvatarUrlListener() {
    _loggedUserAvatarUrlListener = _userInterface.loggedUserAvatarUrl$.listen(
      (avatarUrl) => add(
        ProfileEventLoggedUserAvatarUrlChanged(
          newLoggedUserAvatarUrl: avatarUrl,
        ),
      ),
    );
  }

  void _setLoggedUserDataListener() {
    _loggedUserDataListener = _userInterface.loggedUserData$.listen(
      (userData) => add(
        ProfileEventLoggedUserDataChanged(newLoggedUserData: userData),
      ),
    );
  }

  void _setAchievementsStateListener() {
    _achievementsStateListener ??= _achievementsBloc.stream.listen((state) {
      add(ProfileEventAchievementsStateUpdated(
        daysStreak: state.daysStreak,
        allFlashcardsAmount: state.allFlashcardsAmount,
      ));
    });
  }

  Future<void> _editAvatar() async {
    final ImageSource? imageSource = await _profileDialogs.askForImageSource();
    if (imageSource != null) {
      final XFile? image = await _imagePicker.pickImage(source: imageSource);
      if (image != null) {
        final bool confirmation = await _profileDialogs.askForImageConfirmation(
          image.path,
        );
        if (confirmation) {
          _userInterface.saveNewAvatar(fullPath: image.path);
        }
      }
    }
  }

  Future<void> _deleteAvatar() async {
    final bool confirmation =
        await _profileDialogs.askForDeleteAvatarConfirmation();
    if (confirmation) {
      _userInterface.removeAvatar();
    }
  }
}

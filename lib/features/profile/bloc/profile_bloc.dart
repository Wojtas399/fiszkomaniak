import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fiszkomaniak/core/user/user_bloc.dart';
import 'package:fiszkomaniak/features/profile/profile_dialogs.dart';
import 'package:image_picker/image_picker.dart';
import '../../../models/user_model.dart';

part 'profile_event.dart';

part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  late final UserBloc _userBloc;
  late final ProfileDialogs _profileDialogs;
  late final ImagePicker _imagePicker;
  StreamSubscription<UserState>? _userStateSubscription;

  ProfileBloc({
    required UserBloc userBloc,
    required ProfileDialogs profileDialogs,
    required ImagePicker imagePicker,
  }) : super(const ProfileState()) {
    _userBloc = userBloc;
    _profileDialogs = profileDialogs;
    _imagePicker = imagePicker;
    on<ProfileEventInitialize>(_initialize);
    on<ProfileEventUserUpdated>(_userUpdated);
    on<ProfileEventAvatarPressed>(_avatarPressed);
  }

  @override
  Future<void> close() {
    _userStateSubscription?.cancel();
    return super.close();
  }

  void _initialize(
    ProfileEventInitialize event,
    Emitter<ProfileState> emit,
  ) {
    emit(state.copyWith(userData: _userBloc.state.loggedUser));
    _userStateSubscription = _userBloc.stream.listen((state) {
      add(ProfileEventUserUpdated(newUserData: state.loggedUser));
    });
  }

  void _userUpdated(
    ProfileEventUserUpdated event,
    Emitter<ProfileState> emit,
  ) {
    emit(state.copyWith(
      userData: event.newUserData,
    ));
  }

  Future<void> _avatarPressed(
    ProfileEventAvatarPressed event,
    Emitter<ProfileState> emit,
  ) async {
    if (state.userData?.avatarUrl == null) {
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

  Future<void> _editAvatar() async {
    final ImageSource? imageSource = await _profileDialogs.askForImageSource();
    if (imageSource != null) {
      final XFile? image = await _imagePicker.pickImage(source: imageSource);
      if (image != null) {
        final bool confirmation = await _profileDialogs.askForImageConfirmation(
          image.path,
        );
        if (confirmation) {
          _userBloc.add(UserEventSaveNewAvatar(imageFullPath: image.path));
        }
      }
    }
  }

  Future<void> _deleteAvatar() async {
    final bool confirmation =
        await _profileDialogs.askForDeleteAvatarConfirmation();
    if (confirmation) {
      _userBloc.add(UserEventRemoveAvatar());
    }
  }
}

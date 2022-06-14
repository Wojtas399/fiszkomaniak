import 'package:fiszkomaniak/components/avatar/avatar_image_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../components/avatar/avatar.dart';
import '../bloc/profile_bloc.dart';

class ProfileAvatar extends StatelessWidget {
  const ProfileAvatar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String? avatarUrl = context.select(
      (ProfileBloc bloc) => bloc.state.loggedUserAvatarUrl,
    );
    return Avatar(
      imageType: avatarUrl != null && avatarUrl != ''
          ? AvatarImageTypeUrl(url: avatarUrl)
          : null,
      size: 250.0,
      onPressed: () => _avatarPressed(context),
    );
  }

  void _avatarPressed(BuildContext context) {
    context.read<ProfileBloc>().add(ProfileEventModifyAvatar());
  }
}

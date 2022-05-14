import 'package:fiszkomaniak/components/bouncing_scroll.dart';
import 'package:fiszkomaniak/core/auth/auth_bloc.dart';
import 'package:fiszkomaniak/core/user/user_bloc.dart';
import 'package:fiszkomaniak/features/profile/bloc/profile_bloc.dart';
import 'package:fiszkomaniak/features/profile/components/profile_avatar.dart';
import 'package:fiszkomaniak/features/profile/components/profile_user_data.dart';
import 'package:fiszkomaniak/features/profile/profile_dialogs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _ProfileBlocProvider(
      child: BouncingScroll(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: const [
              ProfileAvatar(),
              SizedBox(height: 24.0),
              ProfileUserData(),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProfileBlocProvider extends StatelessWidget {
  final Widget child;

  const _ProfileBlocProvider({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProfileBloc(
        userBloc: context.read<UserBloc>(),
        authBloc: context.read<AuthBloc>(),
        profileDialogs: ProfileDialogs(),
        imagePicker: ImagePicker(),
      )..add(ProfileEventInitialize()),
      child: child,
    );
  }
}

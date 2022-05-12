import 'package:fiszkomaniak/components/item_with_icon.dart';
import 'package:fiszkomaniak/components/section.dart';
import 'package:fiszkomaniak/features/profile/bloc/profile_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class ProfileUserData extends StatelessWidget {
  const ProfileUserData({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Section(
      title: 'Dane',
      displayDividerAtTheBottom: true,
      child: Column(
        children: const [
          _Username(),
          _Email(),
          _ChangePassword(),
        ],
      ),
    );
  }
}

class _Username extends StatelessWidget {
  const _Username({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String? username = context.select(
      (ProfileBloc bloc) => bloc.state.loggedUserData?.username,
    );
    return ItemWithIcon(
      icon: MdiIcons.accountOutline,
      text: username ?? '--',
      onTap: () => _onPressed(context),
    );
  }

  void _onPressed(BuildContext context) {
    context.read<ProfileBloc>().add(ProfileEventChangeUsername());
  }
}

class _Email extends StatelessWidget {
  const _Email({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String? email = context.select(
      (ProfileBloc bloc) => bloc.state.loggedUserData?.email,
    );
    return ItemWithIcon(
      icon: MdiIcons.emailOutline,
      text: email ?? '--',
    );
  }
}

class _ChangePassword extends StatelessWidget {
  const _ChangePassword({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ItemWithIcon(
      icon: MdiIcons.lockOutline,
      text: 'Zmień hasło',
      onTap: () => _onPressed(context),
    );
  }

  void _onPressed(BuildContext context) {
    context.read<ProfileBloc>().add(ProfileEventChangePassword());
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../../../components/item_with_icon.dart';
import '../../../components/section.dart';
import '../../../features/profile/bloc/profile_bloc.dart';
import 'profile_username.dart';
import 'profile_password.dart';

class ProfileUserData extends StatelessWidget {
  const ProfileUserData({super.key});

  @override
  Widget build(BuildContext context) {
    return Section(
      title: 'Dane',
      displayDividerAtTheBottom: true,
      child: Column(
        children: const [
          ProfileUsername(),
          _Email(),
          ProfilePassword(),
        ],
      ),
    );
  }
}

class _Email extends StatelessWidget {
  const _Email();

  @override
  Widget build(BuildContext context) {
    final String? email = context.select(
      (ProfileBloc bloc) => bloc.state.user?.email,
    );
    return ItemWithIcon(
      icon: MdiIcons.emailOutline,
      text: email ?? '--',
    );
  }
}

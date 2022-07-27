import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../../../components/item_with_icon.dart';
import '../../../components/username_editor.dart';
import '../../../config/slide_up_route_animation.dart';
import '../bloc/profile_bloc.dart';

class ProfileUsername extends StatefulWidget {
  const ProfileUsername({super.key});

  @override
  State<ProfileUsername> createState() => _ProfileUsernameState();
}

class _ProfileUsernameState extends State<ProfileUsername> {
  @override
  Widget build(BuildContext context) {
    final String? username = context.select(
      (ProfileBloc bloc) => bloc.state.user?.username,
    );
    return ItemWithIcon(
      icon: MdiIcons.accountOutline,
      text: username ?? '--',
      onTap: () => _onPressed(username, context),
    );
  }

  Future<void> _onPressed(String? username, BuildContext context) async {
    if (username != null) {
      final String? newUsername = await _askForNewUsername(
        username,
        context,
      );
      if (mounted && newUsername != null) {
        context.read<ProfileBloc>().add(
              ProfileEventChangeUsername(newUsername: newUsername),
            );
      }
    }
  }

  Future<String?> _askForNewUsername(
    String currentUsername,
    BuildContext context,
  ) async {
    return await Navigator.of(context).push(
      SlideUpRouteAnimation(
        page: UsernameEditor(currentUsername: currentUsername),
      ),
    );
  }
}

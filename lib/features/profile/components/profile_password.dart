import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../../../components/item_with_icon.dart';
import '../../../components/password_editor/bloc/password_editor_bloc.dart';
import '../../../components/password_editor/password_editor.dart';
import '../../../config/slide_up_route_animation.dart';
import '../bloc/profile_bloc.dart';

class ProfilePassword extends StatefulWidget {
  const ProfilePassword({super.key});

  @override
  State<ProfilePassword> createState() => _ProfilePasswordState();
}

class _ProfilePasswordState extends State<ProfilePassword> {
  @override
  Widget build(BuildContext context) {
    return ItemWithIcon(
      icon: MdiIcons.lockOutline,
      text: 'Zmień hasło',
      onTap: () => _onPressed(context),
    );
  }

  Future<void> _onPressed(BuildContext context) async {
    final PasswordEditorReturns? result = await _askForNewPassword(context);
    if (mounted && result != null) {
      context.read<ProfileBloc>().add(
            ProfileEventChangePassword(
              currentPassword: result.currentPassword,
              newPassword: result.newPassword,
            ),
          );
    }
  }

  Future<PasswordEditorReturns?> _askForNewPassword(
    BuildContext context,
  ) async {
    return await Navigator.of(context).push(
      SlideUpRouteAnimation(page: const PasswordEditor()),
    );
  }
}

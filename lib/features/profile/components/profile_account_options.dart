import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../../../components/item_with_icon.dart';
import '../../../components/section.dart';
import '../../../config/theme/colors.dart';
import '../bloc/profile_bloc.dart';

class ProfileAccountOptions extends StatelessWidget {
  const ProfileAccountOptions({super.key});

  @override
  Widget build(BuildContext context) {
    return Section(
      title: 'Konto',
      child: Column(
        children: [
          ItemWithIcon(
            icon: MdiIcons.logoutVariant,
            text: 'Wyloguj',
            onTap: () => _onSignOutPressed(context),
          ),
          const SizedBox(height: 8.0),
          ItemWithIcon(
            icon: MdiIcons.deleteOutline,
            text: 'Usuń konto',
            textColor: AppColors.red,
            iconColor: AppColors.red,
            borderColor: AppColors.red,
            onTap: () => _onRemoveAccountPressed(context),
          ),
        ],
      ),
    );
  }

  void _onSignOutPressed(BuildContext context) {
    context.read<ProfileBloc>().add(ProfileEventSignOut());
  }

  void _onRemoveAccountPressed(BuildContext context) {
    context.read<ProfileBloc>().add(ProfileEventDeleteAccount());
  }
}

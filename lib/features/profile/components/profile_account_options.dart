import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../../../providers/dialogs_provider.dart';
import '../../../components/dialogs/single_input_dialog/single_input_dialog.dart';
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

  Future<void> _onSignOutPressed(BuildContext context) async {
    final ProfileBloc profileBloc = context.read<ProfileBloc>();
    final bool confirmation = await _askForSignOutConfirmation();
    if (confirmation) {
      profileBloc.add(
        ProfileEventSignOut(),
      );
    }
  }

  Future<void> _onRemoveAccountPressed(BuildContext context) async {
    final ProfileBloc profileBloc = context.read<ProfileBloc>();
    final String? password = await _askForAccountDeletionConfirmationPassword();
    if (password != null) {
      profileBloc.add(
        ProfileEventDeleteAccount(password: password),
      );
    }
  }

  Future<bool> _askForSignOutConfirmation() async {
    return await DialogsProvider.askForConfirmation(
      title: 'Wylogowywanie',
      text: 'Czy na pewno chcesz się wylogować z tego konta?',
      confirmButtonText: 'Wyloguj',
    );
  }

  Future<String?> _askForAccountDeletionConfirmationPassword() async {
    return await DialogsProvider.askForValue(
      appBarTitle: 'Usuwanie konta',
      textFieldIcon: MdiIcons.lock,
      textFieldType: TextFieldType.password,
      textFieldLabel: 'Hasło',
      title: 'Czy na pewno chcesz usunąć konto?',
      message:
          'Usunięcie konta spowoduje również nieodwracalne usunięcie wszystkich danych powiązanych z tym kontem. Jeśli chcesz wykonać tą operację, potwierdź ją hasłem.',
      submitButtonLabel: 'Usuń',
    );
  }
}

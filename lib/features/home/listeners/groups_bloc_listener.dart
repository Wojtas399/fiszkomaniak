import 'package:fiszkomaniak/core/groups/groups_bloc.dart';
import 'package:fiszkomaniak/core/groups/groups_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../components/dialogs/dialogs.dart';
import '../../../config/navigation.dart';
import '../../../core/groups/groups_status.dart';

class GroupsBlocListener extends BlocListener<GroupsBloc, GroupsState> {
  final Function(int pageIndex) onHomePageChanged;

  GroupsBlocListener({
    Key? key,
    required this.onHomePageChanged,
  }) : super(
          key: key,
          listener: (BuildContext context, GroupsState state) {
            final GroupsStatus status = state.status;
            void closeLoadingDialog() {
              Navigator.of(context, rootNavigator: true).pop();
            }

            if (status is GroupsStatusLoading) {
              Dialogs.showLoadingDialog();
            } else if (status is GroupsStatusGroupAdded) {
              closeLoadingDialog();
              context.read<Navigation>().backHome();
              Dialogs.showSnackbarWithMessage('Pomyślnie dodano nową grupę');
              onHomePageChanged(0);
            } else if (status is GroupsStatusGroupUpdated) {
              closeLoadingDialog();
              Navigator.pop(context);
              Dialogs.showSnackbarWithMessage(
                'Pomyślnie zaktualizowano grupę',
              );
            } else if (status is GroupsStatusGroupRemoved) {
              closeLoadingDialog();
              context.read<Navigation>().backHome();
              Dialogs.showSnackbarWithMessage('Pomyślnie usunięto grupę');
            } else if (status is GroupsStatusError) {
              closeLoadingDialog();
              Dialogs.showErrorDialog(status.message);
            }
          },
        );
}

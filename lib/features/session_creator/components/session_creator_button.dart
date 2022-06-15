import 'package:fiszkomaniak/components/buttons/button.dart';
import 'package:fiszkomaniak/features/session_creator/bloc/session_creator_bloc.dart';
import 'package:fiszkomaniak/features/session_creator/bloc/session_creator_mode.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SessionCreatorButton extends StatelessWidget {
  const SessionCreatorButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SessionCreatorBloc, SessionCreatorState>(
      builder: (BuildContext context, SessionCreatorState state) {
        return Button(
          label: _getLabel(state.mode),
          onPressed: state.isButtonDisabled
              ? null
              : () {
                  context
                      .read<SessionCreatorBloc>()
                      .add(SessionCreatorEventSubmit());
                },
        );
      },
    );
  }

  String _getLabel(SessionCreatorMode mode) {
    if (mode is SessionCreatorCreateMode) {
      return 'dodaj';
    } else if (mode is SessionCreatorEditMode) {
      return 'zapisz';
    }
    return '';
  }
}

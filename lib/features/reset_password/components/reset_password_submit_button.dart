import 'package:fiszkomaniak/features/reset_password/bloc/reset_password_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../components/button.dart';
import '../bloc/reset_password_event.dart';
import '../bloc/reset_password_state.dart';

class ResetPasswordSubmitButton extends StatelessWidget {
  const ResetPasswordSubmitButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ResetPasswordBloc, ResetPasswordState>(
      builder: (context, state) {
        return Button(
          label: 'Wyślij',
          onPressed: () {
            context
                .read<ResetPasswordBloc>()
                .add(ResetPasswordEventSend(email: state.email));
          },
        );
      },
    );
  }
}

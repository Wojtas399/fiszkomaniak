import 'package:fiszkomaniak/features/sign_up/bloc/sign_up_bloc.dart';
import 'package:fiszkomaniak/features/sign_up/bloc/sign_up_event.dart';
import 'package:fiszkomaniak/features/sign_up/bloc/sign_up_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../components/buttons/button.dart';

class SignUpSubmitButton extends StatelessWidget {
  const SignUpSubmitButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpBloc, SignUpState>(
      builder: (context, state) {
        return Center(
          child: Button(
            label: 'Zarejestruj',
            onPressed:
                state.isDisabledButton ? null : () => _submit(context, state),
          ),
        );
      },
    );
  }

  void _submit(BuildContext context, SignUpState state) {
    context.read<SignUpBloc>().add(SignUpEventSubmit(
          username: state.username,
          email: state.email,
          password: state.password,
        ));
  }
}

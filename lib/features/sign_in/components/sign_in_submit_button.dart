import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../components/buttons/button.dart';
import '../../../utils/utils.dart';
import '../bloc/sign_in_bloc.dart';

class SignInSubmitButton extends StatelessWidget {
  const SignInSubmitButton({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isButtonDisabled = context.select(
      (SignInBloc bloc) => bloc.state.isButtonDisabled,
    );
    return Center(
      child: Button(
        label: 'Zaloguj',
        onPressed: isButtonDisabled ? null : () => _submit(context),
      ),
    );
  }

  void _submit(BuildContext context) {
    context.read<SignInBloc>().add(SignInEventSubmit());
    Utils.unfocusElements();
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../components/buttons/button.dart';
import '../../../utils/utils.dart';
import '../bloc/sign_up_bloc.dart';

class SignUpSubmitButton extends StatelessWidget {
  const SignUpSubmitButton({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isDisabled = context.select(
      (SignUpBloc bloc) => bloc.state.isButtonDisabled,
    );
    return Center(
      child: Button(
        label: 'Zarejestruj',
        onPressed: isDisabled ? null : () => _submit(context),
      ),
    );
  }

  void _submit(BuildContext context) {
    context.read<SignUpBloc>().add(SignUpEventSubmit());
    Utils.unfocusElements();
  }
}
